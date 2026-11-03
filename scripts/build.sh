#!/usr/bin/env bash
set -euo pipefail

TARGET="${1:-TapTap}"
cd "$TARGET"
./gradlew :app:assembleRelease
echo "APK: app/build/outputs/apk/release/app-release-unsigned.apk"
echo "Sign it with your own keystore before installing."
