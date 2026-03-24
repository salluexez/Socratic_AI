"use client";

import { useEffect, useState, useRef } from "react";
import { useParams, useRouter } from "next/navigation";
import { useAuthStore } from "@/store/useAuthStore";
import { useChatStore } from "@/store/useChatStore";
import { Send, ArrowLeft, Lightbulb, RefreshCcw, HelpCircle } from "lucide-react";
import Link from "next/link";
import { clsx } from "clsx";

export default function ChatPage() {
  const { subject } = useParams() as { subject: string };
  const { user, checkAuth, loading: authLoading } = useAuthStore();
  const { currentSession, startSession, sendMessage, loading: chatLoading, error } = useChatStore();
  const [input, setInput] = useState("");
  const scrollRef = useRef<HTMLDivElement>(null);
  const router = useRouter();

  useEffect(() => {
    checkAuth();
  }, [checkAuth]);

  useEffect(() => {
    if (!authLoading && !user) router.push("/login");
  }, [user, authLoading, router]);

  useEffect(() => {
    if (user && !currentSession) {
      startSession(subject);
    }
  }, [user, currentSession, startSession, subject]);

  useEffect(() => {
    if (scrollRef.current) {
      scrollRef.current.scrollTop = scrollRef.current.scrollHeight;
    }
  }, [currentSession?.messages]);

  if (authLoading || !user) return <div className="flex items-center justify-center min-h-screen">Loading...</div>;

  const handleSend = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!input.trim() || chatLoading) return;
    const msg = input;
    setInput("");
    await sendMessage(msg);
  };

  return (
    <div className="flex flex-col h-screen bg-slate-50/50">
      {/* Header */}
      <header className="px-8 py-5 glass flex items-center justify-between shrink-0 z-10">
        <div className="flex items-center gap-4">
          <Link href="/dashboard" className="p-2 -ml-2 rounded-full hover:bg-slate-100 transition-colors text-slate-500">
            <ArrowLeft size={20} />
          </Link>
          <div className="font-bold text-slate-900 tracking-tight capitalize">
            {subject} <span className="text-blue-600 font-medium">Assistant</span>
          </div>
        </div>
        <div className="flex items-center gap-4">
          <div className="px-4 py-1.5 rounded-full bg-slate-100 text-xs font-bold text-slate-500 flex items-center gap-2">
            Attempt {currentSession?.attemptCount || 0} / 5
          </div>
          <button className="p-2 rounded-full bg-slate-100 text-slate-500 hover:text-blue-600 hover:bg-blue-50 transition-all">
             <RefreshCcw size={18} />
          </button>
        </div>
      </header>

      {/* Chat Area */}
      <div 
        ref={scrollRef}
        className="flex-grow overflow-y-auto px-4 py-8 space-y-8 flex flex-col items-center"
      >
        <div className="w-full max-w-3xl space-y-8">
          {currentSession?.messages.map((m, i) => (
            <div 
              key={i} 
              className={clsx(
                "flex w-full",
                m.role === 'user' ? "justify-end" : "justify-start"
              )}
            >
              <div className={clsx(
                "max-w-[85%] p-6 rounded-[2rem] text-[15px] leading-relaxed",
                m.role === 'user' 
                  ? "bg-slate-900 text-white rounded-tr-lg shadow-xl" 
                  : "bg-white text-slate-800 rounded-tl-lg shadow-tonal border border-slate-100"
              )}>
                {m.content}
              </div>
            </div>
          ))}
          {chatLoading && (
            <div className="flex justify-start">
              <div className="p-6 rounded-[2rem] rounded-tl-lg bg-white border border-slate-50 shadow-sm flex gap-1">
                <span className="w-1.5 h-1.5 rounded-full bg-slate-200 animate-bounce"></span>
                <span className="w-1.5 h-1.5 rounded-full bg-slate-200 animate-bounce [animation-delay:0.2s]"></span>
                <span className="w-1.5 h-1.5 rounded-full bg-slate-200 animate-bounce [animation-delay:0.4s]"></span>
              </div>
            </div>
          )}
        </div>
      </div>

      {/* Input Area */}
      <div className="p-8 shrink-0 bg-transparent">
        <div className="max-w-3xl mx-auto space-y-4">
          {/* Quick Actions */}
          <div className="flex gap-2">
            <button className="px-4 py-2 rounded-2xl bg-amber-50 text-amber-600 text-xs font-bold flex items-center gap-2 hover:bg-amber-100 transition-colors border border-amber-100">
               <Lightbulb size={14} /> Simplified Hint
            </button>
            <button className="px-4 py-2 rounded-2xl bg-blue-50 text-blue-600 text-xs font-bold flex items-center gap-2 hover:bg-blue-100 transition-colors border border-blue-100">
               <HelpCircle size={14} /> Explain Concept
            </button>
          </div>

          <form onSubmit={handleSend} className="relative group">
            <input 
              type="text" 
              className="w-full p-6 pr-20 rounded-[2rem] bg-white border border-slate-200 shadow-xl focus:outline-none focus:border-blue-400 focus:ring-4 focus:ring-blue-50 transition-all text-slate-800"
              placeholder="Type your thought or answer here..."
              value={input}
              onChange={(e) => setInput(e.target.value)}
              disabled={chatLoading}
            />
            <button 
              type="submit" 
              className="absolute right-3 top-3 bottom-3 px-6 rounded-2xl bg-blue-600 text-white hover:bg-blue-700 transition-all flex items-center justify-center disabled:opacity-50"
              disabled={!input.trim() || chatLoading}
            >
              <Send size={20} />
            </button>
          </form>
        </div>
      </div>
    </div>
  );
}
