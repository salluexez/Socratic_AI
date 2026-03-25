import { Request, Response } from 'express';
import { ChatModel } from '../models/Chat';
import { getSocraticResponse, generateTopic } from '../services/socratic';

export const sendMessage = async (req: Request, res: Response) => {
  const { sessionId, content } = req.body;
  const userId = (req as any).user._id;

  try {
    // We use sessionId as the chatId
    console.log(`Chat Request: sessionId="${sessionId}", userId="${userId}"`);
    const chat = await ChatModel.findOne({ _id: sessionId, userId });
    
    if (!chat) {
      console.warn(`Chat lookup failed for sessionId="${sessionId}", userId="${userId}"`);
      return res.status(404).json({ success: false, error: 'Active chat session not found' });
    }

    if (!chat.isActive) {
      console.warn(`Chat found but is inactive: sessionId="${sessionId}"`);
      return res.status(404).json({ success: false, error: 'Active chat session not found' });
    }

    // Add user message
    const userMessage = { 
      role: 'user' as const, 
      content, 
      timestamp: new Date() 
    };
    chat.messages.push(userMessage);
    
    // Increment stats
    chat.attemptCount = (chat.attemptCount || 0) + 1;
    chat.duration = (chat.duration || 0) + 300; // +5 minutes per interaction

    // Call Socratic AI service
    const history = chat.messages.slice(0, -1).map(m => ({
      role: m.role,
      content: m.content
    }));

    const socraticResult = await getSocraticResponse(chat.subject, history, content);
    
    const aiMessage = { 
      role: 'assistant' as const, 
      content: socraticResult.reply, 
      timestamp: new Date() 
    };
    chat.messages.push(aiMessage);
    
    /* 
    // Auto-name the session if it's the first message
    if (chat.messages.length <= 2 && (!chat.topic || chat.topic.startsWith('Exploration of'))) {
      if (socraticResult.isIrrelevant) {
        chat.topic = 'Invalid Context';
      } else {
        chat.topic = await generateTopic(content);
      }
    }
    */
    
    await chat.save();

    res.json({ 
      success: true, 
      data: aiMessage,
      topic: chat.topic,
      isIrrelevant: socraticResult.isIrrelevant 
    });
  } catch (error: any) {
    console.error('Chat Controller Error:', error);
    res.status(500).json({ success: false, error: error.message || 'Failed to process message' });
  }
};
