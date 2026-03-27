'use client';

import React, { useEffect } from 'react';
import { usePathname } from 'next/navigation';
import Sidebar from './Sidebar';
import BottomNav from './BottomNav';
import { useThemeStore } from '@/store/useThemeStore';

export const LayoutWrapper = ({ children }: { children: React.ReactNode }) => {
  const pathname = usePathname();
  const hydrate = useThemeStore((s) => s.hydrate);

  useEffect(() => {
    hydrate();
  }, [hydrate]);

  // Define paths where Sidebar and BottomNav should NOT be shown
  const authPaths = ['/signin', '/signup'];
  const chatPaths = ['/learn/'];
  const landingPaths = ['/'];
  const showNav = !authPaths.some(path => pathname?.startsWith(path)) &&
    !chatPaths.some(path => pathname?.startsWith(path)) &&
    !landingPaths.includes(pathname || '');

  return (
    <div className="flex min-h-screen" style={{ backgroundColor: 'var(--background)', color: 'var(--foreground)' }}>
      {showNav && <Sidebar />}
      {showNav && <BottomNav />}
      <main className={showNav ? "min-w-0 flex-1 transition-all duration-300 md:ml-0 lg:ml-80" : "min-w-0 flex-1"}>
        <div className="h-full w-full min-w-0 pb-20 lg:pb-0">
          {children}
        </div>
      </main>
    </div>
  );
};

export default LayoutWrapper;
