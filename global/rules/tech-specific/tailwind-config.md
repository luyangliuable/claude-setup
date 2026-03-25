# Tailwind CSS Configuration (Component Libraries)

**Best practices for bundling Tailwind in reusable libraries:**

## 1. Minimal tailwind.config.js

```javascript
const themeColors = require('./theme-colors.cjs');

module.exports = {
  content: ['./components/**/*.{js,ts,jsx,tsx}', './hooks/**/*.{js,ts,jsx,tsx}', './utils/**/*.{js,ts,jsx,tsx}', './index.ts'],
  safelist: [{ pattern: /^(bg|text|border)-(primary|accent|success|warning|error)-(50|100|200|300|400|500|600|700|800|900)$/ }],
  theme: { extend: { colors: themeColors } },
};
```

## 2. Enable Preflight (CSS Resets)

- Tailwind preflight handles button/form resets automatically
- No need for `corePlugins: { preflight: false }` or custom resets
- Prevents browser default styles (e.g., `buttonface`) from overriding utilities

## 3. Use Safelist for Library Colors

- Tailwind JIT only generates classes used in scanned files
- Safelist ensures all color variants are bundled for consumers
- Pattern: `/^(bg|text|border)-(colorName)-(shade)$/`

## 4. NO postcss.config.js

- Causes Vitest instrumentation to hang (see bug-db #12)
- Use Tailwind CLI directly: `tailwindcss -i ./styles.css -o ./dist/index.css --minify`

## 5. DRY Principle

- Keep colors in theme-colors.cjs (single source of truth)
- Import into tailwind.config.js: `colors: themeColors`
