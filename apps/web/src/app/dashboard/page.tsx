"use client";

import { useEffect, useState } from "react";
import { useRouter } from "next/navigation";
import Link from "next/link";
import { Session } from "@socratic-ai/types";
import {
  BookOpen,
  BrainCircuit,
  Clock3,
  Flame,
  History,
  Play,
  Share2,
  Sparkles,
} from "lucide-react";
import { useAuthStore } from "@/store/useAuthStore";
import api from "@/lib/api";
import subjectsData from "@/data/subjects.json";
import { getSubjectVisual } from "@/lib/subjectMeta";

type DashboardSession = Session & {
  topic?: string;
  userId?: string;
};

type DashboardStats = {
  hoursLearned?: number;
  averageMastery?: number;
  streak?: number;
  masteryData?: Array<{ subject: string; level: number }>;
};

function getSessionTitle(session: DashboardSession) {
  return (
    session.topic ||
    session.messages.find((message) => message.role === "user")?.content.slice(0, 34) ||
    `${session.subject} Session`
  );
}

function getRecommendedSubject(
  userSubjects: typeof subjectsData,
  sessions: DashboardSession[]
) {
  const recentSubject = sessions[0]?.subject;
  return (
    userSubjects.find((subject) => subject.slug === recentSubject) ||
    userSubjects[0] ||
    subjectsData[0]
  );
}

