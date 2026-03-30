/**
 * @fileoverview Skills listing page.
 */

import Link from 'next/link';
import Breadcrumbs from '@/components/breadcrumbs';
import { listSkills } from '@/actions/skills';

/**
 * Skills page component.
 *
 * @returns Skills page.
 */
export default async function SkillsPage() {
  const result = await listSkills();

  if (!result.success || !result.data) {
    return (
      <div>
        <Breadcrumbs items={[{ label: 'Home', href: '/' }, { label: 'Skills' }]} />
        <div className="card bg-red-50 border-red-200">
          <p className="text-red-700">Error: {result.error}</p>
        </div>
      </div>
    );
  }

  const skills = result.data;

  return (
    <div>
      <Breadcrumbs items={[{ label: 'Home', href: '/' }, { label: 'Skills' }]} />

      <div className="mb-8">
        <h1 className="text-3xl font-bold text-gray-900 mb-2">Skills</h1>
        <p className="text-gray-600">
          Explore available agent skills and their documentation
        </p>
      </div>

      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
        {skills.map((skill) => (
          <Link
            key={skill.name}
            href={`/skills/${skill.name}`}
            className="card hover:border-primary-200"
          >
            <h3 className="text-xl font-semibold text-gray-900 mb-2">
              {skill.name}
            </h3>
            {skill.description && (
              <p className="text-sm text-gray-600 line-clamp-2">
                {skill.description}
              </p>
            )}
          </Link>
        ))}
      </div>
    </div>
  );
}
