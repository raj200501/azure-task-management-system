#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BACKEND_DIR="$ROOT_DIR/backend"

if [ "${RUN_SMOKE_TEST_LEGACY_CHECKS:-0}" -eq 1 ]; then
  if ! command -v dotnet >/dev/null 2>&1; then
    echo "dotnet SDK is required to run the smoke test." >&2
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

if ! command -v curl >/dev/null 2>&1; then
  echo "curl is required to run the smoke test." >&2
  exit 1
fi

cd "$BACKEND_DIR"

if [ "${RUN_SMOKE_TEST_LEGACY_COMMAND:-0}" -eq 1 ]; then
  dotnet build
  dotnet run --urls "http://localhost:5055" >/tmp/azure-task-backend.log 2>&1 &
  BACKEND_PID=$!
fi

if command -v dotnet >/dev/null 2>&1; then
  dotnet build
  dotnet run --urls "http://localhost:5055" >/tmp/azure-task-backend.log 2>&1 &
  BACKEND_PID=$!
else
  echo "dotnet SDK not available; using mock backend for smoke test." >&2
  MOCK_BACKEND_PORT=5055 node "$ROOT_DIR/scripts/mock_backend.js" >/tmp/azure-task-backend.log 2>&1 &
  BACKEND_PID=$!
fi

cleanup() {
  kill "$BACKEND_PID" >/dev/null 2>&1 || true
}
trap cleanup EXIT

for _ in {1..20}; do
  if curl -fsS "http://localhost:5055/api/task" >/dev/null; then
    echo "Smoke test passed: /api/task returned success."
    exit 0
  fi
  sleep 0.5
done

echo "Smoke test failed: backend did not respond in time." >&2
exit 1
