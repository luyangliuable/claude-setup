# SOLID Principles in React

**Category:** React Best Practices
**Impact:** HIGH
**Difficulty to fix:** MEDIUM

## Overview

SOLID principles apply to React's functional, component-based architecture to reduce coupling, improve reusability, and make components easier to test.

---

## Single Responsibility Principle (SRP) in React

> A component should do one thing.

### Bad Example

```tsx
// Component doing too much: data fetching, state management, complex UI
function UserDashboard({ userId }) {
    const [user, setUser] = useState(null);
    const [posts, setPosts] = useState([]);
    const [loading, setLoading] = useState(true);
    const [activeTab, setActiveTab] = useState('posts');

    useEffect(() => {
        fetch(`/api/users/${userId}`)
            .then(res => res.json())
            .then(data => {
                setUser(data);
                return fetch(`/api/users/${userId}/posts`);
            })
            .then(res => res.json())
            .then(data => {
                setPosts(data);
                setLoading(false);
            });
    }, [userId]);

    if (loading) return <Spinner />;

    return (
        <div>
            <header>
                <img src={user.avatar} alt={user.name} />
                <h1>{user.name}</h1>
                <p>{user.bio}</p>
            </header>
            <nav>
                <button onClick={() => setActiveTab('posts')}>Posts</button>
                <button onClick={() => setActiveTab('settings')}>Settings</button>
            </nav>
            {activeTab === 'posts' && (
                <ul>
                    {posts.map(post => (
                        <li key={post.id}>{post.title}</li>
                    ))}
                </ul>
            )}
            {/* ... more complex UI */}
        </div>
    );
}
```

### Good Example

```tsx
// Custom hook for data fetching
function useUser(userId) {
    const [user, setUser] = useState(null);
    const [loading, setLoading] = useState(true);

    useEffect(() => {
        fetch(`/api/users/${userId}`)
            .then(res => res.json())
            .then(data => {
                setUser(data);
                setLoading(false);
            });
    }, [userId]);

    return { user, loading };
}

// Separate hook for posts
function useUserPosts(userId) {
    const [posts, setPosts] = useState([]);
    useEffect(() => {
        fetch(`/api/users/${userId}/posts`)
            .then(res => res.json())
            .then(setPosts);
    }, [userId]);
    return posts;
}

// Small, focused components
function UserHeader({ user }) {
    return (
        <header>
            <img src={user.avatar} alt={user.name} />
            <h1>{user.name}</h1>
            <p>{user.bio}</p>
        </header>
    );
}

function PostList({ posts }) {
    return (
        <ul>
            {posts.map(post => (
                <li key={post.id}>{post.title}</li>
            ))}
        </ul>
    );
}

// Main component orchestrates
function UserDashboard({ userId }) {
    const { user, loading } = useUser(userId);
    const posts = useUserPosts(userId);
    const [activeTab, setActiveTab] = useState('posts');

    if (loading) return <Spinner />;

    return (
        <div>
            <UserHeader user={user} />
            <TabNavigation activeTab={activeTab} onTabChange={setActiveTab} />
            {activeTab === 'posts' && <PostList posts={posts} />}
        </div>
    );
}
```

---

## Open/Closed Principle (OCP) in React

> Components should be open for extension but closed for modification.

Use props, composition, or higher-order components to change behavior.

### Bad Example

```tsx
// Must modify component to add new button types
function Button({ type, children }) {
    if (type === 'primary') {
        return <button className="bg-blue-500 text-white">{children}</button>;
    }
    if (type === 'danger') {
        return <button className="bg-red-500 text-white">{children}</button>;
    }
    if (type === 'success') {
        return <button className="bg-green-500 text-white">{children}</button>;
    }
    // Adding new type requires modifying this component
    return <button>{children}</button>;
}
```

### Good Example

```tsx
// Base button that's closed for modification
function Button({ className, children, ...props }) {
    return (
        <button
            className={`px-4 py-2 rounded ${className}`}
            {...props}
        >
            {children}
        </button>
    );
}

// Extended through composition - no modification needed
function PrimaryButton({ children, ...props }) {
    return <Button className="bg-blue-500 text-white" {...props}>{children}</Button>;
}

function DangerButton({ children, ...props }) {
    return <Button className="bg-red-500 text-white" {...props}>{children}</Button>;
}

// Can add new variants without touching Button
function GhostButton({ children, ...props }) {
    return <Button className="border border-gray-300 bg-transparent" {...props}>{children}</Button>;
}
```

---

## Liskov Substitution Principle (LSP) in React

> Components should be swappable without breaking the app.

