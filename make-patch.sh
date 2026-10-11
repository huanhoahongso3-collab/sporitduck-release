#!/usr/bin/env bash
# Generates a unified diff of SpotiDuck-decoded/ against a fresh decode of the
# unmodified upstream SpotiDuck APK, so the exact changes made to the stock app are
# reviewable as a single patch file instead of having to diff decoded trees by hand.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OUTPUT_DIR="$SCRIPT_DIR/output"
PATCH_DIR="$SCRIPT_DIR/patches"
mkdir -p "$OUTPUT_DIR" "$PATCH_DIR"

APKTOOL="$OUTPUT_DIR/apktool.jar"
if [ ! -f "$APKTOOL" ]; then
  echo "[1/4] Downloading apktool..."
  curl -fL -o "$APKTOOL" \
    "https://github.com/iBotPeaches/Apktool/releases/download/v2.12.1/apktool_2.12.1.jar"
fi

echo "[2/4] Downloading unmodified upstream SpotiDuck APK..."
mkdir -p "$OUTPUT_DIR/upstream-src"
gh release download latest-beta \
  --repo 23fpsz/SpotiDuck-Releases \
  --pattern '*.apk' \
  --dir "$OUTPUT_DIR/upstream-src" \
  --clobber
UPSTREAM_APK="$(ls "$OUTPUT_DIR"/upstream-src/*.apk | head -1)"

echo "[3/4] Decoding upstream APK for comparison..."
rm -rf "$OUTPUT_DIR/upstream-decoded"
java -jar "$APKTOOL" d "$UPSTREAM_APK" -o "$OUTPUT_DIR/upstream-decoded" --force

echo "[4/4] Diffing our changes against upstream..."
# A whole-tree diff is dominated by noise: upstream's "latest-beta" tag can move to a
# different obfuscated base than whatever SpotiDuck-decoded/ was originally forked from,
# so most of the base app's files "differ" for reasons that have nothing to do with our
# actual changes. Two focused patches instead: our own module package (where literally
# all of our code lives) in full, and just the manifest (the one shared file we edit).
# Our whole package is new code upstream never had (not a modification of an existing
# one), so the upstream side needs to exist as an empty dir for diff -ruN to treat every
# file as added rather than erroring out.
mkdir -p "$OUTPUT_DIR/upstream-decoded/smali/dhp/vkn/tpl/sporitduck"
MODULE_PATCH="$PATCH_DIR/spotiduck-module.patch"
diff -ruN \
  "$OUTPUT_DIR/upstream-decoded/smali/dhp/vkn/tpl/sporitduck" \
  "$SCRIPT_DIR/SpotiDuck-decoded/smali/dhp/vkn/tpl/sporitduck" \
  > "$MODULE_PATCH" || true

MANIFEST_PATCH="$PATCH_DIR/spotiduck-manifest.patch"
diff -u \
  "$OUTPUT_DIR/upstream-decoded/AndroidManifest.xml" \
  "$SCRIPT_DIR/SpotiDuck-decoded/AndroidManifest.xml" \
  > "$MANIFEST_PATCH" || true

echo "PATCH GENERATED -> $MODULE_PATCH ($(wc -l < "$MODULE_PATCH") lines)"
echo "PATCH GENERATED -> $MANIFEST_PATCH ($(wc -l < "$MANIFEST_PATCH") lines)"
echo "Upstream APK used: $(basename "$UPSTREAM_APK")"
echo ""
echo "NOTE: this only compares against whatever APK is currently tagged latest-beta on"
echo "23fpsz/SpotiDuck-Releases, which may not be the exact version SpotiDuck-decoded/ was"
echo "originally forked from -- base-app files outside our own package can still show as"
echo "changed if upstream has moved on since. Our own module package's patch above is the"
echo "one that's always meaningful, since nothing but us ever touches that directory."
