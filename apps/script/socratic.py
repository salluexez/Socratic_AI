from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
from groq import Groq
import os
from dotenv import load_dotenv
import uvicorn

# ------------------------
# load environment
# ------------------------

load_dotenv()

groq_api_key = os.getenv("GROQ_API_KEY")

if not groq_api_key:
    raise ValueError("Please add GROQ API key in .env file")

client = Groq(api_key=groq_api_key)

# ------------------------
# create app
# ------------------------

app = FastAPI(title="Socratic AI")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# ------------------------
# models
# ------------------------

class MessageItem(BaseModel):
    role: str
    content: str


class ChatRequest(BaseModel):

    topic: str
    history: list[MessageItem]
    message: str
    revealAnswer: bool = False   # important


class ChatResponse(BaseModel):

    reply: str
    isIrrelevant: bool


# ------------------------
# AI logic
# ------------------------

def ask_ai(topic, history, question, reveal):
    # REVEAL ANSWER MODE
    if reveal:
        messages = [
            {"role": "system", "content": f"You are an expert teacher of {topic}. Based on the conversation history below, provide the FINAL COMPLETE SOLUTION and ANSWER. Do not ask any more questions. Be direct and clear. If the question is not related to {topic}, refuse to answer and remind the user of the current subject."}
        ]
        # Include history for context
        for msg in history[-10:]:
            messages.append({"role": msg.role, "content": msg.content})
        messages.append({"role": "user", "content": question})
    # NORMAL SOCRATIC MODE
    else:
        messages = [
            {"role": "system", "content": f"""You are a supportive Socratic tutor for {topic}. 
            Goal: Guide the student to discover concepts on their own.
            STRICT RULES:
            - STRICT SUBJECT CONSTRAINT: You are strictly a {topic} tutor. If the user asks a question about ANY OTHER academic subject (e.g. asking a math question in a chemistry session) or something completely unrelated, you MUST refuse to answer and reply EXACTLY with: "I'd love to help, but let's stay focused on learning {topic}!"
            - NEVER give the definition, name, or answer, even as a question (e.g., don't say "Is it a table?").
            - Instead, ask them about where they've seen it or what they think the term sounds like. 
            - Example for "what is a matrix": "That's a powerful tool! Before we dive in, have you ever seen data organized in a grid, like in a spreadsheet?"
            - Keep responses very short (1-2 lines max).
            """}
        ]
        # Include context
        for msg in history[-10:]:
            messages.append({"role": msg.role, "content": msg.content})
        messages.append({"role": "user", "content": question})

    completion = client.chat.completions.create(
        model="llama-3.1-8b-instant",
        messages=messages,
        temperature=0.3
    )

    reply = completion.choices[0].message.content.strip()
    # conversational irrelevant check
    is_irrelevant = "STAY FOCUSED" in reply.upper()
    return reply, is_irrelevant


# ------------------------
# routes
# ------------------------

@app.get("/")
def home():

    return {

        "message": "Socratic AI running"
    }


@app.get("/health")

def health():

    return {

        "status": "ok"
    }


@app.post("/chat", response_model=ChatResponse)

def chat(req: ChatRequest):

    reply, irrelevant = ask_ai(

        req.topic,

        req.history,

        req.message,

        req.revealAnswer
    )

    return {

        "reply": reply,

        "isIrrelevant": irrelevant
    }


@app.post("/generate-topic")

def generate_topic(req: dict):

    message = req.get("message", "")

    if not message:

        return {"topic": "New Session"}


    completion = client.chat.completions.create(

        model="llama-3.1-8b-instant",

        messages=[

            {

                "role": "system",

                "content": "You are a concise summarizer. Summarize the following question/topic into a 2-3 word title. Use title case. No punctuation."

            },

            {

                "role": "user",

                "content": message

            }

        ],

        max_tokens=10,

        temperature=0.3

    )


    topic = completion.choices[0].message.content.strip()

    return {"topic": topic}


# ------------------------
# run server
# ------------------------


if __name__ == "__main__":

    import uvicorn

    uvicorn.run(
        app,
        host="127.0.0.1",
        port=8000
    )