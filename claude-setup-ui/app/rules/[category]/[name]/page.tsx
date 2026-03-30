/**
 * @fileoverview Individual rule view/edit page.
 */

'use client';

import { useState, useEffect } from 'react';
import { useRouter } from 'next/navigation';
import Breadcrumbs from '@/components/breadcrumbs';
import FileViewer from '@/components/file-viewer';
import FileEditor from '@/components/file-editor';
import { getRuleContent, updateRuleContent } from '@/actions/rules';

interface RulePageProps {
  params: Promise<{ category: string; name: string }>;
}

/**
 * Rule detail page component.
 *
 * @param params - Route parameters.
 * @returns Rule page.
 */
export default function RulePage({ params }: RulePageProps) {
  const router = useRouter();
  const [category, setCategory] = useState('');
  const [name, setName] = useState('');
  const [content, setContent] = useState('');
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);
  const [editing, setEditing] = useState(false);

  useEffect(() => {
    params.then(async (p) => {
      setCategory(p.category);
      setName(p.name);

      const rulePath = `/Users/liul31/claude-setup/global/rules/${p.category}/${p.name}.md`;
      const result = await getRuleContent(rulePath);

      if (result.success && result.data) {
        setContent(result.data);
      } else {
        setError(result.error ?? 'Failed to load rule');
      }

      setLoading(false);
    });
  }, [params]);

  /**
   * Handles save operation.
   *
   * @param newContent - Updated content.
   * @returns Save result.
   */
  const handleSave = async (newContent: string) => {
    const rulePath = `/Users/liul31/claude-setup/global/rules/${category}/${name}.md`;
    const result = await updateRuleContent(rulePath, newContent);

    if (result.success) {
      setContent(newContent);
      setEditing(false);
      router.refresh();
    }

    return result;
  };

  if (loading) {
    return (
      <div>
        <Breadcrumbs
          items={[
            { label: 'Home', href: '/' },
            { label: 'Rules', href: '/rules' },
            { label: 'Loading...' },
          ]}
        />
        <div className="card">
          <p className="text-gray-600">Loading...</p>
        </div>
      </div>
    );
  }

  if (error) {
    return (
      <div>
        <Breadcrumbs
          items={[
            { label: 'Home', href: '/' },
            { label: 'Rules', href: '/rules' },
            { label: 'Error' },
          ]}
        />
        <div className="card bg-red-50 border-red-200">
          <p className="text-red-700">Error: {error}</p>
        </div>
      </div>
    );
  }

  return (
    <div>
      <Breadcrumbs
        items={[
          { label: 'Home', href: '/' },
          { label: 'Rules', href: '/rules' },
          { label: category, href: `/rules/${category}` },
          { label: name },
        ]}
      />

      <div className="mb-6">
        <div className="flex items-center justify-between">
          <h1 className="text-3xl font-bold text-gray-900 capitalize">
            {name.replace(/-/g, ' ')}
          </h1>
          {!editing && (
            <button
              onClick={() => setEditing(true)}
              className="btn-primary"
            >
              Edit
            </button>
          )}
        </div>
      </div>

      {editing ? (
        <FileEditor
          initialContent={content}
          fileName={`${name}.md`}
          onSave={handleSave}
          onCancel={() => setEditing(false)}
        />
      ) : (
        <FileViewer content={content} fileName={`${name}.md`} />
      )}
    </div>
  );
}
