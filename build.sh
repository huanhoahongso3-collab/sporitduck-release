#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DECODED_DIR="$SCRIPT_DIR/SpotiDuck-decoded"
OUTPUT_DIR="$SCRIPT_DIR/output"
KEYSTORE="$OUTPUT_DIR/debug.keystore"

mkdir -p "$OUTPUT_DIR"

echo "[1/4] Downloading apktool..."
APKTOOL="$OUTPUT_DIR/apktool.jar"
if [ ! -f "$APKTOOL" ]; then
  curl -L -o "$APKTOOL" \
    "https://github.com/iBotPeaches/Apktool/releases/download/v2.12.1/apktool_2.12.1.jar"
fi

echo "[2/4] Rebuilding APK..."
java -jar "$APKTOOL" b "$DECODED_DIR" -o "$OUTPUT_DIR/SpotiDuck-module-unsigned.apk"

echo "[3/4] Generating debug keystore..."
if [ ! -f "$KEYSTORE" ]; then
  keytool -genkeypair -v \
    -keystore "$KEYSTORE" \
    -alias androiddebugkey \
    -keyalg RSA -keysize 2048 -validity 10000 \
    -storepass android -keypass android \
    -dname "CN=Android Debug,O=Android,C=US"
fi

echo "[4/4] Signing APK..."
"${ANDROID_HOME:-/usr/local/lib/android/sdk}/build-tools/$(ls "${ANDROID_HOME:-/usr/local/lib/android/sdk}/build-tools/" | sort -V | tail -1)/apksigner" \
  sign \
  --ks "$KEYSTORE" \
  --ks-pass pass:android \
  --key-pass pass:android \
  --ks-key-alias androiddebugkey \
  --out "$OUTPUT_DIR/SpotiDuck-module-signed.apk" \
  "$OUTPUT_DIR/SpotiDuck-module-unsigned.apk"

echo "BUILD SUCCESSFUL -> $OUTPUT_DIR/SpotiDuck-module-signed.apk"
