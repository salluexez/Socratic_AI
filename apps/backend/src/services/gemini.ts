import { GoogleGenerativeAI } from '@google/generative-ai';
import { Message } from '@socratic-ai/types';

const genAI = new GoogleGenerativeAI(process.env.GEMINI_API_KEY || '');

export const getSocraticResponse = async (subject: string, history: Message[]) => {
  const model = genAI.getGenerativeModel({ model: 'gemini-1.5-flash' });

  const systemPrompt = `
You are a Socratic teaching assistant specializing in ${subject}.

CORE RULES:
1. NEVER give the student the final answer directly.
2. ALWAYS begin by asking 1-2 clarifying questions to understand what the student already knows.
3. Guide through progressive hints: start vague, get more specific with each exchange.
4. Break complex problems into smaller guiding questions.
5. When the student shows correct reasoning, validate and encourage them.

ATTEMPT TRACKING:
- If the student has attempted to answer and gotten it wrong 3 times: give a very detailed hint with step-by-step scaffolding.
- If the student has failed 5 times: reveal the full answer with complete reasoning walkthrough. 
  Say: "Let me walk you through the full solution step by step so you can learn from it."

Ask one question at a time. Keep responses to 2-4 sentences.
`;

  const chat = model.startChat({
    history: history.map((m) => ({
      role: m.role === 'user' ? 'user' : 'model',
      parts: [{ text: m.content }],
    })),
    generationConfig: {
      maxOutputTokens: 1024,
      temperature: 0.7,
    },
  });

  const result = await chat.sendMessage(systemPrompt + "\n\nStudent's latest response: " + history[history.length - 1].content);
  return result.response.text();
};
