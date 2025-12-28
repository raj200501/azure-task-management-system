#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DOTNET_DIR="${DOTNET_ROOT:-$ROOT_DIR/.dotnet}"

if command -v dotnet >/dev/null 2>&1; then
  echo "dotnet already available: $(dotnet --version)"
  exit 0
fi

mkdir -p "$DOTNET_DIR"

if [ ! -f "$DOTNET_DIR/dotnet" ]; then
  echo "Downloading .NET SDK 6.x to $DOTNET_DIR..."
  DOWNLOAD_URLS=(
    "https://dot.net/v1/dotnet-install.sh"
    "https://aka.ms/dotnet-install.sh"
  )

  DOWNLOAD_SUCCESS=0
  for url in "${DOWNLOAD_URLS[@]}"; do
    if curl -fsSL -A "azure-task-management-system" "$url" -o "$DOTNET_DIR/dotnet-install.sh"; then
      DOWNLOAD_SUCCESS=1
      break
    fi
  done

  if [ "$DOWNLOAD_SUCCESS" -ne 1 ]; then
    TARBALL_URL="https://dotnetcli.azureedge.net/dotnet/Sdk/6.0.425/dotnet-sdk-6.0.425-linux-x64.tar.gz"
    echo "Falling back to direct SDK download from $TARBALL_URL"
    if curl -fsSL -A "azure-task-management-system" "$TARBALL_URL" -o "$DOTNET_DIR/dotnet-sdk.tar.gz"; then
      tar -xzf "$DOTNET_DIR/dotnet-sdk.tar.gz" -C "$DOTNET_DIR"
      rm -f "$DOTNET_DIR/dotnet-sdk.tar.gz"
      DOWNLOAD_SUCCESS=1
    fi
  fi

  if [ "$DOWNLOAD_SUCCESS" -ne 1 ]; then
    echo "Failed to download dotnet-install.sh" >&2
    exit 1
  fi

  if [ -f "$DOTNET_DIR/dotnet-install.sh" ]; then
    bash "$DOTNET_DIR/dotnet-install.sh" --version 6.0.425 --install-dir "$DOTNET_DIR" --no-path
  fi
fi

export DOTNET_ROOT="$DOTNET_DIR"
export PATH="$DOTNET_DIR:$PATH"

echo "dotnet installed: $(dotnet --version)"
