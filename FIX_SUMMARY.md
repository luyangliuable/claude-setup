# Claude Setup Fix Summary - 2026-03-24

## Issues Fixed

### 1. Model Name Errors ✅
**Problem:** Invalid model names causing API 400 errors
- ❌ `aipe-bedrock-claude-haiku-4-5` (wrong format)
- ❌ `aipe-bedrock-claude-3-haiku` (version doesn't exist)

**Fixed:**
- ✅ Primary: `aipe-bedrock-claude-4-5-sonnet` (capable model)
- ✅ Small/Fast: `aipe-bedrock-claude-4-5-haiku` (fast model)

### 2. Auth Conflict ✅
**Problem:** Both `ANTHROPIC_AUTH_TOKEN` and `ANTHROPIC_API_KEY` set

**Fix Script Created:** `~/fix-auth-conflict.sh`
```bash
~/fix-auth-conflict.sh
source ~/.zshrc
env | grep ANTHROPIC  # Verify only ANTHROPIC_API_KEY remains
```

### 3. CLAUDE.md Organization ✅
**Problem:** Global CLAUDE.md at `~/CLAUDE.md` could conflict with project-specific ones

**Fixed:**
- Master file moved: `~/claude-setup/global/CLAUDE.md`
- Symlink created: `~/CLAUDE.md` → `~/claude-setup/global/CLAUDE.md`
- README added: `~/claude-setup/global/README.md`

## Correct Configuration

### Profile: `~/claude-setup/profiles/my-custom.json`
```json
{
  "env": {
    "ANTHROPIC_BASE_URL": "https://api.studio.genai.cba",
    "ANTHROPIC_MODEL": "aipe-bedrock-claude-4-5-sonnet",
    "ANTHROPIC_SMALL_FAST_MODEL": "aipe-bedrock-claude-4-5-haiku"
  }
}
```

### Available Models (GenAI Studio)
- `aipe-bedrock-claude-4-5-sonnet` (most capable)
- `aipe-bedrock-claude-4-5-haiku` (fastest)
- `aipe-bedrock-claude-4-sonnet`
- `aipe-bedrock-claude-3-7-sonnet`
- `aipe-bedrock-claude-3-5-sonnet-v2`

## Verification Steps

1. **Fix auth conflict:**
   ```bash
   ~/fix-auth-conflict.sh
   source ~/.zshrc
   ```

2. **Verify environment:**
   ```bash
   env | grep ANTHROPIC
   # Should see ANTHROPIC_API_KEY only (not ANTHROPIC_AUTH_TOKEN)
   ```

3. **Test profile:**
   ```bash
   _claude_profile_exec my-custom
   claude
   # Try: "hi" - should work without errors
   ```

4. **Verify global config:**
   ```bash
   ls -la ~/CLAUDE.md
   # Should show: ~/CLAUDE.md -> ~/claude-setup/global/CLAUDE.md
   ```

## File Structure

```
~/
├── CLAUDE.md -> ~/claude-setup/global/CLAUDE.md (symlink)
├── claude-setup/
│   ├── global/
│   │   ├── CLAUDE.md (master file)
│   │   └── README.md
│   └── profiles/
│       └── my-custom.json
└── fix-auth-conflict.sh
```

## Next Steps

1. Run the auth fix script
2. Reload your shell configuration
3. Test the my-custom profile
4. If everything works, you can delete `~/fix-auth-conflict.sh`
