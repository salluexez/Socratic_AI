import type { ReactNode } from "react";
import {
  Atom,
  BarChart3,
  BookOpenText,
  FlaskConical,
  Landmark,
  Laptop,
  Leaf,
  Sigma,
  Scale,
} from "lucide-react";

export type SubjectVisual = {
  icon: ReactNode;
  accent: string;
  soft: string;
  gradient: string;
};

const visuals: Record<string, SubjectVisual> = {
  math: {
    icon: <Sigma size={24} />,
    accent: "#9AC2FF",
    soft: "rgba(154, 194, 255, 0.16)",
    gradient: "linear-gradient(135deg, rgba(154,194,255,0.28), rgba(143,211,255,0.08))",
  },
  physics: {
    icon: <Atom size={24} />,
    accent: "#d0bcff",
    soft: "rgba(208, 188, 255, 0.16)",
    gradient: "linear-gradient(135deg, rgba(208,188,255,0.28), rgba(98,44,204,0.14))",
  },
  chemistry: {
    icon: <FlaskConical size={24} />,
    accent: "#44e2cd",
    soft: "rgba(68, 226, 205, 0.16)",
    gradient: "linear-gradient(135deg, rgba(68,226,205,0.28), rgba(3,198,178,0.12))",
  },
  biology: {
    icon: <Leaf size={24} />,
    accent: "#6dd38a",
    soft: "rgba(109, 211, 138, 0.16)",
    gradient: "linear-gradient(135deg, rgba(109,211,138,0.28), rgba(68,226,205,0.08))",
  },
  "computer-science": {
    icon: <Laptop size={24} />,
    accent: "#7ad0ff",
    soft: "rgba(122, 208, 255, 0.16)",
    gradient: "linear-gradient(135deg, rgba(122,208,255,0.28), rgba(154,194,255,0.1))",
  },
  history: {
    icon: <Landmark size={24} />,
    accent: "#d6a46f",
    soft: "rgba(214, 164, 111, 0.16)",
    gradient: "linear-gradient(135deg, rgba(214,164,111,0.28), rgba(98,44,204,0.08))",
  },
  "political-science": {
    icon: <Scale size={24} />,
    accent: "#c6a6ff",
    soft: "rgba(198, 166, 255, 0.16)",
    gradient: "linear-gradient(135deg, rgba(198,166,255,0.28), rgba(143,211,255,0.08))",
  },
  economics: {
    icon: <BarChart3 size={24} />,
    accent: "#58d6c3",
    soft: "rgba(88, 214, 195, 0.16)",
    gradient: "linear-gradient(135deg, rgba(88,214,195,0.28), rgba(154,194,255,0.08))",
  },
  literature: {
    icon: <BookOpenText size={24} />,
    accent: "#ffafd3",
    soft: "rgba(255, 175, 211, 0.16)",
    gradient: "linear-gradient(135deg, rgba(255,175,211,0.28), rgba(208,188,255,0.08))",
  },
};

export function getSubjectVisual(slug: string): SubjectVisual {
  return visuals[slug] ?? {
    icon: <BookOpenText size={24} />,
    accent: "var(--accent)",
    soft: "var(--accent-soft)",
    gradient: "linear-gradient(135deg, var(--accent-soft), transparent)",
  };
}
