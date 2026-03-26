"use client";

import ParticleLogo from "@/components/ParticleLogo";
import Link from "next/link";
import { useCallback, useEffect, useRef, useState } from "react";
import ghost from "./ghost.jpeg";

export default function HomePage() {
  const [showNavbar, setShowNavbar] = useState(false);
  const handleLogoReady = useCallback(() => setShowNavbar(true), []);
  const cursorRef = useRef<HTMLDivElement>(null);
  const targetRef = useRef({ x: -100, y: -100 });
  const positionRef = useRef({ x: -100, y: -100 });
  const rafRef = useRef<number | null>(null);

  useEffect(() => {
    const finePointer = window.matchMedia("(hover: hover) and (pointer: fine)").matches;
    if (!finePointer) return;

    const animateCursor = () => {
      const el = cursorRef.current;
      if (!el) return;

      positionRef.current.x += (targetRef.current.x - positionRef.current.x) * 0.22;
      positionRef.current.y += (targetRef.current.y - positionRef.current.y) * 0.22;

      const dx = targetRef.current.x - positionRef.current.x;
      const tilt = Math.max(-14, Math.min(14, dx * 0.35));
      const scale = 1 + Math.min(0.08, Math.abs(dx) * 0.008);

      el.style.transform = `translate3d(${positionRef.current.x}px, ${positionRef.current.y}px, 0)`;
      el.style.setProperty("--ghost-tilt", `${tilt}deg`);
      el.style.setProperty("--ghost-scale", `${scale}`);

      rafRef.current = requestAnimationFrame(animateCursor);
    };

    const move = (e: MouseEvent) => {
      if (!cursorRef.current) return;
      targetRef.current.x = e.clientX;
      targetRef.current.y = e.clientY;
      cursorRef.current.style.opacity = "1";
    };

    const hide = () => {
      if (!cursorRef.current) return;
      cursorRef.current.style.opacity = "0";
    };

    window.addEventListener("mousemove", move);
    window.addEventListener("mouseout", hide);
    window.addEventListener("blur", hide);
    rafRef.current = requestAnimationFrame(animateCursor);

    return () => {
      if (rafRef.current) cancelAnimationFrame(rafRef.current);
      window.removeEventListener("mousemove", move);
      window.removeEventListener("mouseout", hide);
      window.removeEventListener("blur", hide);
    };
  }, []);

  return (
    <div className="min-h-screen cursor-none [&_a]:cursor-none [&_button]:cursor-none bg-[radial-gradient(circle_at_top,var(--accent-soft),transparent_55%)]">
      <div
        ref={cursorRef}
        className="ghost-cursor pointer-events-none fixed left-0 top-0 z-[100] opacity-0 transition-opacity duration-150"
        style={{ transform: "translate3d(-100px, -100px, 0)" }}
        aria-hidden="true"
      >
        <div className="ghost-shell">
          <div className="ghost-aura" />
          <svg className="ghost-svg floating-orb" viewBox="0 0 64 64" fill="none" xmlns="http://www.w3.org/2000/svg">
            <defs>
              <linearGradient id="ghostBody" x1="8" y1="4" x2="56" y2="58" gradientUnits="userSpaceOnUse">
                <stop stopColor="#F9F7FF" />
                <stop offset="1" stopColor="#DCCFFF" />
              </linearGradient>
            </defs>
            <path d="M32 6C20.2 6 11 15.2 11 27v27c0 1.5 1.7 2.3 2.8 1.4l6.1-5.1 5.7 5c.8.7 2 .7 2.8 0l3.5-3 3.5 3c.8.7 2 .7 2.8 0l5.7-5 6.1 5.1c1.1.9 2.8.1 2.8-1.4V27C53 15.2 43.8 6 32 6Z" fill="url(#ghostBody)" />
            <ellipse cx="24" cy="27" rx="3.3" ry="4.5" className="ghost-eye" />
            <ellipse cx="39" cy="27" rx="3.3" ry="4.5" className="ghost-eye" />
            <path d="M24 36.2c2.4 3.2 13.6 3.2 16 0" className="ghost-mouth" />
            <circle cx="19" cy="34" r="2.2" className="ghost-blush" />
            <circle cx="45" cy="34" r="2.2" className="ghost-blush" />
          </svg>
        </div>
      </div>
      {showNavbar && (
        <header className="shutter-drop fixed top-0 z-50 w-full border-b border-[var(--border)] bg-[color-mix(in_srgb,var(--background)_80%,black_20%)]/90 backdrop-blur-xl">
          <nav className="mx-auto flex w-full max-w-7xl items-center justify-between px-4 py-4 md:px-8">
            <div className="flex items-center gap-3">
              <div className="h-2.5 w-2.5 rounded-full soft-pulse" style={{ backgroundColor: "var(--accent)" }} />
              <div className="text-xl font-black tracking-tight md:text-2xl" style={{ color: "var(--foreground)" }}>
                Socratic <span style={{ color: "var(--accent)" }}>AI</span>
              </div>
            </div>

            <div className="hidden items-center gap-2 rounded-full border border-[var(--border)] bg-[var(--surface)] px-2 py-1 md:flex">
              <Link href="/learn" className="nav-pill rounded-full px-3 py-1.5 text-sm font-bold uppercase tracking-wider text-[var(--muted)] hover:text-[var(--foreground)]">
                Learn
              </Link>
              <Link href="/progress" className="nav-pill rounded-full px-3 py-1.5 text-sm font-bold uppercase tracking-wider text-[var(--muted)] hover:text-[var(--foreground)]">
                Progress
              </Link>
              <Link href="/shared-topics" className="nav-pill rounded-full px-3 py-1.5 text-sm font-bold uppercase tracking-wider text-[var(--muted)] hover:text-[var(--foreground)]">
                Community
              </Link>
            </div>

            <div className="flex items-center gap-3">
              <Link href="/signin" className="button-ghost rounded-full px-5 py-2.5 text-base font-semibold" style={{ color: "var(--foreground)" }}>
                signin
              </Link>
              <Link href="/signup" className="button-accent rounded-full px-6 py-2.5 text-base font-black tracking-wide">
                Start Free
              </Link>
            </div>
          </nav>
        </header>
      )}

      <main className="flex min-h-screen items-center justify-center px-4 py-8">
        <div className="w-full max-w-[1460px]">
          <ParticleLogo
            width={2500}
            height={1080}
            logoSrc={ghost.src}
            logoWidth={520}
            logoHeight={520}
            roundLogo
            primaryText="SOCRATIC"
            primaryTextColor="#FF8A2A"
            secondaryText="AI"
            secondaryTextColor="#FFFFFF"
            secondaryTextPosition="superscript"
            taglineLine1="ALWAYS BELIEVE THAT SOMETHING"
            taglineLine2="WONDERFUL IS ABOUT TO HAPPEN"
            taglineColor="#A9BBD8"
            taglineFontSize={58}
            taglineFontFamily="'Playfair Display', 'Cormorant Garamond', Georgia, serif"
            primaryFontSize={340}
            secondaryFontSize={122}
            onLoadComplete={handleLogoReady}
          />
        </div>
      </main>
    </div>
  );
}
