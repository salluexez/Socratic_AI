import type { Metadata } from "next";
import "./globals.css";
import LayoutWrapper from "@/components/LayoutWrapper";

export const metadata: Metadata = {
  title: "Socratic AI | Your Personal Teaching Assistant",
  description: "Learn through discovery, not just documentation.",
};

import { Toaster } from "react-hot-toast";

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html lang="en" className="h-full">
      <body className="h-full antialiased" style={{ fontFamily: "Lato, Segoe UI, Arial, sans-serif" }}>
        <LayoutWrapper>
          <Toaster 
            position="top-center"
            toastOptions={{
              className: 'glass text-sm font-medium rounded-2xl border border-[var(--border)]',
              style: {
                background: 'var(--surface)',
                color: 'var(--foreground)',
              },
            }}
          />
          {children}
        </LayoutWrapper>
      </body>
    </html>
  );
}
