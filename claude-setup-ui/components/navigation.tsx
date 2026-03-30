/**
 * @fileoverview Main navigation component.
 */

'use client';

import Link from 'next/link';
import { usePathname } from 'next/navigation';

const navItems = [
  { href: '/', label: 'Dashboard' },
  { href: '/promptbank', label: 'Promptbank' },
  { href: '/rules', label: 'Rules' },
  { href: '/skills', label: 'Skills' },
  { href: '/config', label: 'Config' },
];

/**
 * Navigation sidebar component.
 *
 * @returns Navigation component.
 */
export default function Navigation() {
  const pathname = usePathname();

  return (
    <nav className="w-64 bg-white border-r border-gray-200 p-6">
      <div className="mb-8">
        <h1 className="text-2xl font-bold text-primary-500">
          Claude Setup
        </h1>
        <p className="text-sm text-gray-600 mt-1">Configuration Manager</p>
      </div>

      <ul className="space-y-2">
        {navItems.map((item) => {
          const isActive = pathname === item.href ||
            (item.href !== '/' && pathname.startsWith(item.href));

          return (
            <li key={item.href}>
              <Link
                href={item.href}
                className={`
                  flex items-center gap-3 px-4 py-3 rounded-lg
                  transition-colors duration-200
                  ${
                    isActive
                      ? 'bg-primary-50 text-primary-700 font-medium'
                      : 'text-gray-700 hover:bg-gray-100'
                  }
                `}
              >
                <span>{item.label}</span>
              </Link>
            </li>
          );
        })}
      </ul>
    </nav>
  );
}
