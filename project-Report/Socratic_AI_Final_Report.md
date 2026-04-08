# PROJECT REPORT
**ON**
# Socratic AI: A Cross-Platform Teaching Assistant

**SUBMITTED IN PARTIAL FULFILLMENT FOR THE AWARD OF THE DEGREE OF**
**MASTER OF COMPUTER APPLICATIONS**

---

## DECLARATION
I hereby declare that the Report entitled **"Socratic AI"** is an authentic record of my work during the period from January 2024 to June 2024 as per the requirement of the university for partial fulfillment for the award of the degree of MCA.

**Dated:** 06/04/2026

---

## ACKNOWLEDGEMENTS
We take immense pleasure in thanking everyone who has helped us to conceive and develop the project. We express our heartfelt gratitude to the Department of Computer Science and Informatics for providing this opportunity to carry out the major project work.

We wish to express our deep sense of gratitude to our Internal Guide for their valuable suggestions and corrections, which had a great impact on completing the project work within the timeframe. We also sincerely thank our parents and friends for their support and well-wishes.

---

## ABSTRACT
The project entitled **"Socratic AI"** utilizes a combination of cutting-edge software technologies to develop a robust system aimed at addressing the specific educational needs of students who seek understanding rather than just quick answers. The platform employs the Socratic method, guiding learners through structured questioning and progressive scaffolding. Built using a monorepo architecture with Next.js, Express, MongoDB, and Flutter, the project demonstrates a comprehensive approach to modern software development. Our project’s primary objectives include providing a user-centric interface, enhancing pedagogical effectiveness through AI, and ensuring seamless cross-platform continuity.

---

## 1. INTRODUCTION

### 1.1 Background
In the modern era of education, students are increasingly turning to AI tools for assistance. However, most existing tools optimize for speed, often providing direct answers that lead to passive learning. Socratic AI is designed to reverse this trend by implementing the Socratic Method—a form of cooperative argumentative dialogue to stimulate critical thinking.

### 1.2 Problem Statement
Students frequently rely on AI to "do their homework" rather than "help them learn." This results in a lack of retention and reasoning skills. Socratic AI addresses this by refusing to give answers until the student has actively engaged with the concepts.

### 1.3 Objectives
- To implement a Socratic chat interface that provides progressive hints.
- To develop a secure backend for session persistence and user management.
- To create a cross-platform experience via a Next.js web app and a Flutter mobile app.
- To utilize Large Language Models (Llama 3.1) for specialized tutoring logic.

### 1.4 Scope of the Project
The project explores various topics, from pedagogical concepts to high-performance computing:
- **AI Tutoring**: Researching prompt engineering and Socratic methodologies.
- **Cross-Platform Sync**: Ensuring real-time data consistency between web and mobile.
- **Persistence**: Managing complex chat histories and user progress in NoSQL databases.
- **Infrastructure**: Deployment and orchestration using Turborepo and Vercel/Render.

### 1.5 Organization of the Report
This report is structured to guide the reader through the development journey, from initial concept to final implementation, covering system analysis, design, implementation details, and testing results.

---

## 2. LITERATURE REVIEW

### 2.1 Review of Existing Work
Educational platforms like Khan Academy and Duolingo have integrated AI to provide instant feedback. However, these systems often remain constrained to specific tracks. General-purpose AI like ChatGPT provides answers but lacks the pedagogical constraints required for deep learning.

### 2.2 Identification of Gaps in the Literature
Most studies on AI in education focus on automated grading or direct query resolution. There is a lack of focus on "constructivist" AI tutors that actively prevent the delivery of answers to foster student discovery.

### 2.3 Relevance of the Project in the Current Context
With the rise of remote learning, a tool that replicates the experience of a 1-on-1 human tutor is highly relevant. Socratic AI fills this market vacuum by providing a dedicated environment for "learning how to think."

---

## 3. SYSTEM ANALYSIS

### 3.1 Advantages of the Monorepo / Incremental Model
- **Modularity**: Individual apps (web, backend, script) can be developed independently.
- **Consistency**: Shared types ensures that the API and frontend remain in sync.
- **Rapid Iteration**: New subjects and features can be added incrementally to the AI core.

