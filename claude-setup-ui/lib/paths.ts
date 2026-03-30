/**
 * @fileoverview Path utilities for secure file system operations.
 */

import { resolve, join } from 'path';
import { homedir } from 'os';

const BASE_DIR = resolve(homedir(), 'claude-setup');

export const PATHS = {
  PROMPTBANK: join(BASE_DIR, 'promptbank'),
  RULES: join(BASE_DIR, 'global', 'rules'),
  SKILLS: join(BASE_DIR, '.agents', 'skills'),
  CLAUDE_MD: join(BASE_DIR, 'global', 'CLAUDE.md'),
} as const;

/**
 * Validates that a path is within allowed directories.
 *
 * @param filePath - Path to validate.
 * @param baseDir - Base directory to check against.
 * @returns True if path is valid.
 */
export function isValidPath(filePath: string, baseDir: string): boolean {
  const resolved = resolve(filePath);
  const base = resolve(baseDir);
  return resolved.startsWith(base);
}

/**
 * Validates path and returns resolved path.
 *
 * @param filePath - Path to resolve.
 * @param baseDir - Base directory to check against.
 * @returns Resolved path.
 */
export function getSecurePath(filePath: string, baseDir: string): string {
  const resolved = resolve(baseDir, filePath);
  if (!isValidPath(resolved, baseDir)) {
    throw new Error('Invalid path: Access denied');
  }
  return resolved;
}
