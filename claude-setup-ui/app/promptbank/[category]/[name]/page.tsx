/**
 * @fileoverview Individual prompt view/edit page.
 */

'use client';

import { useState, useEffect } from 'react';
import { useRouter } from 'next/navigation';
import Breadcrumbs from '@/components/breadcrumbs';
import FileViewer from '@/components/file-viewer';
import FileEditor from '@/components/file-editor';
import { getPromptContent, updatePromptContent } from '@/actions/promptbank';

interface PromptPageProps {
  params: Promise<{ category: string; name: string }>;
}

/**
 * Prompt detail page component.
 *
 * @param params - Route parameters.
 * @returns Prompt page.
 */
export default function PromptPage({ params }: PromptPageProps) {
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

      const promptPath = `/Users/liul31/claude-setup/promptbank/${p.category}/${p.name}.txt`;
      const result = await getPromptContent(promptPath);

      if (result.success && result.data) {
        setContent(result.data);
      } else {
        setError(result.error ?? 'Failed to load prompt');
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
    const promptPath = `/Users/liul31/claude-setup/promptbank/${category}/${name}.txt`;
    const result = await updatePromptContent(promptPath, newContent);

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
            { label: 'Promptbank', href: '/promptbank' },
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
            { label: 'Promptbank', href: '/promptbank' },
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
          { label: 'Promptbank', href: '/promptbank' },
          { label: category, href: `/promptbank/${category}` },
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
          fileName={`${name}.txt`}
          onSave={handleSave}
          onCancel={() => setEditing(false)}
        />
      ) : (
        <FileViewer content={content} fileName={`${name}.txt`} />
      )}
    </div>
  );
}
