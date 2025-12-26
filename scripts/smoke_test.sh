#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BACKEND_DIR="$ROOT_DIR/backend"

if ! command -v dotnet >/dev/null 2>&1; then
  echo "dotnet SDK is required to run the smoke test." >&2
  exit 1
fi

if ! command -v curl >/dev/null 2>&1; then
  echo "curl is required to run the smoke test." >&2
  exit 1
fi

cd "$BACKEND_DIR"

dotnet build

dotnet run --urls "http://localhost:5055" >/tmp/azure-task-backend.log 2>&1 &
BACKEND_PID=$!

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
