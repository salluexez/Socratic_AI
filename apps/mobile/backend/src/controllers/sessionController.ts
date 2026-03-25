import { Request, Response } from 'express';
import { ChatModel } from '../models/Chat';
import { UserModel } from '../models/User';
import mongoose from 'mongoose';

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
    // Find session where user is owner OR a collaborator
    const chat = await ChatModel.findOne({
      _id: id,
      $or: [
        { userId },
        { 'collaborators.userId': userId }
      ]
    });

    if (!chat) {
      return res.status(404).json({ success: false, error: 'Session not found or access denied' });
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
export const renameSession = async (req: Request, res: Response) => {
  const { id } = req.params;
  const { topic } = req.body;
  const userId = (req as any).user._id;

  try {
    console.log(`Renaming session ${id} for user ${userId} to "${topic}"`);
    
    const chat = await ChatModel.findOne({ _id: id, userId });

    if (!chat) {
      console.warn(`Session ${id} not found for user ${userId} during rename`);
      return res.status(404).json({ success: false, error: 'Session not found' });
    }

    chat.topic = topic;
    await chat.save();

    console.log(`Session ${id} renamed successfully`);
    res.json({ success: true, data: chat });
  } catch (error) {
    console.error('Rename Session Error:', error);
    res.status(500).json({ success: false, error: 'Failed to rename session' });
  }
};

export const shareSession = async (req: Request, res: Response) => {
  const { id } = req.params;
  const { email } = req.body;
  const userId = (req as any).user._id;

  try {
    // 1. Find the session and verify ownership
    const session = await ChatModel.findOne({ _id: id, userId });
    if (!session) {
      return res.status(404).json({ success: false, error: 'Session not found or you are not the owner' });
    }

    // 2. Find the target user by email
    const targetUser = await UserModel.findOne({ email });
    if (!targetUser) {
      return res.status(404).json({ success: false, error: 'User with this email not found' });
    }

    // 3. Prevent sharing with self
    if (targetUser._id.toString() === userId.toString()) {
      return res.status(400).json({ success: false, error: 'You cannot share a session with yourself' });
    }

    // 4. Check if already shared
    const isAlreadyShared = session.collaborators.some(
      (c) => c.userId.toString() === targetUser._id.toString()
    );

    if (isAlreadyShared) {
      return res.status(400).json({ success: false, error: 'Session already shared with this user' });
    }

    // 5. Add as collaborator (read-only by default as per requirement)
    session.collaborators.push({
      userId: targetUser._id as mongoose.Types.ObjectId,
      access: 'read'
    });

    await session.save();

    // No notification needed, app uses background polling

    res.json({ success: true, message: `Session shared with ${targetUser.name} successfully` });
  } catch (error) {
    console.error('Share Session Error:', error);
    res.status(500).json({ success: false, error: 'Failed to share session' });
  }
};

export const getSharedToMe = async (req: Request, res: Response) => {
  const userId = (req as any).user._id;

  try {
    const chats = await ChatModel.find({
      'collaborators.userId': userId
    })
    .populate('userId', 'name email') // Populate owner info
    .sort({ updatedAt: -1 });

    res.json({ success: true, data: chats });
  } catch (error) {
    console.error('Get Shared To Me Error:', error);
    res.status(500).json({ success: false, error: 'Failed to fetch shared sessions' });
  }
};

export const getSharedByMe = async (req: Request, res: Response) => {
  const userId = (req as any).user._id;

  try {
    const chats = await ChatModel.find({
      userId,
      collaborators: { $exists: true, $not: { $size: 0 } }
    })
    .populate('collaborators.userId', 'name email')
    .sort({ updatedAt: -1 });

    res.json({ success: true, data: chats });
  } catch (error) {
    console.error('Get Shared By Me Error:', error);
    res.status(500).json({ success: false, error: 'Failed to fetch sessions shared by you' });
  }
};

export const removeCollaborator = async (req: Request, res: Response) => {
  const { id, collaboratorId } = req.params;
  const userId = (req as any).user._id;

  try {
    const session = await ChatModel.findOneAndUpdate(
      { _id: id, userId },
      { $pull: { collaborators: { userId: collaboratorId } } },
      { new: true }
    ).populate('collaborators.userId', 'name email');

    if (!session) {
      return res.status(404).json({ success: false, error: 'Session not found or access denied' });
    }

    res.json({ success: true, data: session, message: 'Collaborator removed successfully' });
  } catch (error) {
    console.error('Remove Collaborator Error:', error);
    res.status(500).json({ success: false, error: 'Failed to remove collaborator' });
  }
};

export const unshareSession = async (req: Request, res: Response) => {
  const { id } = req.params;
  const userId = (req as any).user._id;

  try {
    const session = await ChatModel.findOneAndUpdate(
      { _id: id, userId },
      { $set: { collaborators: [] } },
      { new: true }
    );

    if (!session) {
      return res.status(404).json({ success: false, error: 'Session not found or access denied' });
    }

    res.json({ success: true, message: 'All sharing access removed successfully' });
  } catch (error) {
    console.error('Unshare Session Error:', error);
    res.status(500).json({ success: false, error: 'Failed to unshare session' });
  }
};
