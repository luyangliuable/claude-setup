/**
 * @fileoverview Server actions for CLAUDE.md configuration operations.
 */

'use server';

import { readFile, writeFile } from 'fs/promises';
import { PATHS } from '@/lib/paths';
import type { Section, ActionResult } from '@/types';

/**
 * Gets CLAUDE.md content.
 *
 * @returns CLAUDE.md content.
 */
export async function getClaudeMdContent(): Promise<ActionResult<string>> {
  try {
    const content = await readFile(PATHS.CLAUDE_MD, 'utf-8');
    return { success: true, data: content };
  } catch (error) {
    return {
      success: false,
      error: error instanceof Error ? error.message : 'Failed to read CLAUDE.md',
    };
  }
}

/**
 * Updates CLAUDE.md content.
 *
 * @param content - New content.
 * @returns Success status.
 */
export async function updateClaudeMdContent(content: string): Promise<ActionResult> {
  try {
    await writeFile(PATHS.CLAUDE_MD, content, 'utf-8');
    return { success: true };
  } catch (error) {
    return {
      success: false,
      error: error instanceof Error ? error.message : 'Failed to update CLAUDE.md',
    };
  }
}

/**
 * Parses CLAUDE.md into sections.
 *
 * @returns List of sections.
 */
export async function getClaudeMdSections(): Promise<ActionResult<Section[]>> {
  try {
    const content = await readFile(PATHS.CLAUDE_MD, 'utf-8');
    const lines = content.split('\n');
    const sections: Section[] = [];
    let currentSection: Section | null = null;
    let currentContent: string[] = [];

    for (const line of lines) {
      const match = line.match(/^(#{1,6})\s+(.+)$/);
      if (match) {
        if (currentSection) {
          currentSection.content = currentContent.join('\n').trim();
          sections.push(currentSection);
        }
        currentSection = {
          title: match[2],
          content: '',
          level: match[1].length,
        };
        currentContent = [];
      } else if (currentSection) {
        currentContent.push(line);
      }
    }

    if (currentSection) {
      currentSection.content = currentContent.join('\n').trim();
      sections.push(currentSection);
    }

    return { success: true, data: sections };
  } catch (error) {
    return {
      success: false,
      error: error instanceof Error ? error.message : 'Failed to parse CLAUDE.md',
    };
  }
}
