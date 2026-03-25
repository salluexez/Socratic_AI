"use client";

import { useEffect, useRef } from "react";

interface Particle {
    x: number;
    y: number;
    z: number; // 3D depth
    originX: number;
    originY: number;
    originZ: number;
    vx: number;
    vy: number;
    vz: number;
    size: number;
    color: string;
    opacity: number;
}

interface ParticleLogoProps {
    width?: number;
    height?: number;
    logoSrc?: string;
    logoWidth?: number;
    logoHeight?: number;
    primaryText?: string;
    primaryTextColor?: string;
    secondaryText?: string;
    secondaryTextColor?: string;
    secondaryTextPosition?: "newline" | "superscript";
    taglineLine1?: string;
    taglineLine2?: string;
    taglineColor?: string;
    taglineFontSize?: number;
    taglineFontFamily?: string;
    roundLogo?: boolean;
    primaryFontSize?: number;
    secondaryFontSize?: number;
    className?: string;
    onLoadComplete?: () => void;
}

export default function ParticleLogo({
    width = 2000,
    height = 1500,
    logoSrc = "/logo.png",
    logoWidth = 400,
    logoHeight = 400,
    primaryText = "CUHP",
    primaryTextColor = "#ffffff",
    secondaryText = "DEVS",
    secondaryTextColor = "#eab308",
    secondaryTextPosition = "newline",
    taglineLine1 = "",
    taglineLine2 = "",
    taglineColor = "#B8C8E6",
    taglineFontSize = 56,
    taglineFontFamily = "Georgia, 'Times New Roman', serif",
    roundLogo = false,
    primaryFontSize = 100,
    secondaryFontSize = 300,
    className = "",
    onLoadComplete
}: ParticleLogoProps) {
    const canvasRef = useRef<HTMLCanvasElement>(null);
    const mouseRef = useRef({ x: -100, y: -100, radius: 50 });
    const hasCalledComplete = useRef(false);
    const layoutRef = useRef({ textX: 0, textY: 0 });
    const typedLine1Ref = useRef("");
    const typedLine2Ref = useRef("");
    const hasStartedTypewriterRef = useRef(false);
    const typingTimerRef = useRef<ReturnType<typeof setTimeout> | null>(null);

    useEffect(() => {
        const canvas = canvasRef.current;
        if (!canvas) return;

        const ctx = canvas.getContext("2d", { willReadFrequently: true });
        if (!ctx) return;

        let particles: Particle[] = [];
        let animationFrameId: number;

        const img = new Image();
        img.src = logoSrc;
        img.crossOrigin = "anonymous";

        const line1 = taglineLine1.trim();
        const line2 = taglineLine2.trim();

        const stopTypewriter = () => {
            if (typingTimerRef.current) {
                clearTimeout(typingTimerRef.current);
                typingTimerRef.current = null;
            }
        };

        const startTypewriter = () => {
            if (hasStartedTypewriterRef.current || (!line1 && !line2)) return;
            hasStartedTypewriterRef.current = true;

            let idx1 = 0;
            let idx2 = 0;

            const typeLine1 = () => {
                if (idx1 <= line1.length) {
                    typedLine1Ref.current = line1.slice(0, idx1);
                    idx1 += 1;
                    typingTimerRef.current = setTimeout(typeLine1, 32);
                } else if (line2) {
                    typingTimerRef.current = setTimeout(typeLine2, 140);
                }
            };

            const typeLine2 = () => {
                if (idx2 <= line2.length) {
                    typedLine2Ref.current = line2.slice(0, idx2);
                    idx2 += 1;
                    typingTimerRef.current = setTimeout(typeLine2, 32);
                }
            };

            typeLine1();
        };

        const init = () => {
            canvas.width = width;
            canvas.height = height;

            ctx.clearRect(0, 0, canvas.width, canvas.height);

            // 1. Draw Image Logo
            // Shifting as far left as possible (50px padding)
            const logoX = 50;
            const logoY = height / 2 - (logoHeight / 2);

            if (img.complete && img.naturalWidth > 0) {
                if (roundLogo) {
                    const r = Math.min(logoWidth, logoHeight) / 2;
                    const cx = logoX + logoWidth / 2;
                    const cy = logoY + logoHeight / 2;
                    ctx.save();
                    ctx.beginPath();
                    ctx.arc(cx, cy, r, 0, Math.PI * 2);
                    ctx.closePath();
                    ctx.clip();
                    ctx.drawImage(img, logoX, logoY, logoWidth, logoHeight);
                    ctx.restore();
                } else {
                    ctx.drawImage(img, logoX, logoY, logoWidth, logoHeight);
                }
            } else {
                // Fallback while loading
                ctx.fillStyle = "#f97316";
                if (roundLogo) {
                    const r = Math.min(logoWidth, logoHeight) / 2;
                    ctx.beginPath();
                    ctx.arc(logoX + logoWidth / 2, logoY + logoHeight / 2, r, 0, Math.PI * 2);
                    ctx.closePath();
                    ctx.fill();
                } else {
                    ctx.beginPath();
                    ctx.moveTo(logoX + logoWidth / 2, logoY);
                    ctx.lineTo(logoX + logoWidth, logoY + logoHeight);
                    ctx.lineTo(logoX, logoY + logoHeight);
                    ctx.closePath();
                    ctx.fill();
                }
            }

            // 2. Draw Text
            // Anchored immediately after the logo
            const textX = logoX + logoWidth + 20;
            const textY = height / 2 + (primaryFontSize / 3.5);
            layoutRef.current = { textX, textY };

            ctx.font = `bold ${primaryFontSize}px Inter, sans-serif`;
            ctx.fillStyle = primaryTextColor;
            ctx.fillText(primaryText, textX, textY);

            ctx.font = `bold ${secondaryFontSize}px Inter, sans-serif`;
            ctx.fillStyle = secondaryTextColor;
            if (secondaryTextPosition === "superscript") {
                ctx.font = `bold ${primaryFontSize}px Inter, sans-serif`;
                const primaryWidth = ctx.measureText(primaryText).width;
                ctx.font = `bold ${secondaryFontSize}px Inter, sans-serif`;
                ctx.fillStyle = secondaryTextColor;
                const superscriptX = textX + primaryWidth + 14;
                const superscriptY = textY - Math.round(primaryFontSize * 0.55);
                ctx.fillText(secondaryText, superscriptX, superscriptY);
            } else {
                ctx.fillText(secondaryText, textX, textY + secondaryFontSize + 10);
            }

            const imageData = ctx.getImageData(0, 0, canvas.width, canvas.height);
            const data = imageData.data;
            particles = [];

            const step = 8; // Performance optimization for large canvas

            for (let y = 0; y < canvas.height; y += step) {
                for (let x = 0; x < canvas.width; x += step) {
                    const index = (y * canvas.width + x) * 4;
                    const alpha = data[index + 3];
                    if (alpha !== undefined && alpha > 128) {
                        const r = data[index];
                        const g = data[index + 1];
                        const b = data[index + 2];
                        if (r !== undefined && g !== undefined && b !== undefined) {
                            particles.push({
                                x: Math.random() * canvas.width,
                                y: Math.random() * canvas.height,
                                z: Math.random() * 2000 - 1000,
                                originX: x,
                                originY: y,
                                originZ: 0,
                                vx: 0,
                                vy: 0,
                                vz: 0,
                                size: 4,
                                color: `rgb(${r},${g},${b})`,
                                opacity: 0,
                            });
                        }
                    }
                }
            }
        };

        const animate = () => {
            ctx.clearRect(0, 0, canvas.width, canvas.height);
            let completedCount = 0;

            for (let i = 0; i < particles.length; i++) {
                const p = particles[i];
                if (!p) continue;

                // 3D Perspective scaling
                const perspective = 1000 / (1000 + p.z);
                const drawX = (p.x - width / 2) * perspective + width / 2;
                const drawY = (p.y - height / 2) * perspective + height / 2;
                const drawSize = p.size * perspective;

                // Physics: Dispersion
                const dx = mouseRef.current.x - p.x;
                const dy = mouseRef.current.y - p.y;
                const distance = Math.sqrt(dx * dx + dy * dy);

                if (distance < mouseRef.current.radius) {
                    const force = (mouseRef.current.radius - distance) / mouseRef.current.radius;
                    p.vx -= (dx / distance) * force * 2;
                    p.vy -= (dy / distance) * force * 0.7;
                }

                // Return to origin
                p.vx += (p.originX - p.x) * 0.002;
                p.vy += (p.originY - p.y) * 0.002;
                p.vz += (p.originZ - p.z) * 0.002;

                p.vx *= 0.95;
                p.vy *= 0.92;
                p.vz *= 0.92;

                p.x += p.vx;
                p.y += p.vy;
                p.z += p.vz;

                p.opacity = Math.min(1, Math.max(0, 1 - Math.abs(p.z) / 1000));

                if (Math.abs(p.z) < 10 && Math.abs(p.originX - p.x) < 5) completedCount++;

                ctx.beginPath();
                ctx.arc(drawX, drawY, Math.max(0.1, drawSize / 2), 0, Math.PI * 2);
                ctx.fillStyle = p.color;
                ctx.globalAlpha = p.opacity;
                ctx.fill();
                ctx.closePath();
            }

            ctx.globalAlpha = 1;

            if (completedCount > particles.length * 0.9 && !hasCalledComplete.current) {
                hasCalledComplete.current = true;
                if (onLoadComplete) onLoadComplete();
            }

            if (completedCount > particles.length * 0.9) {
                startTypewriter();
            }

            if (typedLine1Ref.current || typedLine2Ref.current) {
                const { textX, textY } = layoutRef.current;
                const firstLineY = textY + Math.round(primaryFontSize * 0.4);
                const lineHeight = Math.round(taglineFontSize * 1.34);
                const cursorVisible = Date.now() % 900 < 460;

                ctx.save();
                ctx.font = `italic 700 ${taglineFontSize}px ${taglineFontFamily}`;
                ctx.fillStyle = taglineColor;
                ctx.fillText(typedLine1Ref.current, textX + 6, firstLineY);
                ctx.fillText(typedLine2Ref.current, textX + 6, firstLineY + lineHeight);

                const isTyping =
                    typedLine1Ref.current.length < line1.length ||
                    typedLine2Ref.current.length < line2.length;

                if (isTyping && cursorVisible) {
                    const cursorBaseY = typedLine2Ref.current.length > 0
                        ? firstLineY + lineHeight
                        : firstLineY;
                    const activeText = typedLine2Ref.current.length > 0
                        ? typedLine2Ref.current
                        : typedLine1Ref.current;
                    const activeWidth = ctx.measureText(activeText).width;
                    ctx.fillText("|", textX + 6 + activeWidth + 4, cursorBaseY);
                }
                ctx.restore();
            }

            animationFrameId = requestAnimationFrame(animate);
        };

        img.onload = () => {
            init();
        };

        // If image fails to load, still init with fallback
        img.onerror = () => {
            init();
        };

        // In case image is already cached
        if (img.complete) {
            init();
        }

        animate();

        const handleMouseMove = (e: MouseEvent) => {
            const rect = canvas.getBoundingClientRect();
            const scaleX = canvas.width / rect.width;
            const scaleY = canvas.height / rect.height;
            mouseRef.current.x = (e.clientX - rect.left) * scaleX;
            mouseRef.current.y = (e.clientY - rect.top) * scaleY;
        };

        const handleMouseLeave = () => {
            mouseRef.current.x = -1000;
            mouseRef.current.y = -1000;
        };

        window.addEventListener("mousemove", handleMouseMove);
        canvas.addEventListener("mouseleave", handleMouseLeave);

        return () => {
            stopTypewriter();
            cancelAnimationFrame(animationFrameId);
            window.removeEventListener("mousemove", handleMouseMove);
            canvas.removeEventListener("mouseleave", handleMouseLeave);
        };
    }, [width, height, logoSrc, logoWidth, logoHeight, primaryText, primaryTextColor, secondaryText, secondaryTextColor, secondaryTextPosition, taglineLine1, taglineLine2, taglineColor, taglineFontSize, taglineFontFamily, roundLogo, primaryFontSize, secondaryFontSize, onLoadComplete]);

    return (
        <canvas
            ref={canvasRef}
            className={`w-full max-w-full h-auto ${className}`}
        />
    );
}