If a child component extends a parent's functionality, it should not break expected behavior.

### Bad Example

```tsx
// Base input component
function TextInput({ value, onChange, ...props }) {
    return <input type="text" value={value} onChange={onChange} {...props} />;
}

// "Extended" input that breaks the contract
function NumericInput({ value, onChange, ...props }) {
    // BREAKS LSP: onChange now receives a number, not an event!
    const handleChange = (e) => {
        const numValue = parseInt(e.target.value, 10);
        onChange(numValue); // Different signature than parent!
    };

    return <input type="text" value={value} onChange={handleChange} {...props} />;
}
```

### Good Example

```tsx
// Base input with consistent contract
function TextInput({ value, onChange, ...props }) {
    return <input type="text" value={value} onChange={onChange} {...props} />;
}

// Extended input maintains the same contract
function NumericInput({ value, onChange, ...props }) {
    const handleChange = (e) => {
        // Filter to numbers only, but keep same onChange signature
        e.target.value = e.target.value.replace(/[^0-9]/g, '');
        onChange(e); // Same signature as parent!
    };

    return <input type="text" value={value} onChange={handleChange} {...props} />;
}

// Both can be used interchangeably
function Form() {
    const [text, setText] = useState('');
    const [number, setNumber] = useState('');

    const handleTextChange = (e) => setText(e.target.value);
    const handleNumberChange = (e) => setNumber(e.target.value);

    return (
        <>
            <TextInput value={text} onChange={handleTextChange} />
            <NumericInput value={number} onChange={handleNumberChange} />
        </>
    );
}
```

---

## Interface Segregation Principle (ISP) in React

> Components should not depend on props they don't use.

Pass only necessary data to components.

### Bad Example

```tsx
// Passing entire user object when only name is needed
function UserGreeting({ user }) {
    // Only uses user.name, but receives entire object
    // including email, address, preferences, etc.
    return <h1>Hello, {user.name}!</h1>;
}

// Caller must provide full user object
<UserGreeting user={fullUserObject} />
```

### Good Example

```tsx
// Component only requests what it needs
function UserGreeting({ name }) {
    return <h1>Hello, {name}!</h1>;
}

// Caller provides only what's needed
<UserGreeting name={user.name} />

// For complex cases, use specific prop shapes
interface UserCardProps {
    name: string;
    avatarUrl: string;
    // Only the props this component actually uses
}

function UserCard({ name, avatarUrl }: UserCardProps) {
    return (
        <div>
            <img src={avatarUrl} alt={name} />
            <span>{name}</span>
        </div>
    );
}
```

---

## Dependency Inversion Principle (DIP) in React

> High-level components should depend on abstractions (context, hooks) rather than concrete implementations.

### Bad Example

```tsx
// Component directly depends on concrete implementation
function UserProfile({ userId }) {
    const [user, setUser] = useState(null);

    useEffect(() => {
        // Hardcoded to specific API
        fetch(`https://api.myapp.com/users/${userId}`)
            .then(res => res.json())
            .then(setUser);
    }, [userId]);

    // Hardcoded localStorage usage
    const savePreference = (pref) => {
        localStorage.setItem('user-pref', JSON.stringify(pref));
    };

    return <div>{/* ... */}</div>;
}
```

### Good Example

```tsx
// Abstract data fetching behind a hook/context
const ApiContext = createContext(null);

function useApi() {
    return useContext(ApiContext);
}

// Abstract storage behind a hook
const StorageContext = createContext(null);

function useStorage() {
    return useContext(StorageContext);
}

// Component depends on abstractions
function UserProfile({ userId }) {
    const api = useApi();
    const storage = useStorage();
    const [user, setUser] = useState(null);

    useEffect(() => {
        api.getUser(userId).then(setUser);
    }, [userId, api]);

    const savePreference = (pref) => {
        storage.set('user-pref', pref);
    };

    return <div>{/* ... */}</div>;
}

// Easy to test with mock implementations
function TestWrapper({ children }) {
    return (
        <ApiContext.Provider value={mockApi}>
            <StorageContext.Provider value={mockStorage}>
                {children}
            </StorageContext.Provider>
        </ApiContext.Provider>
    );
}
```

---

## Summary

| Principle | React Application |
|-----------|-------------------|
| **SRP** | Split components, use custom hooks for logic |
| **OCP** | Use props, composition, HOCs for extension |
| **LSP** | Maintain consistent prop contracts in component hierarchies |
| **ISP** | Pass only needed props, avoid prop drilling of large objects |
| **DIP** | Use Context and hooks to abstract dependencies |
