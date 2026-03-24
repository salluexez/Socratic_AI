import { Request, Response } from 'express';
import { ChatModel } from '../models/Chat';

export const createSession = async (req: Request, res: Response) => {
  const { subject } = req.body;
  const userId = (req as any).user._id;

  try {
    // End existing active sessions for this user and subject
    await ChatModel.updateMany(
      { userId, subject, isActive: true }, 
      { isActive: false }
    );

    const chat = await ChatModel.create({
      userId,
      subject,
      messages: [],
      isActive: true
    });

    res.status(201).json({ success: true, data: chat });
  } catch (error) {
    console.error('Create Session Error:', error);
    res.status(500).json({ success: false, error: 'Failed to create session' });
  }
};

export const getSessions = async (req: Request, res: Response) => {
  const userId = (req as any).user._id;
  const { subject } = req.query;

  try {
    const filter: any = { userId };
    if (subject) filter.subject = subject;

    const chats = await ChatModel.find(filter).sort({ createdAt: -1 });
    res.json({ success: true, data: chats });
  } catch (error) {
    console.error('Get Sessions Error:', error);
    res.status(500).json({ success: false, error: 'Failed to fetch sessions' });
  }
};

export const getSessionById = async (req: Request, res: Response) => {
  const { id } = req.params;
  const userId = (req as any).user._id;

  try {
    const chat = await ChatModel.findOne({ _id: id, userId });
    if (!chat) {
      return res.status(404).json({ success: false, error: 'Session not found' });
    }
    res.json({ success: true, data: chat });
  } catch (error) {
    console.error('Get Session By ID Error:', error);
    res.status(500).json({ success: false, error: 'Failed to fetch session' });
  }
};

export const endSession = async (req: Request, res: Response) => {
  const { id } = req.params;
  const userId = (req as any).user._id;

  try {
    const chat = await ChatModel.findOneAndUpdate(
      { _id: id, userId },
      { isActive: false },
      { new: true }
    );
    
    if (!chat) {
      return res.status(404).json({ success: false, error: 'Session not found' });
    }

    res.json({ success: true, data: chat });
  } catch (error) {
    console.error('End Session Error:', error);
  }
};

export const deleteSession = async (req: Request, res: Response) => {
  const { id } = req.params;
  const userId = (req as any).user._id;

  try {
    const result = await ChatModel.deleteOne({ _id: id, userId });
    
    if (result.deletedCount === 0) {
      return res.status(404).json({ success: false, error: 'Session not found' });
    }

    res.json({ success: true, message: 'Session deleted successfully' });
  } catch (error) {
    console.error('Delete Session Error:', error);
    res.status(500).json({ success: false, error: 'Failed to delete session' });
  }
};
