/**
 * @fileoverview Type definitions for Claude Setup UI.
 */

export interface Prompt {
  name: string;
  category: string;
  path: string;
  content?: string;
}

export interface Rule {
  name: string;
  category: string;
  path: string;
  content?: string;
}

export interface Skill {
  name: string;
  path: string;
  description?: string;
}

export interface Category {
  name: string;
  path: string;
  count: number;
}

export interface Section {
  title: string;
  content: string;
  level: number;
}

export interface ActionResult<T = void> {
  success: boolean;
  data?: T;
  error?: string;
}
