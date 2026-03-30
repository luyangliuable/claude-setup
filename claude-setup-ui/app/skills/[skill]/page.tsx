/**
 * @fileoverview Individual skill detail page.
 */

'use client';

import { useState, useEffect } from 'react';
import Breadcrumbs from '@/components/breadcrumbs';
import FileViewer from '@/components/file-viewer';
import { getSkillDetails, getSkillReferences } from '@/actions/skills';

interface SkillPageProps {
  params: Promise<{ skill: string }>;
}

/**
 * Skill detail page component.
 *
 * @param params - Route parameters.
 * @returns Skill page.
 */
export default function SkillPage({ params }: SkillPageProps) {
  const [skillName, setSkillName] = useState('');
  const [content, setContent] = useState('');
  const [references, setReferences] = useState<string[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    params.then(async (p) => {
      setSkillName(p.skill);

      const [detailsResult, referencesResult] = await Promise.all([
        getSkillDetails(p.skill),
        getSkillReferences(p.skill),
      ]);

      if (detailsResult.success && detailsResult.data) {
        setContent(detailsResult.data);
      } else {
        setError(detailsResult.error ?? 'Failed to load skill details');
      }

      if (referencesResult.success && referencesResult.data) {
        setReferences(referencesResult.data);
      }

      setLoading(false);
    });
  }, [params]);

  if (loading) {
    return (
      <div>
        <Breadcrumbs
          items={[
            { label: 'Home', href: '/' },
            { label: 'Skills', href: '/skills' },
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
            { label: 'Skills', href: '/skills' },
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
          { label: 'Skills', href: '/skills' },
          { label: skillName },
        ]}
      />

      <div className="mb-6">
        <h1 className="text-3xl font-bold text-gray-900">{skillName}</h1>
      </div>

      <div className="space-y-6">
        <FileViewer content={content} fileName="SKILL.md" />

        {references.length > 0 && (
          <div className="card">
            <h3 className="text-lg font-semibold text-gray-900 mb-4">
              Reference Files
            </h3>
            <ul className="space-y-2">
              {references.map((ref) => (
                <li key={ref} className="text-gray-700">
                  <span className="font-mono text-sm bg-gray-100 px-2 py-1 rounded">
                    {ref}
                  </span>
                </li>
              ))}
            </ul>
          </div>
        )}
      </div>
    </div>
  );
}
