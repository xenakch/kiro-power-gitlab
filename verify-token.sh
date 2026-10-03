#!/usr/bin/env bash
# Verify a GitLab personal access token is present and valid (read-only).
# Usage:
#   export GITLAB_PERSONAL_ACCESS_TOKEN=glpat-xxxxx
#   ./verify-token.sh
# or:
#   GITLAB_PERSONAL_ACCESS_TOKEN=glpat-xxxxx ./verify-token.sh
set -euo pipefail

API="${GITLAB_API_URL:-https://gitlab.com/api/v4}"
TOKEN="${GITLAB_PERSONAL_ACCESS_TOKEN:-}"

if [ -z "$TOKEN" ]; then
  echo "FAIL: GITLAB_PERSONAL_ACCESS_TOKEN is not set in the environment."
  echo "Create one (scope: read_api) at:"
  echo "  https://gitlab.com/-/user_settings/personal_access_tokens"
  exit 1
fi

echo "Checking token against ${API}/user ..."
code=$(curl -sS -m 15 -o /tmp/gl_verify.json -w "%{http_code}" \
  -H "PRIVATE-TOKEN: ${TOKEN}" "${API}/user")

if [ "$code" = "200" ]; then
  user=$(grep -o '"username":"[^"]*"' /tmp/gl_verify.json | head -1 | cut -d'"' -f4)
  echo "OK: token is valid. Authenticated as: ${user:-unknown}"
  # Report token scopes if available
  echo "Checking token scopes ..."
  scode=$(curl -sS -m 15 -o /tmp/gl_scopes.json -w "%{http_code}" \
    -H "PRIVATE-TOKEN: ${TOKEN}" "${API}/personal_access_tokens/self" || true)
  if [ "$scode" = "200" ]; then
    scopes=$(grep -o '"scopes":\[[^]]*\]' /tmp/gl_scopes.json)
    echo "Token ${scopes}"
    case "$scopes" in
      *'"api"'*) echo "WARNING: token has full 'api' scope. 'read_api' is sufficient for this read-only Power." ;;
    esac
  fi
  rm -f /tmp/gl_verify.json /tmp/gl_scopes.json
  exit 0
elif [ "$code" = "401" ]; then
  echo "FAIL: HTTP 401 Unauthorized — token is invalid, expired, or revoked."
  rm -f /tmp/gl_verify.json
  exit 1
else
  echo "FAIL: unexpected HTTP ${code}."
  cat /tmp/gl_verify.json 2>/dev/null || true
  rm -f /tmp/gl_verify.json
  exit 1
fi
