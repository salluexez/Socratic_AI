import mongoose, { Schema } from 'mongoose';
import { Session, Message } from '@socratic-ai/types';

const messageSchema = new Schema<Message>({
  role: { type: String, enum: ['user', 'assistant'], required: true },
  content: { type: String, required: true },
  timestamp: { type: Date, default: Date.now },
});

const sessionSchema = new Schema<Session>(
  {
    userId: { type: Schema.Types.ObjectId, ref: 'User', required: true },
    subject: {
      type: String,
      enum: ['physics', 'chemistry', 'math', 'biology'],
      required: true,
    },
    topic: { type: String },
    isActive: { type: Boolean, default: true },
    startedAt: { type: Date, default: Date.now },
    endedAt: { type: Date },
    duration: { type: Number },
    attemptCount: { type: Number, default: 0 },
    messages: [messageSchema],
  },
  { timestamps: true }
);

export const SessionModel = mongoose.model('Session', sessionSchema);
