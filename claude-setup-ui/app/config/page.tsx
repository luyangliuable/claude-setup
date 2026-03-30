/**
 * @fileoverview CLAUDE.md configuration page.
 */

'use client';

import { useState, useEffect } from 'react';
import { useRouter } from 'next/navigation';
import Breadcrumbs from '@/components/breadcrumbs';
import FileViewer from '@/components/file-viewer';
import FileEditor from '@/components/file-editor';
import { getClaudeMdContent, updateClaudeMdContent } from '@/actions/config';

/**
 * Config page component.
 *
 * @returns Config page.
 */
export default function ConfigPage() {
  const router = useRouter();
  const [content, setContent] = useState('');
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);
  const [editing, setEditing] = useState(false);

  useEffect(() => {
    const loadContent = async () => {
      const result = await getClaudeMdContent();

      if (result.success && result.data) {
        setContent(result.data);
      } else {
        setError(result.error ?? 'Failed to load CLAUDE.md');
      }

      setLoading(false);
    };

    loadContent();
  }, []);

  /**
   * Handles save operation.
   *
   * @param newContent - Updated content.
   * @returns Save result.
   */
  const handleSave = async (newContent: string) => {
    const result = await updateClaudeMdContent(newContent);

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
          items={[{ label: 'Home', href: '/' }, { label: 'Config' }]}
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
          items={[{ label: 'Home', href: '/' }, { label: 'Config' }]}
        />
        <div className="card bg-red-50 border-red-200">
          <p className="text-red-700">Error: {error}</p>
        </div>
      </div>
    );
  }

  return (
    <div>
      <Breadcrumbs items={[{ label: 'Home', href: '/' }, { label: 'Config' }]} />

      <div className="mb-6">
        <div className="flex items-center justify-between">
          <div>
            <h1 className="text-3xl font-bold text-gray-900 mb-2">
              CLAUDE.md Configuration
            </h1>
            <p className="text-gray-600">
              System-wide configuration for Claude Code
            </p>
          </div>
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
          fileName="CLAUDE.md"
          onSave={handleSave}
          onCancel={() => setEditing(false)}
        />
      ) : (
        <FileViewer content={content} fileName="CLAUDE.md" />
      )}
    </div>
  );
}
