"use client";

import { useEffect, useState } from "react";
import { useRouter } from "next/navigation";
import Link from "next/link";
import { useAuthStore } from "@/store/useAuthStore";
import api from "@/lib/api";
import { Session } from "@socratic-ai/types";
import { BookOpen, History, LogOut } from "lucide-react";

export default function DashboardPage() {
  const { user, logout, checkAuth, loading } = useAuthStore();
  const [sessions, setSessions] = useState<Session[]>([]);
  const router = useRouter();

  useEffect(() => {
    checkAuth();
  }, [checkAuth]);

  useEffect(() => {
    if (!loading && !user) router.push("/login");
  }, [user, loading, router]);

  useEffect(() => {
    if (user) {
      api.get("/sessions").then((res) => {
        if (res.data.success) setSessions(res.data.data);
      });
    }
  }, [user]);

  if (loading || !user) return <div className="flex items-center justify-center min-h-screen">Loading...</div>;

  const subjects = [
    { id: "physics", name: "Physics", color: "bg-blue-500", icon: "⚛️" },
    { id: "chemistry", name: "Chemistry", color: "bg-emerald-500", icon: "🧪" },
    { id: "math", name: "Mathematics", color: "bg-indigo-500", icon: "📐" },
    { id: "biology", name: "Biology", color: "bg-rose-500", icon: "🌿" },
  ];

  return (
    <div className="min-h-screen bg-slate-50/50 flex flex-col">
      {/* Header */}
      <header className="px-8 py-6 glass flex items-center justify-between sticky top-0 z-40">
        <div className="text-xl font-bold tracking-tight text-slate-900">
          Socratic <span className="text-blue-600">AI</span>
        </div>
        <div className="flex items-center gap-6">
          <div className="text-sm font-medium text-slate-600">
            Hello, <span className="text-slate-900 font-bold">{user.name}</span>
          </div>
          <button onClick={logout} className="p-2 text-slate-400 hover:text-red-500 transition-colors">
            <LogOut size={20} />
          </button>
        </div>
      </header>

      <main className="max-w-6xl mx-auto w-full px-8 py-12 space-y-16">
        {/* Subject Grid */}
        <section className="space-y-8">
          <div className="flex items-center gap-3">
             <div className="w-10 h-10 rounded-xl bg-blue-100 flex items-center justify-center text-blue-600">
               <BookOpen size={20} />
             </div>
             <h2 className="text-3xl font-bold text-slate-900 tracking-tight">Pick a Subject</h2>
          </div>
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
            {subjects.map((s) => (
              <Link
                key={s.id}
                href={`/learn/${s.id}`}
                className="group p-8 rounded-[2rem] bg-white border border-slate-100 shadow-tonal hover:shadow-xl hover:-translate-y-1 transition-all duration-300 flex flex-col items-center text-center space-y-4"
              >
                <div className={`w-20 h-20 rounded-[1.5rem] ${s.color} text-4xl flex items-center justify-center shadow-lg transform group-hover:rotate-12 transition-transform`}>
                  {s.icon}
                </div>
                <h3 className="text-xl font-bold text-slate-900">{s.name}</h3>
                <p className="text-sm text-slate-500">Master {s.name.toLowerCase()} concepts through discovery.</p>
              </Link>
            ))}
          </div>
        </section>

        {/* Recent Sessions */}
        <section className="space-y-8 pb-12">
          <div className="flex items-center gap-3">
             <div className="w-10 h-10 rounded-xl bg-slate-100 flex items-center justify-center text-slate-600">
               <History size={20} />
             </div>
             <h2 className="text-3xl font-bold text-slate-900 tracking-tight">Your Journey</h2>
          </div>
          
          <div className="bg-white rounded-[2.5rem] border border-slate-100 shadow-tonal overflow-hidden">
            {sessions.length === 0 ? (
              <div className="p-20 text-center space-y-4">
                <p className="text-slate-400">No sessions yet. Start your first discovery today!</p>
              </div>
            ) : (
              <div className="divide-y divide-slate-50">
                {sessions.map((session) => (
                  <div key={session.id} className="p-6 flex items-center justify-between hover:bg-slate-50 transition-colors group">
                    <div className="flex items-center gap-4">
                      <div className="w-12 h-12 rounded-2xl bg-slate-100 flex items-center justify-center text-2xl">
                        {subjects.find(s => s.id === session.subject)?.icon || "📖"}
                      </div>
                      <div>
                        <div className="font-bold text-slate-900 capitalize">{session.subject} Session</div>
                        <div className="text-sm text-slate-500">
                          {new Date(session.createdAt).toLocaleDateString()} • {session.messages.length} messages
                        </div>
                      </div>
                    </div>
                    <Link href={`/learn/${session.subject}`} className="px-5 py-2 rounded-full text-sm font-bold text-blue-600 bg-blue-50 opacity-0 group-hover:opacity-100 transition-opacity">
                      Resume
                    </Link>
                  </div>
                ))}
              </div>
            )}
          </div>
        </section>
      </main>
    </div>
  );
}
