#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TARGET="${1:-TapTap}"

if [ ! -d "$TARGET" ]; then
  echo "Usage: $0 /path/to/TapTap"
  echo "Clone first: git clone --depth 1 --branch 1.6.2 https://github.com/KieronQuinn/TapTap.git"
  exit 1
fi

for patch in "$ROOT"/patches/*.patch; do
  echo "Applying $(basename "$patch")"
  if command -v git >/dev/null 2>&1; then
    git -C "$TARGET" apply "$patch"
  else
    patch -p1 -d "$TARGET" < "$patch"
  fi
done

echo "Done. Build with: cd $TARGET && ./gradlew :app:assembleRelease"
