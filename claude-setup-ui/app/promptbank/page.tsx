/**
 * @fileoverview Promptbank categories listing page.
 */

import Link from 'next/link';
import Breadcrumbs from '@/components/breadcrumbs';
import { listPromptCategories } from '@/actions/promptbank';

/**
 * Promptbank page component.
 *
 * @returns Promptbank page.
 */
export default async function PromptbankPage() {
  const result = await listPromptCategories();

  if (!result.success || !result.data) {
    return (
      <div>
        <Breadcrumbs items={[{ label: 'Home', href: '/' }, { label: 'Promptbank' }]} />
        <div className="card bg-red-50 border-red-200">
          <p className="text-red-700">Error: {result.error}</p>
        </div>
      </div>
    );
  }

  const categories = result.data;

  return (
    <div>
      <Breadcrumbs items={[{ label: 'Home', href: '/' }, { label: 'Promptbank' }]} />

      <div className="mb-8">
        <h1 className="text-3xl font-bold text-gray-900 mb-2">Promptbank</h1>
        <p className="text-gray-600">
          Browse and manage reusable prompt templates
        </p>
      </div>

      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
        {categories.map((category) => (
          <Link
            key={category.name}
            href={`/promptbank/${category.name}`}
            className="card hover:border-primary-200"
          >
            <h3 className="text-xl font-semibold text-gray-900 mb-2 capitalize">
              {category.name.replace(/-/g, ' ')}
            </h3>
            <p className="text-sm text-gray-600">
              {category.count} {category.count === 1 ? 'prompt' : 'prompts'}
            </p>
          </Link>
        ))}
      </div>
    </div>
  );
}
