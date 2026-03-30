/**
 * @fileoverview Breadcrumbs navigation component.
 */

'use client';

import Link from 'next/link';
import { Fragment } from 'react';

interface BreadcrumbItem {
  label: string;
  href?: string;
}

interface BreadcrumbsProps {
  items: BreadcrumbItem[];
}

/**
 * Breadcrumbs navigation component.
 *
 * @param items - Breadcrumb items.
 * @returns Breadcrumbs component.
 */
export default function Breadcrumbs({ items }: BreadcrumbsProps) {
  return (
    <nav className="flex items-center space-x-2 text-sm text-gray-600 mb-6">
      {items.map((item, index) => (
        <Fragment key={index}>
          {index > 0 && <span className="text-gray-400">/</span>}
          {item.href ? (
            <Link
              href={item.href}
              className="hover:text-primary-600 transition-colors"
            >
              {item.label}
            </Link>
          ) : (
            <span className="text-gray-900 font-medium">{item.label}</span>
          )}
        </Fragment>
      ))}
    </nav>
  );
}
