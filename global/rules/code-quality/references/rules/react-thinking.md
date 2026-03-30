# Thinking in React

**Category:** React Best Practices
**Impact:** HIGH
**Source:** React Official Documentation

## The Five Steps

When building a UI with React, follow these five steps:

1. **Break the UI into a component hierarchy**
2. **Build a static version first**
3. **Find the minimal but complete UI state**
4. **Identify where state should live**
5. **Add inverse data flow**

---

## Step 1: Break UI into Component Hierarchy

Draw boxes around every component and name them.

### Techniques for Splitting Components

- **Programming**: Same technique as deciding on new functions/objects
- **Single Responsibility**: A component should ideally do one thing
- **CSS**: Consider what you would make class selectors for
- **Design**: How you would organize design layers
- **Data Model**: UI often maps to data structure

### Example Hierarchy

```
FilterableProductTable (container)
├── SearchBar (user input)
└── ProductTable (displays/filters list)
    ├── ProductCategoryRow (category heading)
    └── ProductRow (individual product)
```

---

## Step 2: Build a Static Version First

Build a version that renders the UI from data **without interactivity**.

### Key Principles

- **No state yet** - State is for interactivity (data that changes)
- **Just props** - Pass data from parent to child
- **Lots of typing, no thinking** - Mechanical work first
- **Can build top-down or bottom-up**

```tsx
// Static component - just renders props
function ProductRow({ product }) {
    const name = product.stocked ? product.name :
        <span style={{ color: 'red' }}>{product.name}</span>;

    return (
        <tr>
            <td>{name}</td>
            <td>{product.price}</td>
        </tr>
    );
}

function ProductTable({ products }) {
    const rows = [];
    let lastCategory = null;

    products.forEach((product) => {
        if (product.category !== lastCategory) {
            rows.push(
                <ProductCategoryRow
                    category={product.category}
                    key={product.category}
                />
            );
        }
        rows.push(
            <ProductRow product={product} key={product.name} />
        );
        lastCategory = product.category;
    });

    return (
        <table>
            <thead>
                <tr><th>Name</th><th>Price</th></tr>
            </thead>
            <tbody>{rows}</tbody>
        </table>
    );
}
```

---

## Step 3: Find Minimal But Complete State

> Keep state DRY (Don't Repeat Yourself). Figure out the absolute minimal representation and compute everything else on-demand.

### Questions to Identify State

For each piece of data, ask:

1. **Does it remain unchanged over time?** → Not state
2. **Is it passed from parent via props?** → Not state
3. **Can you compute it from existing state/props?** → Not state

What's left is probably state.

### Example Analysis

| Data | Is State? | Why? |
|------|-----------|------|
| Original product list | No | Passed as props |
| Search text | **Yes** | Changes over time, can't be computed |
| Checkbox value | **Yes** | Changes over time, can't be computed |
| Filtered product list | No | Can be computed from products + search + checkbox |

---

## Step 4: Identify Where State Should Live

React uses **one-way data flow** - data flows down from parent to child.

### Steps to Find State Location

1. **Identify every component** that renders based on that state
2. **Find their closest common parent**
3. **Decide where state lives**:
   - Often in their common parent
   - Or in a component above the common parent
   - Or create a new component just for holding state

### Example

```tsx
function FilterableProductTable({ products }) {
    // State lives here - common parent of SearchBar and ProductTable
    const [filterText, setFilterText] = useState('');
    const [inStockOnly, setInStockOnly] = useState(false);

    return (
        <div>
            <SearchBar
                filterText={filterText}
                inStockOnly={inStockOnly}
            />
            <ProductTable
                products={products}
                filterText={filterText}
                inStockOnly={inStockOnly}
            />
        </div>
    );
}
```

---

## Step 5: Add Inverse Data Flow

Let child components update parent state.

### The Pattern

1. Parent owns state and setter function
2. Parent passes setter to child as prop
3. Child calls setter to update parent state

```tsx
function FilterableProductTable({ products }) {
    const [filterText, setFilterText] = useState('');
    const [inStockOnly, setInStockOnly] = useState(false);

    return (
        <div>
            <SearchBar
                filterText={filterText}
                inStockOnly={inStockOnly}
                onFilterTextChange={setFilterText}      // Pass setter
                onInStockOnlyChange={setInStockOnly}   // Pass setter
            />
            <ProductTable
                products={products}
                filterText={filterText}
                inStockOnly={inStockOnly}
            />
        </div>
    );
}

function SearchBar({
    filterText,
    inStockOnly,
    onFilterTextChange,
    onInStockOnlyChange
}) {
    return (
        <form>
            <input
                type="text"
                value={filterText}
                placeholder="Search..."
                onChange={(e) => onFilterTextChange(e.target.value)}
            />
            <label>
                <input
                    type="checkbox"
                    checked={inStockOnly}
                    onChange={(e) => onInStockOnlyChange(e.target.checked)}
                />
                Only show products in stock
            </label>
        </form>
    );
}
```

---

## Key Principles Summary

1. **Components should be small and focused** (Single Responsibility)
2. **Props flow down, events flow up** (One-way data flow)
3. **State should be minimal** (Compute what you can)
4. **Lift state to common ancestor** (Shared state lives in common parent)
5. **Make data flow explicit** (No two-way binding magic)
6. **Build static first, then add interactivity**

---

## Anti-Patterns to Avoid

- Storing derived data in state
- Duplicating props in state
- Deep prop drilling (use Context for truly global data)
- Putting all state at the top level
- Two-way binding patterns
