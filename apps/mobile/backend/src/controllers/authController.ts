import { Request, Response } from 'express';
import { UserModel } from '../models/User';
import { ChatModel } from '../models/Chat';
import { signToken } from '../utils/jwt';
import bcrypt from 'bcrypt';

export const signup = async (req: Request, res: Response) => {
  const { name, email, password } = req.body;

  try {
    const userExists = await UserModel.findOne({ email });
    if (userExists) {
      return res.status(400).json({ success: false, error: 'User already exists' });
    }

    const user = await UserModel.create({ name, email, password });
    const token = signToken({ id: user._id });

    res.cookie('token', token, {
      httpOnly: true,
      secure: process.env.NODE_ENV === 'production',
      maxAge: 7 * 24 * 60 * 60 * 1000, // 7 days
    });

    res.status(201).json({
      success: true,
      data: { id: user._id, name: user.name, email: user.email },
    });
  } catch (error) {
    res.status(500).json({ success: false, error: 'Server error during signup' });
  }
};

export const signin = async (req: Request, res: Response) => {
  const { email, password } = req.body;

  try {
    const user = await UserModel.findOne({ email });
    if (!user) {
      return res.status(401).json({ success: false, error: 'Invalid credentials' });
    }

    const isMatch = await bcrypt.compare(password, user.password);
    if (!isMatch) {
      return res.status(401).json({ success: false, error: 'Invalid credentials' });
    }

    const token = signToken({ id: user._id });

    res.cookie('token', token, {
      httpOnly: true,
      secure: process.env.NODE_ENV === 'production',
      maxAge: 7 * 24 * 60 * 60 * 1000,
    });

    res.json({
      success: true,
      data: { id: user._id, name: user.name, email: user.email },
    });
  } catch (error) {
    res.status(500).json({ success: false, error: 'Server error during signin' });
  }
};

export const logout = (req: Request, res: Response) => {
  res.clearCookie('token');
  res.json({ success: true, message: 'Logged out successfully' });
};

export const getMe = (req: Request, res: Response) => {
  res.json({ success: true, data: (req as any).user });
};
export const updateMe = async (req: Request, res: Response) => {
  const { name } = req.body;
  const user = (req as any).user;

  try {
    user.name = name || user.name;
    await user.save();

    res.json({
      success: true,
      data: { id: user._id, name: user.name, email: user.email },
    });
  } catch (error) {
    res.status(500).json({ success: false, error: 'Server error during profile update' });
  }
};

export const deleteMe = async (req: Request, res: Response) => {
  const user = (req as any).user;

  try {
    // Delete all chats associated with the user
    await ChatModel.deleteMany({ userId: user._id });

    // Delete the user record
    await UserModel.findByIdAndDelete(user._id);

    // Clear the auth cookie
    res.clearCookie('token');

    res.json({
      success: true,
      message: 'Account and associated data deleted successfully',
    });
  } catch (error) {
    res.status(500).json({ success: false, error: 'Server error during account deletion' });
  }
};
