/**
 * @fileoverview File viewer component with copy functionality.
 */

'use client';

import { useState } from 'react';

interface FileViewerProps {
  content: string;
  fileName: string;
}

/**
 * File viewer component.
 *
 * @param content - File content.
 * @param fileName - File name.
 * @returns File viewer component.
 */
export default function FileViewer({ content, fileName }: FileViewerProps) {
  const [copied, setCopied] = useState(false);

  /**
   * Copies content to clipboard.
   */
  const handleCopy = async () => {
    await navigator.clipboard.writeText(content);
    setCopied(true);
    setTimeout(() => setCopied(false), 2000);
  };

  return (
    <div className="card">
      <div className="flex items-center justify-between mb-4">
        <h3 className="text-lg font-semibold text-gray-900">{fileName}</h3>
        <button
          onClick={handleCopy}
          className={`
            px-4 py-2 rounded-lg text-sm font-medium
            transition-colors duration-200
            ${
              copied
                ? 'bg-green-100 text-green-700'
                : 'bg-gray-100 text-gray-700 hover:bg-gray-200'
            }
          `}
        >
          {copied ? 'Copied!' : 'Copy'}
        </button>
      </div>
      <pre className="whitespace-pre-wrap text-sm text-gray-700 font-mono bg-gray-50 p-4 rounded-lg overflow-x-auto">
        {content}
      </pre>
    </div>
  );
}
