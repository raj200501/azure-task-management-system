#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
FRONTEND_DIR="$ROOT_DIR/frontend"

if ! command -v npm >/dev/null 2>&1; then
  echo "npm is required to run the frontend. Install Node.js and retry." >&2
  exit 1
fi

cd "$FRONTEND_DIR"
if [ ! -d node_modules ]; then
  npm install
fi

npm start
