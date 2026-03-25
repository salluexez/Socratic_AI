'use client';

import { motion } from 'framer-motion';

interface AuthTabsProps {
  activeTab: 'signin' | 'signup';
  onChange: (tab: 'signin' | 'signup') => void;
}

export const AuthTabs = ({ activeTab, onChange }: AuthTabsProps) => {
  return (
    <div
      className="mx-auto flex w-fit rounded-full p-1"
      style={{
        backgroundColor: 'color-mix(in srgb, var(--surface-alt) 76%, var(--surface))',
        border: '1px solid var(--border)',
      }}
    >
      {[
        { key: 'signin' as const, label: 'Sign In' },
        { key: 'signup' as const, label: 'Sign Up' },
      ].map((tab) => {
        const active = activeTab === tab.key;
        return (
          <button
            key={tab.key}
            onClick={() => onChange(tab.key)}
            className="relative min-w-28 rounded-full px-8 py-3 text-sm font-extrabold transition-all duration-300"
            style={{ color: active ? 'var(--background)' : 'var(--muted)' }}
          >
            {active && (
              <motion.div
                layoutId="activeTabIndicator"
                className="absolute inset-0"
                transition={{ type: 'spring', bounce: 0.15, duration: 0.45 }}
                style={{
                  borderRadius: 999,
                  background: 'linear-gradient(135deg, var(--accent) 0%, color-mix(in srgb, var(--accent) 35%, white) 100%)',
                  boxShadow: '0 14px 28px -20px color-mix(in srgb, var(--accent) 55%, transparent)',
                }}
              />
            )}
            <span className="relative z-10">{tab.label}</span>
          </button>
        );
      })}
    </div>
  );
};

export default AuthTabs;
