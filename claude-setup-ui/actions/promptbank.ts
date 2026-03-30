/**
 * @fileoverview Server actions for promptbank operations.
 */

'use server';

import { readdir, readFile, writeFile } from 'fs/promises';
import { join, basename } from 'path';
import { PATHS, getSecurePath } from '@/lib/paths';
import type { Prompt, Category, ActionResult } from '@/types';

/**
 * Lists all promptbank categories.
 *
 * @returns List of categories.
 */
export async function listPromptCategories(): Promise<ActionResult<Category[]>> {
  try {
    const entries = await readdir(PATHS.PROMPTBANK, { withFileTypes: true });
    const categories: Category[] = [];

    for (const entry of entries) {
      if (entry.isDirectory()) {
        const categoryPath = join(PATHS.PROMPTBANK, entry.name);
        const files = await readdir(categoryPath);
        const txtFiles = files.filter(f => f.endsWith('.txt'));

        categories.push({
          name: entry.name,
          path: categoryPath,
          count: txtFiles.length,
        });
      }
    }

    return { success: true, data: categories };
  } catch (error) {
    return {
      success: false,
      error: error instanceof Error ? error.message : 'Failed to list categories',
    };
  }
}

/**
 * Lists prompts in a category.
 *
 * @param category - Category name.
 * @returns List of prompts.
 */
export async function listPromptsInCategory(category: string): Promise<ActionResult<Prompt[]>> {
  try {
    const categoryPath = getSecurePath(category, PATHS.PROMPTBANK);
    const files = await readdir(categoryPath);
    const prompts: Prompt[] = [];

    for (const file of files) {
      if (file.endsWith('.txt')) {
        const name = basename(file, '.txt');
        prompts.push({
          name,
          category,
          path: join(categoryPath, file),
        });
      }
    }

    return { success: true, data: prompts };
  } catch (error) {
    return {
      success: false,
      error: error instanceof Error ? error.message : 'Failed to list prompts',
    };
  }
}

/**
 * Gets prompt content.
 *
 * @param promptPath - Path to prompt file.
 * @returns Prompt content.
 */
export async function getPromptContent(promptPath: string): Promise<ActionResult<string>> {
  try {
    const content = await readFile(promptPath, 'utf-8');
    return { success: true, data: content };
  } catch (error) {
    return {
      success: false,
      error: error instanceof Error ? error.message : 'Failed to read prompt',
    };
  }
}

/**
 * Updates prompt content.
 *
 * @param promptPath - Path to prompt file.
 * @param content - New content.
 * @returns Success status.
 */
export async function updatePromptContent(
  promptPath: string,
  content: string
): Promise<ActionResult> {
  try {
    await writeFile(promptPath, content, 'utf-8');
    return { success: true };
  } catch (error) {
    return {
      success: false,
      error: error instanceof Error ? error.message : 'Failed to update prompt',
    };
  }
}
