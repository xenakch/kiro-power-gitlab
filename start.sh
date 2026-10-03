#!/usr/bin/env bash
# Launch Kiro with the GitLab token loaded from this repo's .env (Option 3).
#
# This script contains NO secret. It sources the git-ignored .env so the
# GITLAB_PERSONAL_ACCESS_TOKEN is exported into the environment only for the
# Kiro process it launches. The token never leaves .env.
#
# Usage:
#   ./start.sh                 # starts `kiro-cli chat`
#   ./start.sh <args...>       # passes extra args through to kiro-cli
set -euo pipefail

# Resolve this script's directory so it works from any working directory.
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Env file location. Set GITLAB_ENV_FILE to keep the token outside the repo;
# otherwise fall back to the repo-local .env (default behavior).
ENV_FILE="${GITLAB_ENV_FILE:-${SCRIPT_DIR}/.env}"

if [ ! -f "$ENV_FILE" ]; then
  echo "ERROR: $ENV_FILE not found." >&2
  if [ -n "${GITLAB_ENV_FILE:-}" ]; then
    echo "GITLAB_ENV_FILE points to a file that does not exist." >&2
  else
    echo "Copy .env.example to .env and set GITLAB_PERSONAL_ACCESS_TOKEN," >&2
    echo "or set GITLAB_ENV_FILE to an .env outside the repo." >&2
  fi
  exit 1
fi

# Load and export variables from .env for child processes.
set -a
# shellcheck disable=SC1090
. "$ENV_FILE"
set +a

if [ -z "${GITLAB_PERSONAL_ACCESS_TOKEN:-}" ]; then
  echo "ERROR: GITLAB_PERSONAL_ACCESS_TOKEN is empty in $ENV_FILE." >&2
  exit 1
fi

# Launch Kiro. Default to `chat` when no args are given.
if [ "$#" -eq 0 ]; then
  exec kiro-cli chat
else
  exec kiro-cli "$@"
fi
