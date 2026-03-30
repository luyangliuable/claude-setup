# Claude Setup UI

A modern, web-based interface for managing Claude Code configurations and resources.

## Features

- **Promptbank Management**: Browse and edit reusable prompt templates organized by category (git, testing, code-review, debugging, workflow)
- **Rules Browser**: View and edit coding standards and guidelines across different categories
- **Skills Explorer**: Browse available agent skills with documentation
- **Config Editor**: Edit CLAUDE.md configuration file with syntax highlighting
- **Copy to Clipboard**: Quickly copy any file content
- **Responsive Design**: Clean, modern UI following Linear-inspired design principles

## Getting Started

### Prerequisites

- Node.js 18+ installed
- claude-setup repository at ~/claude-setup

### Installation

```bash
cd claude-setup-ui
npm install
```

### Development

Start the development server:

```bash
npm run dev
```

Open [http://localhost:3000](http://localhost:3000) in your browser.

### Build for Production

```bash
npm run build
npm start
```

## Project Structure

```
claude-setup-ui/
├── app/                          # Next.js App Router pages
│   ├── layout.tsx                # Root layout with navigation
│   ├── page.tsx                  # Dashboard
│   ├── promptbank/               # Promptbank section
│   ├── rules/                    # Rules section
│   ├── skills/                   # Skills section
│   └── config/                   # Config section
├── actions/                      # Server actions for file operations
│   ├── promptbank.ts
│   ├── rules.ts
│   ├── skills.ts
│   └── config.ts
├── components/                   # Reusable UI components
│   ├── navigation.tsx
│   ├── breadcrumbs.tsx
│   ├── file-viewer.tsx
│   └── file-editor.tsx
├── lib/                          # Utility functions
│   └── paths.ts                  # Path validation
└── types/                        # TypeScript type definitions
    └── index.ts
```

## Design Principles

- Professional, intelligent, modern, and trustworthy
- Clean design inspired by Linear (linear.app)
- Primary color: #002c5f (Corporate blue)
- Accent color: #ffd100 (Brand yellow)
- Soft shadows and rounded corners
- Generous whitespace

## Security

All file operations are validated to ensure they only access files within approved directories:
- ~/claude-setup/promptbank/
- ~/claude-setup/global/rules/
- ~/claude-setup/.agents/skills/
- ~/claude-setup/global/CLAUDE.md

## Technology Stack

- **Next.js 16** - React framework with App Router
- **TypeScript** - Type safety
- **Tailwind CSS** - Utility-first styling
- **Server Actions** - Secure file operations

## License

ISC
