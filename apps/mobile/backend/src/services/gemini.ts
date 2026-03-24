import { GoogleGenerativeAI } from '@google/generative-ai';
import { Message } from '@socratic-ai/types';

const genAI = new GoogleGenerativeAI(process.env.GEMINI_API_KEY || '');

export const getSocraticResponse = async (subject: string, history: Message[], attemptCount: number) => {
  const model = genAI.getGenerativeModel({ model: 'gemini-3.1-flash' });

  const systemPrompt = `
You are a Socratic teaching assistant specializing in ${subject}.

CORE RULES:
1. NEVER give the student the final answer directly.
2. ALWAYS begin by asking 1-2 clarifying questions to understand what the student already knows.
3. Guide through progressive hints: start vague, get more specific with each exchange.
4. Break complex problems into smaller guiding questions.
5. When the student shows correct reasoning, validate and encourage them.

Socratic Scaffolding based on Attempts:
- Current Student Attempts: ${attemptCount}
- If attempts >= 3: Provide a very detailed hint with step-by-step scaffolding.
- If attempts >= 5: Reveal the full answer with complete reasoning walkthrough. 
  Say: "Let me walk you through the full solution step by step so you can learn from it."

Ask one question at a time. Keep responses to 2-4 sentences. Use LaTeX ($...$ for inline, $$...$$ for block) for math/equations.
`;

  const chat = model.startChat({
    history: history.slice(0, -1).map((m) => ({
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

export const getTopicSummary = async (history: Message[]) => {
  const model = genAI.getGenerativeModel({ model: 'gemini-1.5-flash' });
  const transcript = history.map(m => `${m.role}: ${m.content}`).join('\n');
  
  const prompt = `Summarize the main academic topic of this conversation in 3-5 words (e.g., "Newton's Second Law", "Quadratic Equations"). Return ONLY the summary text.\n\nTranscript:\n${transcript}`;
  
  const result = await model.generateContent(prompt);
  return result.response.text().trim();
};
