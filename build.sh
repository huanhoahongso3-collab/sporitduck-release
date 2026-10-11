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

UBER_SIGNER="$OUTPUT_DIR/uber-apk-signer.jar"
if [ ! -f "$UBER_SIGNER" ]; then
  echo "[3/4] Downloading uber-apk-signer..."
  curl -fL -o "$UBER_SIGNER" \
    "https://github.com/patrickfav/uber-apk-signer/releases/download/v1.3.0/uber-apk-signer-1.3.0.jar"
else
  echo "[3/4] uber-apk-signer already present, skipping download."
fi

echo "[3b/4] Generating debug keystore..."
if [ ! -f "$KEYSTORE" ]; then
  keytool -genkeypair -v \
    -keystore "$KEYSTORE" \
    -alias androiddebugkey \
    -keyalg RSA -keysize 2048 -validity 10000 \
    -storepass android -keypass android \
    -dname "CN=Android Debug,O=Android,C=US"
fi

echo "[4/4] Signing APK (v1+v2+v3)..."
java -jar "$UBER_SIGNER" \
  --apks "$OUTPUT_DIR/SpotiDuck-module-unsigned.apk" \
  --ks "$KEYSTORE" \
  --ksAlias androiddebugkey \
  --ksPass android \
  --ksKeyPass android \
  --out "$OUTPUT_DIR/"
mv "$OUTPUT_DIR/SpotiDuck-module-unsigned-aligned-signed.apk" "$OUTPUT_DIR/SpotiDuck-module-signed.apk" 2>/dev/null || \
  mv "$OUTPUT_DIR/SpotiDuck-module-aligned-signed.apk" "$OUTPUT_DIR/SpotiDuck-module-signed.apk" 2>/dev/null || true

echo "BUILD SUCCESSFUL -> $OUTPUT_DIR/SpotiDuck-module-signed.apk"
