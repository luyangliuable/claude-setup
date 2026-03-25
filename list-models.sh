#!/bin/bash
# list-models.sh - Query API endpoint for available models
# Usage: ./list-models.sh <endpoint_url> <api_key> [auth_type]
#   endpoint_url: API base URL (e.g., https://api.openai.com)
#   api_key: API key for authentication
#   auth_type: "bearer" (default) or "x-api-key"

set -e

if [ -z "$1" ] || [ -z "$2" ]; then
    echo "Usage: $0 <endpoint_url> <api_key> [auth_type]"
    echo ""
    echo "Arguments:"
    echo "  endpoint_url  API base URL (e.g., https://api.openai.com)"
    echo "  api_key       API key for authentication"
    echo "  auth_type     'bearer' (default) or 'x-api-key'"
    echo ""
    echo "Examples:"
    echo "  $0 https://api.openai.com sk-xxx bearer"
    echo "  $0 https://api.litellm.com my-key x-api-key"
    exit 1
fi

ENDPOINT_URL="$1"
API_KEY="$2"
AUTH_TYPE="${3:-bearer}"

# Remove trailing slash from endpoint
ENDPOINT_URL="${ENDPOINT_URL%/}"

# Construct models URL
MODELS_URL="${ENDPOINT_URL}/v1/models"

echo "Querying: $MODELS_URL"
echo "Auth type: $AUTH_TYPE"
echo ""

# Make request based on auth type
if [ "$AUTH_TYPE" = "x-api-key" ]; then
    RESPONSE=$(curl -s "$MODELS_URL" \
        -H "x-api-key: $API_KEY" \
        -H "Content-Type: application/json")
else
    RESPONSE=$(curl -s "$MODELS_URL" \
        -H "Authorization: Bearer $API_KEY" \
        -H "Content-Type: application/json")
fi

# Check if jq is available for pretty printing
if command -v jq &> /dev/null; then
    echo "$RESPONSE" | jq -r '.data[] | [.id, .owned_by // "unknown", (.created // 0 | todate)] | @tsv' | \
    awk 'BEGIN {
        printf "%-50s %-20s %-20s\n", "Model ID", "Owner", "Created";
        printf "%-50s %-20s %-20s\n", "--------", "-----", "-------";
    }
    {
        printf "%-50s %-20s %-20s\n", $1, $2, $3;
    }'
else
    # Fallback: just print raw JSON if jq not available
    echo "$RESPONSE"
    echo ""
    echo "Tip: Install jq for formatted output (brew install jq)"
fi
