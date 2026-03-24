import { Request, Response } from 'express';
import { SessionModel } from '../models/Session';
import { getSocraticResponse } from '../services/gemini';

export const sendMessage = async (req: Request, res: Response) => {
  const { sessionId, content } = req.body;
  const userId = (req as any).user._id;

  try {
    const session = await SessionModel.findOne({ _id: sessionId, userId });
    if (!session || !session.isActive) {
      return res.status(404).json({ success: false, error: 'Active session not found' });
    }

    // Add user message
    const userMessage = { role: 'user' as const, content, timestamp: new Date() };
    session.messages.push(userMessage);

    // Call Gemini for Socratic response
    // In a real scenario, we'd also pass attempt counting logic here
    const aiResponseContent = await getSocraticResponse(session.subject, session.messages, session.attemptCount);
    
    const aiMessage = { role: 'assistant' as const, content: aiResponseContent, timestamp: new Date() };
    session.messages.push(aiMessage);
    
    // Update session (e.g., attemptCount if wrong answer detected)
    // For simplicity in this initial setup, we increments attempts on every user message
    // A more sophisticated system would check the content for "wrong" answers
    session.attemptCount += 1;

    await session.save();

    res.json({ success: true, data: aiMessage });
  } catch (error) {
    console.error(error);
    res.status(500).json({ success: false, error: 'Failed to process message' });
  }
};
