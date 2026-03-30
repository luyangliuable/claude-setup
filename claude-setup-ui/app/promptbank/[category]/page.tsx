/**
 * @fileoverview Prompts in category listing page.
 */

import Link from 'next/link';
import Breadcrumbs from '@/components/breadcrumbs';
import { listPromptsInCategory } from '@/actions/promptbank';

interface CategoryPageProps {
  params: Promise<{ category: string }>;
}

/**
 * Category page component.
 *
 * @param params - Route parameters.
 * @returns Category page.
 */
export default async function CategoryPage({ params }: CategoryPageProps) {
  const { category } = await params;
  const result = await listPromptsInCategory(category);

  if (!result.success || !result.data) {
    return (
      <div>
        <Breadcrumbs
          items={[
            { label: 'Home', href: '/' },
            { label: 'Promptbank', href: '/promptbank' },
            { label: category },
          ]}
        />
        <div className="card bg-red-50 border-red-200">
          <p className="text-red-700">Error: {result.error}</p>
        </div>
      </div>
    );
  }

  const prompts = result.data;

  return (
    <div>
      <Breadcrumbs
        items={[
          { label: 'Home', href: '/' },
          { label: 'Promptbank', href: '/promptbank' },
          { label: category },
        ]}
      />

      <div className="mb-8">
        <h1 className="text-3xl font-bold text-gray-900 mb-2 capitalize">
          {category.replace(/-/g, ' ')}
        </h1>
        <p className="text-gray-600">
          {prompts.length} {prompts.length === 1 ? 'prompt' : 'prompts'}
        </p>
      </div>

      <div className="space-y-4">
        {prompts.map((prompt) => (
          <Link
            key={prompt.name}
            href={`/promptbank/${category}/${prompt.name}`}
            className="block card hover:border-primary-200"
          >
            <h3 className="text-lg font-semibold text-gray-900 capitalize">
              {prompt.name.replace(/-/g, ' ')}
            </h3>
          </Link>
        ))}
      </div>
    </div>
  );
}
