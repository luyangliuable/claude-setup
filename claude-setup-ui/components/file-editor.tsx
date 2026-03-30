/**
 * @fileoverview File editor component with save/cancel.
 */

'use client';

import { useState } from 'react';

interface FileEditorProps {
  initialContent: string;
  fileName: string;
  onSave: (content: string) => Promise<{ success: boolean; error?: string }>;
  onCancel: () => void;
}

/**
 * File editor component.
 *
 * @param initialContent - Initial file content.
 * @param fileName - File name.
 * @param onSave - Save handler.
 * @param onCancel - Cancel handler.
 * @returns File editor component.
 */
export default function FileEditor({
  initialContent,
  fileName,
  onSave,
  onCancel,
}: FileEditorProps) {
  const [content, setContent] = useState(initialContent);
  const [saving, setSaving] = useState(false);
  const [error, setError] = useState<string | null>(null);

  /**
   * Handles save operation.
   */
  const handleSave = async () => {
    setSaving(true);
    setError(null);

    const result = await onSave(content);

    if (result.success) {
      onCancel();
    } else {
      setError(result.error ?? 'Failed to save');
    }

    setSaving(false);
  };

  return (
    <div className="card">
      <div className="flex items-center justify-between mb-4">
        <h3 className="text-lg font-semibold text-gray-900">Edit {fileName}</h3>
        <div className="flex gap-2">
          <button
            onClick={onCancel}
            disabled={saving}
            className="btn-secondary disabled:opacity-50"
          >
            Cancel
          </button>
          <button
            onClick={handleSave}
            disabled={saving}
            className="btn-primary disabled:opacity-50"
          >
            {saving ? 'Saving...' : 'Save'}
          </button>
        </div>
      </div>

      {error && (
        <div className="mb-4 p-3 bg-red-50 border border-red-200 rounded-lg text-red-700 text-sm">
          {error}
        </div>
      )}

      <textarea
        value={content}
        onChange={(e) => setContent(e.target.value)}
        className="w-full h-96 p-4 font-mono text-sm border border-gray-300 rounded-lg focus:ring-2 focus:ring-primary-500 focus:border-transparent"
        disabled={saving}
      />
    </div>
  );
}
