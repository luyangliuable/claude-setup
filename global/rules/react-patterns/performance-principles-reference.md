# React Patterns - Performance Principles (Reference)

This file references universal performance patterns from react-best-practices skill that apply broadly. For detailed explanations with examples, see: `.agents/skills/react-best-practices/rules/`

## Re-rendering Optimization (Universal Concepts)

- **Memoization Principles** - See `rerender-memo.md`
- **Derived State** - See `rerender-derived-state.md`, `rerender-derived-state-no-effect.md`
- **Lazy State Initialization** - See `rerender-lazy-state-init.md`
- **Functional setState** - See `rerender-functional-setstate.md`
- **Dependency Management** - See `rerender-dependencies.md`
- **useRef for Transient Values** - See `rerender-use-ref-transient-values.md`

## JavaScript Performance (Language-Agnostic Concepts)

- **Cache Property Access** - See `js-cache-property-access.md`
- **Cache Function Results** - See `js-cache-function-results.md`
- **Early Exit** - See `js-early-exit.md`
- **Set/Map for Lookups** - See `js-set-map-lookups.md`
- **Combine Iterations** - See `js-combine-iterations.md`
- **Index Maps** - See `js-index-maps.md`

## Async Patterns (Universal Concepts)

- **Parallel Operations** - See `async-parallel.md`
- **Dependency Management** - See `async-dependencies.md`
- **Defer/Await Patterns** - See `async-defer-await.md`

## Bundle Optimization (Universal Concepts)

- **Dynamic Imports** - See `bundle-dynamic-imports.md`
- **Conditional Loading** - See `bundle-conditional.md`
- **Defer Third-Party Scripts** - See `bundle-defer-third-party.md`
- **Barrel Import Issues** - See `bundle-barrel-imports.md`

## Rendering Patterns (Universal Concepts)

- **Hoist JSX** - See `rendering-hoist-jsx.md`
- **Conditional Rendering** - See `rendering-conditional-render.md`
- **Content Visibility** - See `rendering-content-visibility.md`

---

**Note**: These patterns are maintained in the react-best-practices skill to avoid duplication. While focused on React/Next.js, many concepts (caching, memoization, async patterns, bundling) apply universally. Use the `/react-best-practices` skill for React-specific optimization reviews.
