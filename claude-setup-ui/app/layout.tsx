/**
 * @fileoverview Root layout with navigation.
 */

import type { Metadata } from 'next';
import './globals.css';
import Navigation from '@/components/navigation';

export const metadata: Metadata = {
  title: 'Claude Setup Manager',
  description: 'Manage Claude Code configurations and resources',
};

/**
 * Root layout component.
 *
 * @param children - Child components.
 * @returns Layout component.
 */
export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html lang="en">
      <body className="antialiased">
        <div className="flex h-screen bg-gray-50">
          <Navigation />
          <main className="flex-1 overflow-y-auto">
            <div className="container mx-auto px-6 py-8 max-w-7xl">
              {children}
            </div>
          </main>
        </div>
      </body>
    </html>
  );
}
