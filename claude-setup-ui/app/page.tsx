/**
 * @fileoverview Dashboard home page.
 */

import Link from 'next/link';
import { listPromptCategories } from '@/actions/promptbank';
import { listRuleCategories } from '@/actions/rules';
import { listSkills } from '@/actions/skills';

/**
 * Dashboard page component.
 *
 * @returns Dashboard page.
 */
export default async function HomePage() {
  const [promptsResult, rulesResult, skillsResult] = await Promise.all([
    listPromptCategories(),
    listRuleCategories(),
    listSkills(),
  ]);

  const totalPrompts = promptsResult.data?.reduce((sum, cat) => sum + cat.count, 0) ?? 0;
  const totalRules = rulesResult.data?.reduce((sum, cat) => sum + cat.count, 0) ?? 0;
  const totalSkills = skillsResult.data?.length ?? 0;

  const quickLinks = [
    { href: '/promptbank', label: 'Browse Prompts', count: totalPrompts },
    { href: '/rules', label: 'View Rules', count: totalRules },
    { href: '/skills', label: 'Explore Skills', count: totalSkills },
    { href: '/config', label: 'Edit Config', count: null },
  ];

  return (
    <div>
      <div className="mb-8">
        <h1 className="text-3xl font-bold text-gray-900 mb-2">
          Claude Setup Manager
        </h1>
        <p className="text-gray-600">
          Manage your Claude Code configurations, prompts, rules, and skills
        </p>
      </div>

      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 mb-8">
        {quickLinks.map((link) => (
          <Link
            key={link.href}
            href={link.href}
            className="card hover:border-primary-200"
          >
            <h3 className="text-lg font-semibold text-gray-900 mb-1">
              {link.label}
            </h3>
            {link.count !== null && (
              <p className="text-sm text-gray-600">
                {link.count} items
              </p>
            )}
          </Link>
        ))}
      </div>

      <div className="card">
        <h2 className="text-xl font-semibold text-gray-900 mb-4">
          Getting Started
        </h2>
        <ul className="space-y-3 text-gray-700">
          <li className="flex items-start gap-3">
            <span className="text-primary-500 font-bold">•</span>
            <span>
              <strong>Promptbank:</strong> Browse and manage reusable prompt templates
              for git, testing, code review, and more
            </span>
          </li>
          <li className="flex items-start gap-3">
            <span className="text-primary-500 font-bold">•</span>
            <span>
              <strong>Rules:</strong> View and edit coding standards, conventions,
              and guidelines organized by category
            </span>
          </li>
          <li className="flex items-start gap-3">
            <span className="text-primary-500 font-bold">•</span>
            <span>
              <strong>Skills:</strong> Explore available agent skills with their
              documentation and reference files
            </span>
          </li>
          <li className="flex items-start gap-3">
            <span className="text-primary-500 font-bold">•</span>
            <span>
              <strong>Config:</strong> View and edit your CLAUDE.md configuration
              file with collapsible sections
            </span>
          </li>
        </ul>
      </div>
    </div>
  );
}
