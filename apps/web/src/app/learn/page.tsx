"use client";

import { useAuthStore } from "@/store/useAuthStore";
import subjectsData from "@/data/subjects.json";
import Link from "next/link";
import { ArrowRight, BookOpen, Sparkles } from "lucide-react";

export default function LearnOverviewPage() {
  const { user } = useAuthStore();
  const featuredSubjects = subjectsData.filter(
    (subject) => subject.isPermanent || user?.subjects?.includes(subject.slug)
  );

  return (
    <div className="min-h-screen">
      <div className="mx-auto flex w-full max-w-6xl flex-col gap-16 px-6 py-16">
        <section className="relative overflow-hidden group">
          <div
            className="ai-orb-glow absolute -top-20 -right-20 h-64 w-64 rounded-full"
            style={{ opacity: 0.4 }}
          />
          <div className="relative max-w-3xl space-y-6">
            <div
              className="inline-flex items-center gap-2 rounded-full px-4 py-2 text-[10px] font-black uppercase tracking-[0.3em] bg-[var(--accent-soft)] text-[var(--accent)]"
            >
              <Sparkles size={14} />
              Socratic Repository
            </div>
            <h1 className="text-5xl font-bold tracking-tight leading-[1.1]" style={{ color: "var(--foreground)" }}>
              Every breakthrough begins with a <span className="text-[var(--accent)] italic">single question.</span>
            </h1>
            <p className="max-w-2xl text-base leading-8 opacity-70" style={{ color: "var(--foreground)" }}>
              The Socratic Assistant doesn&apos;t just provide answers. It guides your mind through cycles of inquiry, 
              ensuring every leap in understanding is earned and permanent.
            </p>
          </div>
        </section>

        <section className="space-y-10">
          <div className="flex items-center justify-between border-b border-[var(--border)] pb-6">
            <div className="flex items-center gap-4">
              <div className="flex h-12 w-12 items-center justify-center rounded-2xl bg-[var(--surface-alt)] border border-[var(--border)] text-[var(--accent)] shadow-inner">
                <BookOpen size={22} />
              </div>
              <div>
                <h2 className="text-2xl font-bold tracking-tight" style={{ color: "var(--foreground)" }}>
                  Core Disciplines
                </h2>
                <p className="text-[10px] font-bold uppercase tracking-[0.25em]" style={{ color: "var(--muted)" }}>
                  Guided learning pathways
                </p>
              </div>
            </div>
          </div>

          <div className="grid grid-cols-1 gap-8 md:grid-cols-2 lg:grid-cols-3">
            {featuredSubjects.map((subject) => (
              <Link
                key={subject.slug}
                href={`/learn/${subject.slug}`}
                className="group relative glass-panel rounded-3xl p-8 transition-all hover:-translate-y-2 hover:shadow-2xl hover:border-[var(--accent)]/30"
              >
                <div
                  className="mb-8 flex h-16 w-16 items-center justify-center rounded-2xl text-4xl shadow-inner transition-transform group-hover:scale-110"
                  style={{ background: "linear-gradient(135deg, var(--surface-alt), var(--surface))" }}
                >
                  {subject.icon}
                </div>
                <div className="space-y-4">
                  <h3 className="text-xl font-bold tracking-tight" style={{ color: "var(--foreground)" }}>
                    {subject.name}
                  </h3>
                  <p className="text-sm leading-7 opacity-60 line-clamp-3" style={{ color: "var(--foreground)" }}>
                    {subject.description}
                  </p>
                  <div className="flex items-center gap-3 pt-4 pt-4 text-xs font-black uppercase tracking-widest text-[var(--accent)] transition-all group-hover:gap-5">
                    Open Session
                    <ArrowRight size={16} />
                  </div>
                </div>
                
                {/* Subtle hover accent */}
                <div className="absolute top-4 right-4 h-2 w-2 rounded-full bg-[var(--accent)] opacity-0 group-hover:opacity-100 transition-all blur-[2px]" />
              </Link>
            ))}
          </div>
        </section>
      </div>
    </div>
  );
}
