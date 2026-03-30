/**
 * @fileoverview Rules in category listing page.
 */

import Link from 'next/link';
import Breadcrumbs from '@/components/breadcrumbs';
import { listRulesInCategory } from '@/actions/rules';

interface CategoryPageProps {
  params: Promise<{ category: string }>;
}

/**
 * Rules category page component.
 *
 * @param params - Route parameters.
 * @returns Category page.
 */
export default async function RulesCategoryPage({ params }: CategoryPageProps) {
  const { category } = await params;
  const result = await listRulesInCategory(category);

  if (!result.success || !result.data) {
    return (
      <div>
        <Breadcrumbs
          items={[
            { label: 'Home', href: '/' },
            { label: 'Rules', href: '/rules' },
            { label: category },
          ]}
        />
        <div className="card bg-red-50 border-red-200">
          <p className="text-red-700">Error: {result.error}</p>
        </div>
      </div>
    );
  }

  const rules = result.data;

  return (
    <div>
      <Breadcrumbs
        items={[
          { label: 'Home', href: '/' },
          { label: 'Rules', href: '/rules' },
          { label: category },
        ]}
      />

      <div className="mb-8">
        <h1 className="text-3xl font-bold text-gray-900 mb-2 capitalize">
          {category.replace(/-/g, ' ')}
        </h1>
        <p className="text-gray-600">
          {rules.length} {rules.length === 1 ? 'rule' : 'rules'}
        </p>
      </div>

      <div className="space-y-4">
        {rules.map((rule) => (
          <Link
            key={rule.name}
            href={`/rules/${category}/${rule.name}`}
            className="block card hover:border-primary-200"
          >
            <h3 className="text-lg font-semibold text-gray-900 capitalize">
              {rule.name.replace(/-/g, ' ')}
            </h3>
          </Link>
        ))}
      </div>
    </div>
  );
}
