---
name: list-models
description: List available models from an API endpoint. Queries /v1/models endpoint with API key. Supports OpenAI-compatible and LiteLLM endpoints.
license: MIT
allowed-tools: Bash, AskUserQuestion
metadata:
  author: luyangliuable
  version: "1.0.0"
  domain: development
  triggers: list models, available models, model catalog
---

# List Models

Query an API endpoint to retrieve available models.

## Usage

When invoked, ask the user for:
1. **API Endpoint URL** (e.g., https://api.openai.com)
2. **API Key**
3. **Auth Type**: Bearer or x-api-key

## Instructions

1. Construct request:
   - URL: `{endpoint}/v1/models`
   - Header: `Authorization: Bearer {key}` or `x-api-key: {key}`

2. Execute curl:
```bash
curl -s "{endpoint}/v1/models" \
  -H "Authorization: Bearer {api_key}" \
  -H "Content-Type: application/json"
```

3. Parse JSON and display:
   - Model ID
   - Owner
   - Created date (if available)

4. Handle errors:
   - Invalid endpoint
   - Auth failure
   - Network error

## Example Output

```
API Endpoint: https://api.openai.com
API Key: sk-...
Auth Type: Bearer

Available Models:
┌─────────────────────────┬──────────────┬─────────────┐
│ Model ID                │ Owner        │ Created     │
├─────────────────────────┼──────────────┼─────────────┤
│ gpt-4                   │ openai       │ 2023-03-01  │
│ gpt-4-turbo             │ openai       │ 2024-04-01  │
│ claude-opus-4-6         │ anthropic    │ 2024-11-01  │
└─────────────────────────┴──────────────┴─────────────┘
```
