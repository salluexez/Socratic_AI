export interface User {
  id: string;
  name: string;
  email: string;
  createdAt: Date;
  updatedAt: Date;
}

export interface Message {
  role: 'user' | 'assistant';
  content: string;
  timestamp: Date;
}

export interface Session {
  id: string;
  userId: string;
  subject: 'physics' | 'chemistry' | 'math' | 'biology';
  topic?: string;
  isActive: boolean;
  startedAt: Date;
  endedAt?: Date;
  duration?: number;
  attemptCount: number;
  messages: Message[];
  createdAt: Date;
  updatedAt: Date;
}

export interface ApiResponse<T> {
  success: boolean;
  data?: T;
  error?: string;
}