### 3.2 Existing Systems
- **ChatGPT**: General purpose, often too direct.
- **Socratic by Google**: Focuses on search, not interactive dialogue.

### 3.3 Proposed System
An integrated system consisting of four main modules:
1. **Web Dashboard**: Student interface for subject selection and profile management.
2. **AI Tutor Service**: Dedicated logic for Socratic responses and topic summarization.
3. **Synchronization Backend**: Central hub for data and authentication.
4. **Mobile Companion**: Flutter-based app for learning on-the-go.

### 3.4 Functional Objectives
- Service providers/Admins should be able to manage tutor prompts.
- Students should be able to create accounts and resume sessions across devices.
- AI should automatically reveal the answer after 5 failed attempts.

### 3.5 Non-Functional Objectives
- **Security**: JWT-based authentication and secure password hashing.
- **Availability**: 24/7 access to the tutoring service.
- **Scalability**: Capable of handling multiple concurrent chat sessions.

### 3.6 Software Technologies Used
| Layer | Technology |
|---|---|
| Monorepo | Turborepo, Bun |
| Frontend | Next.js, Tailwind CSS, Framer Motion |
| Mobile | Flutter |
| Backend | Node.js, Express, Mongoose |
| AI Service| Python, FastAPI, Groq (Llama 3.1) |
| Database | MongoDB |

---

## 4. SYSTEM DESIGN

### 4.1 System Architecture
Socratic AI follows a multi-tier architecture where the **Next.js/Flutter** clients interact with an **Express API**, which in turn delegates AI logic to a **Python Tutor Service** powered by LLMs.

### 4.2 Sequence Diagram
1. User sends a message via Web/Mobile.
2. Backend validates JWT and retrieves session history from MongoDB.
3. Backend calls Python Service with history + new message.
4. Python Service generates a Socratic response using Groq.
5. Response is saved and returned to the user.

### 4.3 Database Design (User & Session)
The `Session` model is critical, tracking the subject, messages, and the `attemptCount` for the auto-reveal logic.

---

## 5. IMPLEMENTATION

### 5.1 Implementation Details
The project was built using an incremental approach. The development environment consisted of **VS Code** with **Bun** as the package manager for high performance. 

### 5.2 Code Snippets (Core Socratic Logic)
The core logic resides in the Python service (`socratic.py`), enforcing strict pedagogical rules in the system prompt:
```python
system_content = """You are a supportive Socratic tutor.
STRICT RULES:
- NEVER give the definition or answer directly.
- Instead, ask questions about what they already know.
- Keep responses short (1-2 lines max)."""
```

---

## 6. TESTING

### 6.1 Testing Methodology
- **Unit Testing**: Testing individual API endpoints for auth and sessions.
- **Integration Testing**: Ensuring the Python service communicates correctly with the Node.js backend.
- **User Interface Testing**: Verifying responsiveness and animation smoothness.

### 6.2 Testing Results
| Test Name | Description | Result |
|---|---|---|
| JWT Auth | Verify login and token persistence | PASS |
| Socratic Response | Ensure AI asks questions instead of answering | PASS |
| Cross-Platform Sync| Message on Web appears on Mobile | PASS |
| Auto-Reveal | Answer revealed after 5th attempt | PASS |

---

## 7. CONCLUSION AND FUTURE WORK

### 7.1 Conclusion
Socratic AI demonstrates the potential of LLMs to go beyond simple information retrieval. By implementing the Socratic method, the project provides a truly interactive and pedagogical experience that bridges the gap between web and mobile.

### 7.2 Future Work
- **Gamification**: Adding streaks, XP, and badges to motivate students.
- **Spaced Repetition**: Suggesting topics to revisit based on past performance.
- **Voice Support**: Allowing students to talk to their tutor hands-free.

---

## REFERENCES
- Groq API Documentation
- Next.js Documentation
- MongoDB Mongoose Reference
- Flutter Development Guide
- The Socratic Method in Modern Pedagogy
