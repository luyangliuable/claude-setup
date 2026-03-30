/**
 * @fileoverview Server actions for skills operations.
 */

'use server';

import { readdir, readFile } from 'fs/promises';
import { join } from 'path';
import { PATHS } from '@/lib/paths';
import type { Skill, ActionResult } from '@/types';

/**
 * Lists all skills.
 *
 * @returns List of skills.
 */
export async function listSkills(): Promise<ActionResult<Skill[]>> {
  try {
    const entries = await readdir(PATHS.SKILLS, { withFileTypes: true });
    const skills: Skill[] = [];

    for (const entry of entries) {
      if (entry.isDirectory()) {
        const skillPath = join(PATHS.SKILLS, entry.name);
        let description = '';

        try {
          const skillMdPath = join(skillPath, 'SKILL.md');
          const content = await readFile(skillMdPath, 'utf-8');
          const firstLine = content.split('\n').find(line => line.trim() && !line.startsWith('#'));
          description = firstLine?.trim() ?? '';
        } catch {
          // No SKILL.md or error reading it
        }

        skills.push({
          name: entry.name,
          path: skillPath,
          description,
        });
      }
    }

    return { success: true, data: skills };
  } catch (error) {
    return {
      success: false,
      error: error instanceof Error ? error.message : 'Failed to list skills',
    };
  }
}

/**
 * Gets skill details including SKILL.md content.
 *
 * @param skillName - Name of the skill.
 * @returns Skill content.
 */
export async function getSkillDetails(skillName: string): Promise<ActionResult<string>> {
  try {
    const skillPath = join(PATHS.SKILLS, skillName, 'SKILL.md');
    const content = await readFile(skillPath, 'utf-8');
    return { success: true, data: content };
  } catch (error) {
    return {
      success: false,
      error: error instanceof Error ? error.message : 'Failed to read skill details',
    };
  }
}

/**
 * Lists reference files in a skill directory.
 *
 * @param skillName - Name of the skill.
 * @returns List of reference files.
 */
export async function getSkillReferences(skillName: string): Promise<ActionResult<string[]>> {
  try {
    const skillPath = join(PATHS.SKILLS, skillName);
    const files = await readdir(skillPath);
    const references = files.filter(f => f !== 'SKILL.md' && (f.endsWith('.md') || f.endsWith('.txt')));

    return { success: true, data: references };
  } catch (error) {
    return {
      success: false,
      error: error instanceof Error ? error.message : 'Failed to list skill references',
    };
  }
}
