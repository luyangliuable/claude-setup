/**
 * @fileoverview Server actions for rules operations.
 */

'use server';

import { readdir, readFile, writeFile } from 'fs/promises';
import { join, basename } from 'path';
import { PATHS, getSecurePath } from '@/lib/paths';
import type { Rule, Category, ActionResult } from '@/types';

/**
 * Lists all rule categories.
 *
 * @returns List of categories.
 */
export async function listRuleCategories(): Promise<ActionResult<Category[]>> {
  try {
    const entries = await readdir(PATHS.RULES, { withFileTypes: true });
    const categories: Category[] = [];

    for (const entry of entries) {
      if (entry.isDirectory()) {
        const categoryPath = join(PATHS.RULES, entry.name);
        const files = await readdir(categoryPath);
        const mdFiles = files.filter(f => f.endsWith('.md'));

        categories.push({
          name: entry.name,
          path: categoryPath,
          count: mdFiles.length,
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
 * Lists rules in a category.
 *
 * @param category - Category name.
 * @returns List of rules.
 */
export async function listRulesInCategory(category: string): Promise<ActionResult<Rule[]>> {
  try {
    const categoryPath = getSecurePath(category, PATHS.RULES);
    const files = await readdir(categoryPath);
    const rules: Rule[] = [];

    for (const file of files) {
      if (file.endsWith('.md')) {
        const name = basename(file, '.md');
        rules.push({
          name,
          category,
          path: join(categoryPath, file),
        });
      }
    }

    return { success: true, data: rules };
  } catch (error) {
    return {
      success: false,
      error: error instanceof Error ? error.message : 'Failed to list rules',
    };
  }
}

/**
 * Gets rule content.
 *
 * @param rulePath - Path to rule file.
 * @returns Rule content.
 */
export async function getRuleContent(rulePath: string): Promise<ActionResult<string>> {
  try {
    const content = await readFile(rulePath, 'utf-8');
    return { success: true, data: content };
  } catch (error) {
    return {
      success: false,
      error: error instanceof Error ? error.message : 'Failed to read rule',
    };
  }
}

/**
 * Updates rule content.
 *
 * @param rulePath - Path to rule file.
 * @param content - New content.
 * @returns Success status.
 */
export async function updateRuleContent(
  rulePath: string,
  content: string
): Promise<ActionResult> {
  try {
    await writeFile(rulePath, content, 'utf-8');
    return { success: true };
  } catch (error) {
    return {
      success: false,
      error: error instanceof Error ? error.message : 'Failed to update rule',
    };
  }
}
