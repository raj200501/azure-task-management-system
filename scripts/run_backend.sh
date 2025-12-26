#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BACKEND_DIR="$ROOT_DIR/backend"

if ! command -v dotnet >/dev/null 2>&1; then
  echo "dotnet SDK is required to run the backend. Install .NET 6 SDK and retry." >&2
  exit 1
fi

cd "$BACKEND_DIR"
DOTNET_ENVIRONMENT="Development" \
ASPNETCORE_URLS="http://localhost:5005" \
  dotnet run
