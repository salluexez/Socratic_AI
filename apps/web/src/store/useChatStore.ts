import { create } from 'zustand';
import { Session, Message } from '@socratic-ai/types';
import api from '@/lib/api';

interface ChatState {
  currentSession: Session | null;
  loading: boolean;
  error: string | null;
  startSession: (subject: string) => Promise<void>;
  sendMessage: (content: string) => Promise<void>;
  fetchSession: (sessionId: string) => Promise<void>;
}

export const useChatStore = create<ChatState>((set, get) => ({
  currentSession: null,
  loading: false,
  error: null,
  startSession: async (subject: string) => {
    set({ loading: true, error: null });
    try {
      const response = await api.post('/sessions', { subject });
      if (response.data.success) {
        set({ currentSession: response.data.data, loading: false });
      }
    } catch (error) {
      set({ error: 'Failed to start session', loading: false });
    }
  },
  sendMessage: async (content: string) => {
    const { currentSession } = get();
    if (!currentSession) return;

    set({ loading: true });
    try {
      const response = await api.post('/chat', { sessionId: currentSession.id, content });
      if (response.data.success) {
        // Update local session messages
        const updatedSession = { ...currentSession };
        updatedSession.messages.push({ role: 'user', content, timestamp: new Date() });
        updatedSession.messages.push(response.data.data); // AI response
        set({ currentSession: updatedSession, loading: false });
      }
    } catch (error) {
      set({ error: 'Failed to send message', loading: false });
    }
  },
  fetchSession: async (sessionId: string) => {
    set({ loading: true });
    try {
      const response = await api.get(`/sessions/${sessionId}`);
      if (response.data.success) {
        set({ currentSession: response.data.data, loading: false });
      }
    } catch (error) {
      set({ error: 'Failed to fetch session', loading: false });
    }
  },
}));
