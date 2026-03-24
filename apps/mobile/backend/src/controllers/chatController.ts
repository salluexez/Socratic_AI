import { Request, Response } from 'express';
import { ChatModel } from '../models/Chat';
import { getSocraticResponse } from '../services/socratic';

export const sendMessage = async (req: Request, res: Response) => {
  const { sessionId, content } = req.body;
  const userId = (req as any).user._id;

  try {
    // We use sessionId as the chatId
    const chat = await ChatModel.findOne({ _id: sessionId, userId });
    
    if (!chat || !chat.isActive) {
      return res.status(404).json({ success: false, error: 'Active chat session not found' });
    }

    // Add user message
    const userMessage = { 
      role: 'user' as const, 
      content, 
      timestamp: new Date() 
    };
    chat.messages.push(userMessage);

    // Call Socratic AI service
    // history excludes the current message as it's passed separately
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
    
    await chat.save();

    res.json({ 
      success: true, 
      data: aiMessage,
      isIrrelevant: socraticResult.isIrrelevant 
    });
  } catch (error: any) {
    console.error('Chat Controller Error:', error);
    res.status(500).json({ success: false, error: error.message || 'Failed to process message' });
  }
};
