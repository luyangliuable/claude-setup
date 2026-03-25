# OpenAI Codex CLI Configuration

**CRITICAL: wire_api must be "chat" for Codex to work**

- In `~/.codex/config.toml`, the `[model_providers.litellm]` section MUST use `wire_api = "chat"`
- Despite deprecation warnings, `wire_api = "responses"` does NOT work with aipe- models
- The "responses" API causes tool_calls errors with LiteLLM/GenAI Studio
- Keep `wire_api = "chat"` until OpenAI/LiteLLM fully supports the responses API