export default function DashboardPage() {
  const { user, checkAuth, loading } = useAuthStore();
  const [sessions, setSessions] = useState<DashboardSession[]>([]);
  const [stats, setStats] = useState<DashboardStats | null>(null);
  const router = useRouter();

  useEffect(() => {
    checkAuth();
  }, [checkAuth]);

  useEffect(() => {
    if (!loading && !user) {
      router.push("/login");
    }
  }, [user, loading, router]);

  useEffect(() => {
    if (!user) return;

    api.get("/chat").then((res) => {
      if (res.data.success) {
        setSessions(res.data.data);
      }
    });

    api.get("/user/stats").then((res) => {
      if (res.data.success) {
        setStats(res.data.data);
      }
    });
  }, [user]);

  if (loading || !user) {
    return (
      <div className="flex min-h-screen items-center justify-center" style={{ color: "var(--muted)" }}>
        Loading...
      </div>
    );
  }

  const userSubjects = subjectsData.filter(
    (subject) => user.subjects?.includes(subject.slug) || subject.isPermanent
  );

  const recommendedSubject = getRecommendedSubject(userSubjects, sessions);
  const recommendedVisual = getSubjectVisual(recommendedSubject.slug);

  // Real data integration
  const dashboardStats = {
    progressMinutes: (stats?.hoursLearned || 0) * 60,
    goalMinutes: 60,
    progressPercent: stats?.averageMastery || 0,
    streakDays: stats?.streak || 0,
    sharedCount: sessions.filter((session) => session.userId && session.userId !== user._id).length,
  };

  const topSubjects = userSubjects.slice(0, 2);
  const recentSessions = sessions.slice(0, 3);
  const miniSubjects = userSubjects.slice(0, 4);

  return (
    <div className="relative min-h-screen overflow-hidden">
      <div
        className="pointer-events-none absolute -right-24 top-8 h-80 w-80 rounded-full blur-[120px]"
        style={{ background: "color-mix(in srgb, var(--accent) 14%, transparent)" }}
      />
      <div
        className="pointer-events-none absolute -left-16 bottom-0 h-64 w-64 rounded-full blur-[120px]"
        style={{ background: "color-mix(in srgb, var(--accent) 8%, transparent)" }}
      />

      <header className="sticky top-0 z-30 flex items-center justify-between border-b px-8 py-4" style={{ backgroundColor: "var(--background)", borderColor: "var(--border)" }}>
        <div className="flex items-center gap-4">
          <div>
            <div className="text-xl font-black uppercase tracking-[-0.04em]" style={{ color: "var(--foreground)" }}>
              Socratic AI
            </div>
            <div className="text-[9px] font-black uppercase tracking-[0.22em]" style={{ color: "var(--muted)" }}>
              Student Dashboard
            </div>
          </div>
        </div>

        <div className="flex items-center gap-3">
          <Link
            href="/shared-topics"
            className="hidden items-center gap-2 rounded-full px-4 py-2 text-sm font-bold md:inline-flex"
            style={{ backgroundColor: "var(--surface-alt)", color: "var(--foreground)" }}
          >
            <Share2 size={16} />
            Shared
          </Link>
          <Link
            href="/profile"
            className="flex h-11 w-11 items-center justify-center rounded-full text-sm font-black shadow-tonal"
            style={{ background: recommendedVisual.gradient, color: "var(--foreground)" }}
          >
            {user.name.charAt(0).toUpperCase()}
          </Link>
        </div>
      </header>

      <main className="px-8 py-12">
        <section className="mb-14 max-w-6xl space-y-5">
        <div
          className="inline-flex items-center gap-2 rounded-full px-4 py-2 text-[10px] font-black uppercase tracking-[0.28em]"
          style={{ backgroundColor: "var(--accent-soft)", color: "var(--accent)" }}
        >
          <Sparkles size={14} />
          Question-first workspace
        </div>
        <h1 className="text-5xl font-black tracking-[-0.06em] sm:text-6xl xl:text-7xl" style={{ color: "var(--foreground)" }}>
          Hello, <span style={{ color: "var(--accent)" }}>{user.name}</span>.
          <br />
          Ready to explore today?
        </h1>
        <p className="max-w-2xl text-lg leading-8" style={{ color: "var(--muted)" }}>
          Your learning space is tuned to discovery, reflection, and momentum. Pick up where you left off or jump into a fresh subject.
        </p>
      </section>

      <div className="grid grid-cols-1 gap-6 lg:grid-cols-12">
        <section className="panel-surface lg:col-span-4 rounded-[2rem] p-8">
          <div className="mb-8 flex items-center justify-between">
            <div>
              <div className="text-xs font-black uppercase tracking-[0.24em]" style={{ color: "var(--accent)" }}>
                Daily Goal
              </div>
              <div className="mt-2 text-4xl font-black tracking-[-0.04em]" style={{ color: "var(--foreground)" }}>
                {Math.round(dashboardStats.progressMinutes)}
                <span className="ml-1 text-lg font-bold" style={{ color: "var(--muted)" }}>
                  /{dashboardStats.goalMinutes}m
                </span>
              </div>
            </div>
            <div
              className="flex h-14 w-14 items-center justify-center rounded-2xl"
              style={{ backgroundColor: "var(--accent-soft)", color: "var(--accent)" }}
            >
              <Flame size={24} />
            </div>
          </div>

          <div className="mb-4 flex items-center justify-between text-sm">
            <span style={{ color: "var(--foreground)" }}>{dashboardStats.progressPercent}% reached</span>
            <span style={{ color: "var(--muted)" }}>{Math.max(0, dashboardStats.goalMinutes - dashboardStats.progressMinutes).toFixed(0)}m left</span>
          </div>
          <div className="h-2.5 overflow-hidden rounded-full" style={{ backgroundColor: "color-mix(in srgb, var(--surface-alt) 84%, black 16%)" }}>
            <div
              className="h-full rounded-full"
              style={{
                width: `${dashboardStats.progressPercent}%`,
                background: "linear-gradient(90deg, var(--accent) 0%, color-mix(in srgb, var(--accent) 45%, white) 100%)",
                boxShadow: "0 0 18px color-mix(in srgb, var(--accent) 36%, transparent)",
              }}
            />
          </div>

          <p className="mt-8 text-sm italic leading-7" style={{ color: "var(--muted)" }}>
            Just a little more time today keeps your rhythm alive and your concepts fresh.
          </p>
        </section>

        {topSubjects.map((subject) => {
          const visual = getSubjectVisual(subject.slug);
          const mastery = Math.max(54, 92 - sessions.filter((session) => session.subject === subject.slug).length * 6);
          return (
            <Link
              key={subject.slug}
              href={`/learn/${subject.slug}`}
              className="group panel-surface interactive-card lg:col-span-4 overflow-hidden rounded-[2rem]"
            >
              <div
                className="relative h-52 overflow-hidden px-8 py-8"
                style={{ background: visual.gradient }}
              >
                <div className="absolute inset-0 bg-gradient-to-t from-[color:var(--surface)]/90 to-transparent" />
                <div
                  className="absolute -right-10 -top-10 h-32 w-32 rounded-full blur-3xl"
                  style={{ backgroundColor: visual.soft }}
                />
                <div className="relative flex h-full flex-col justify-end">
                  <div className="mb-4 flex h-14 w-14 items-center justify-center rounded-2xl border" style={{ color: visual.accent, borderColor: "color-mix(in srgb, white 12%, transparent)", backgroundColor: "rgba(11,19,38,0.28)" }}>
                    {visual.icon}
                  </div>
                  <h3 className="text-3xl font-black tracking-[-0.04em]" style={{ color: "var(--foreground)" }}>
                    {subject.name}
                  </h3>
                  <p className="mt-2 text-sm font-semibold" style={{ color: visual.accent }}>
                    {subject.description}
                  </p>
                </div>
              </div>
              <div className="flex items-center justify-between px-8 py-7">
                <div>
                  <div className="text-[10px] font-black uppercase tracking-[0.24em]" style={{ color: "var(--muted)" }}>
                    Mastery
                  </div>
                  <div className="mt-2 text-3xl font-black tracking-[-0.04em]" style={{ color: "var(--foreground)" }}>
                    {stats?.masteryData?.find((item) => item.subject.toLowerCase() === subject.slug.toLowerCase())?.level || 64}%
                  </div>
                </div>
                <div className="relative h-16 w-16">
                  <svg className="h-full w-full -rotate-90" viewBox="0 0 36 36">
                    <circle cx="18" cy="18" r="16" fill="none" stroke="var(--border)" strokeWidth="3" />
                    <circle
                      cx="18"
                      cy="18"
                      r="16"
                      fill="none"
                      stroke={visual.accent}
                      strokeDasharray={`${mastery}, 100`}
                      strokeLinecap="round"
                      strokeWidth="3"
                    />
                  </svg>
                </div>
              </div>
            </Link>
          );
        })}

        <section className="panel-surface lg:col-span-8 rounded-[2rem] p-8 lg:p-10">
          <div className="mb-8 flex items-center justify-between">
            <div>
              <h2 className="text-2xl font-black tracking-[-0.04em]" style={{ color: "var(--foreground)" }}>
                Recent Deep Dives
              </h2>
              <p className="mt-2 text-sm" style={{ color: "var(--muted)" }}>
                Resume your latest sessions and keep the thread of understanding intact.
              </p>
            </div>
            <Link href="/shared-topics" className="text-sm font-bold transition-colors hover:text-[var(--foreground)]" style={{ color: "var(--accent)" }}>
              View shared work
            </Link>
          </div>

          <div className="space-y-5">
            {recentSessions.length === 0 ? (
              <div className="rounded-[1.5rem] px-6 py-16 text-center panel-muted">
                <div className="mx-auto mb-4 flex h-14 w-14 items-center justify-center rounded-2xl" style={{ backgroundColor: "var(--accent-soft)", color: "var(--accent)" }}>
                  <History size={22} />
                </div>
                <p style={{ color: "var(--muted)" }}>
                  No sessions yet. Start a subject above and your recent deep dives will appear here.
                </p>
              </div>
            ) : (
              recentSessions.map((session) => {
                const visual = getSubjectVisual(session.subject);
                return (
                  <Link
                    key={session._id}
                    href={`/learn/${session.subject}?chatId=${session._id}`}
                    className="interactive-card flex flex-col gap-5 rounded-[1.5rem] px-6 py-6 md:flex-row md:items-center"
                    style={{ backgroundColor: "color-mix(in srgb, var(--surface-alt) 42%, var(--surface))" }}
                  >
                    <div
                      className="flex h-14 w-14 shrink-0 items-center justify-center rounded-full"
                      style={{ backgroundColor: visual.soft, color: visual.accent }}
                    >
                      {visual.icon}
                    </div>
                    <div className="min-w-0 flex-1">
                      <div className="mb-1 flex items-center justify-between gap-3">
                        <h4 className="truncate text-lg font-black tracking-[-0.03em]" style={{ color: "var(--foreground)" }}>
                          {getSessionTitle(session)}
                        </h4>
                        <span className="shrink-0 text-xs font-bold" style={{ color: "var(--muted)" }}>
                          {Math.max(session.messages.length * 3, 12)}m
                        </span>
                      </div>
                      <p className="line-clamp-2 text-sm italic leading-6" style={{ color: "var(--muted)" }}>
                        {session.messages.find((message) => message.role === "assistant")?.content || "Open the session to continue your guided dialogue."}
                      </p>
                    </div>
                  </Link>
                );
              })
            )}
          </div>
        </section>

        <section className="lg:col-span-4 flex flex-col gap-6">
          <div className="panel-surface relative overflow-hidden rounded-[2rem] p-8">
            <div
              className="absolute -right-8 -top-8 h-28 w-28 rounded-full blur-3xl"
              style={{ backgroundColor: recommendedVisual.soft }}
            />
            <div className="relative">
              <div className="mb-4 text-xs font-black uppercase tracking-[0.24em]" style={{ color: recommendedVisual.accent }}>
                Recommended for you
              </div>
              <h3 className="text-3xl font-black tracking-[-0.04em]" style={{ color: "var(--foreground)" }}>
                {recommendedSubject.name}
              </h3>
              <p className="mt-3 text-sm leading-7" style={{ color: "var(--muted)" }}>
                Re-enter this subject and let the Socratic loop pick up from your current level of understanding.
              </p>
              <Link
                href={`/learn/${recommendedSubject.slug}`}
                className="mt-8 inline-flex w-full items-center justify-center gap-2 rounded-full px-6 py-4 text-sm font-black"
                style={{
                  background: recommendedVisual.gradient,
                  color: "var(--foreground)",
                  border: `1px solid ${recommendedVisual.soft}`,
                }}
              >
                Jump Back In
                <Play size={16} />
              </Link>
            </div>
          </div>

          <div className="grid grid-cols-2 gap-4">
            {miniSubjects.map((subject) => {
              const visual = getSubjectVisual(subject.slug);
              const completion = Math.max(35, 80 - sessions.filter((session) => session.subject === subject.slug).length * 7);
              return (
                <Link
                  key={subject.slug}
                  href={`/learn/${subject.slug}`}
                  className="interactive-card panel-surface rounded-[1.5rem] p-5"
                >
                  <div className="mb-4 inline-flex h-11 w-11 items-center justify-center rounded-2xl" style={{ backgroundColor: visual.soft, color: visual.accent }}>
                    {visual.icon}
                  </div>
                  <h4 className="text-lg font-black tracking-[-0.03em]" style={{ color: "var(--foreground)" }}>
                    {subject.name}
                  </h4>
                  <div className="mt-4 flex items-center gap-2">
                    <div className="h-1.5 flex-1 overflow-hidden rounded-full" style={{ backgroundColor: "var(--border)" }}>
                      <div
                        className="h-full rounded-full"
                        style={{ width: `${completion}%`, backgroundColor: visual.accent }}
                      />
                    </div>
                    <span className="text-[10px] font-black" style={{ color: "var(--muted)" }}>
                      {completion}%
                    </span>
                  </div>
                </Link>
              );
            })}
          </div>

          <div className="panel-muted rounded-[1.5rem] p-5">
            <div className="mb-3 flex items-center gap-3">
              <div className="flex h-10 w-10 items-center justify-center rounded-2xl" style={{ backgroundColor: "var(--accent-soft)", color: "var(--accent)" }}>
                <BrainCircuit size={18} />
              </div>
              <div>
                <div className="text-sm font-black" style={{ color: "var(--foreground)" }}>
                  Mentor Pulse
                </div>
                <div className="text-[10px] uppercase tracking-[0.2em]" style={{ color: "var(--muted)" }}>
                  Live insight
                </div>
              </div>
            </div>
            <div className="space-y-2 text-sm leading-6" style={{ color: "var(--muted)" }}>
              <div className="flex items-center gap-2">
                <Clock3 size={14} />
                <span>{dashboardStats.streakDays} day learning streak</span>
              </div>
              <div className="flex items-center gap-2">
                <BookOpen size={14} />
                <span>{userSubjects.length} subjects ready to study</span>
              </div>
              <div className="flex items-center gap-2">
                <Share2 size={14} />
                <span>{dashboardStats.sharedCount} shared sessions in your feed</span>
              </div>
            </div>
          </div>
        </section>
      </div>

      <nav className="fixed bottom-5 left-1/2 z-30 flex -translate-x-1/2 items-center gap-6 rounded-full px-6 py-4 glass lg:hidden">
        <Link href="/dashboard" style={{ color: "var(--accent)" }}>
          <Sparkles size={20} />
        </Link>
        <Link href="/learn" style={{ color: "var(--muted)" }}>
          <BookOpen size={20} />
        </Link>
        <Link href="/progress" style={{ color: "var(--muted)" }}>
          <History size={20} />
        </Link>
      </nav>
      </main>
    </div>
  );
}
