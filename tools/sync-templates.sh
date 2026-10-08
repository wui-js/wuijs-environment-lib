#!/usr/bin/env bash
#
# Copies the current WUIEnvironment sources (Java, Swift, JavaScript and demo page)
# from src/ into the Android and iOS templates under templates/.
#
# Usage (from the repository root or from tools/):
#   tools/sync-templates.sh

set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SRC="$ROOT/src/wui-js/environment"
ANDROID="$ROOT/templates/app.myapp.android"
IOS="$ROOT/templates/app.myapp.ios"
ANDROID_PACKAGE="app.myapp"

WEB_FILE="$(ls "$SRC/web" | grep -E '^wui-environment-[0-9]+\.[0-9]+\.js$' | sort -V | tail -n 1)"
if [ -z "$WEB_FILE" ]; then
	echo "No wui-environment-<version>.js found in $SRC/web" >&2
	exit 1
fi

sync_assets() {
	local assets="$1/libraries/wui-js/environment"
	mkdir -p "$assets/web" "$assets/demo"
	rm -f "$assets/web"/wui-environment-*.js
	cp "$SRC/web/$WEB_FILE" "$assets/web/"
	cp "$SRC/demo/index.html" "$SRC/demo/download.pdf" "$assets/demo/"
}

# Android
sed "s/^package YOUR\.PACKAGE\.NAME;.*$/package $ANDROID_PACKAGE;/" "$SRC/android/WUIEnvironment.java" \
	> "$ANDROID/app/src/main/java/${ANDROID_PACKAGE//.//}/WUIEnvironment.java"
sync_assets "$ANDROID/app/src/main/assets"

# iOS
cp "$SRC/ios/WUIEnvironment.swift" "$IOS/MyApp/WUIEnvironment.swift"
sync_assets "$IOS/MyApp/assets"

echo "Templates synchronized with $WEB_FILE"
