import dotenv from 'dotenv';

dotenv.config();

const SOCRATIC_AI_URL = process.env.SOCRATIC_AI_URL || 'http://localhost:8000';

export interface ISocraticMessage {
  role: 'user' | 'assistant';
  content: string;
}

export interface ISocraticResponse {
  reply: string;
  isIrrelevant: boolean;
}

export const getSocraticResponse = async (
  topic: string,
  history: ISocraticMessage[],
  message: string
): Promise<ISocraticResponse> => {
  try {
    const response = await fetch(`${SOCRATIC_AI_URL}/chat`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({
        topic,
        history,
        message,
      }),
    });

    if (!response.ok) {
      const errorData = await response.json().catch(() => ({}));
      console.error('Socratic AI Service Error:', errorData || response.statusText);
      throw new Error(errorData.detail || 'Failed to communicate with Socratic AI service');
    }

    const data = await response.json() as ISocraticResponse;
    return data;
  } catch (error: any) {
    console.error('Socratic AI Fetch Error:', error.message);
    throw error;
  }
};
