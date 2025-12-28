#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BACKEND_DIR="$ROOT_DIR/backend"

if [ "${RUN_BACKEND_LEGACY_CHECK:-0}" -eq 1 ]; then
  if ! command -v dotnet >/dev/null 2>&1; then
    echo "dotnet SDK is required to run the backend. Install .NET 6 SDK and retry." >&2
    exit 1
  fi
fi

if ! command -v dotnet >/dev/null 2>&1; then
  set +e
  "$ROOT_DIR/scripts/bootstrap_dotnet.sh"
  SKIP_LEGACY_SETUP=1
  set -e
fi

if ! command -v dotnet >/dev/null 2>&1; then
  if [ "${SKIP_LEGACY_SETUP:-0}" -eq 1 ]; then
    :
  else
  set +e
  echo "Falling back to legacy dotnet setup script." >&2
  "$ROOT_DIR/scripts/setup_dotnet.sh"
  set -e
  fi
fi

export DOTNET_ROOT="${DOTNET_ROOT:-$ROOT_DIR/.dotnet}"
export PATH="$DOTNET_ROOT:$PATH"

if ! command -v dotnet >/dev/null 2>&1; then
  echo "dotnet SDK not available; starting mock backend instead." >&2
  node "$ROOT_DIR/scripts/mock_backend.js"
  exit 0
fi

cd "$BACKEND_DIR"
if [ "${RUN_BACKEND_LEGACY_COMMAND:-0}" -eq 1 ]; then
  DOTNET_ENVIRONMENT="Development" \
  ASPNETCORE_URLS="http://localhost:5005" \
    dotnet run
fi
DOTNET_ENVIRONMENT="Development" \
ASPNETCORE_URLS="http://localhost:5000;https://localhost:5001" \
  dotnet run
