'use client';

import React, { useEffect } from 'react';
import { usePathname } from 'next/navigation';
import Sidebar from './Sidebar';
import { useThemeStore } from '@/store/useThemeStore';

export const LayoutWrapper = ({ children }: { children: React.ReactNode }) => {
  const pathname = usePathname();
  const hydrate = useThemeStore((s) => s.hydrate);

  useEffect(() => {
    hydrate();
  }, [hydrate]);

  // Define paths where Sidebar should NOT be shown
  const authPaths = ['/login', '/signup', '/signin'];
  const chatPaths = ['/learn/'];
  const landingPaths = ['/'];
  const showSidebar = !authPaths.some(path => pathname?.startsWith(path)) &&
    !chatPaths.some(path => pathname?.startsWith(path)) &&
    !landingPaths.includes(pathname || '');

  return (
    <div className="flex min-h-screen" style={{ backgroundColor: 'var(--background)', color: 'var(--foreground)' }}>
      {showSidebar && <Sidebar />}
      <main className={showSidebar ? "flex-1 transition-all duration-300 lg:ml-80" : "flex-1"}>
        <div className="h-full w-full">
          {children}
        </div>
      </main>
    </div>
  );
};

export default LayoutWrapper;
