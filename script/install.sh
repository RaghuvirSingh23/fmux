#!/usr/bin/env bash
set -euo pipefail

APP_NAME="fmux"
APP_DISPLAY_NAME="Fmux"
LEGACY_APP_NAME="floaterm"
BUILD_TARGET_NAME="Fmux"
BUNDLE_ID="com.raghusi.fmux"
MIN_SYSTEM_VERSION="14.0"

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BUILD_OUTPUT_DIR="$ROOT_DIR/dist/install"
APP_BUNDLE="$BUILD_OUTPUT_DIR/$APP_NAME.app"
APP_CONTENTS="$APP_BUNDLE/Contents"
APP_MACOS="$APP_CONTENTS/MacOS"
APP_RESOURCES="$APP_CONTENTS/Resources"
APP_BINARY="$APP_MACOS/$APP_NAME"
INFO_PLIST="$APP_CONTENTS/Info.plist"
APP_ICON_SOURCE="$ROOT_DIR/Assets/AppIcon.png"
APP_ICON_PATH="$APP_RESOURCES/AppIcon.icns"
TARGET_APP="/Applications/$APP_NAME.app"
LEGACY_TARGET_APP="/Applications/$LEGACY_APP_NAME.app"

if ! command -v swift >/dev/null 2>&1; then
  echo "error: Swift was not found. Install Xcode or the Xcode Command Line Tools first." >&2
  echo "hint: xcode-select --install" >&2
  exit 1
fi

generate_app_icon() {
  if [[ ! -f "$APP_ICON_SOURCE" ]]; then
    echo "warning: missing app icon source at $APP_ICON_SOURCE" >&2
    return
  fi

  local icon_work_dir
  local iconset_dir

  icon_work_dir="$(mktemp -d "${TMPDIR:-/tmp}/fmux-icon.XXXXXX")"
  iconset_dir="$icon_work_dir/AppIcon.iconset"
  mkdir -p "$iconset_dir"

  resize_icon() {
    local size="$1"
    local filename="$2"
    sips -z "$size" "$size" "$APP_ICON_SOURCE" --out "$iconset_dir/$filename" >/dev/null
  }

  resize_icon 16 "icon_16x16.png"
  resize_icon 32 "icon_16x16@2x.png"
  resize_icon 32 "icon_32x32.png"
  resize_icon 64 "icon_32x32@2x.png"
  resize_icon 128 "icon_128x128.png"
  resize_icon 256 "icon_128x128@2x.png"
  resize_icon 256 "icon_256x256.png"
  resize_icon 512 "icon_256x256@2x.png"
  resize_icon 512 "icon_512x512.png"
  resize_icon 1024 "icon_512x512@2x.png"

  iconutil -c icns "$iconset_dir" -o "$APP_ICON_PATH"
  rm -rf "$icon_work_dir"
}

write_info_plist() {
  cat >"$INFO_PLIST" <<PLIST
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>CFBundleExecutable</key>
  <string>$APP_NAME</string>
  <key>CFBundleIdentifier</key>
  <string>$BUNDLE_ID</string>
  <key>CFBundleName</key>
  <string>$APP_DISPLAY_NAME</string>
  <key>CFBundleDisplayName</key>
  <string>$APP_DISPLAY_NAME</string>
  <key>CFBundleIconFile</key>
  <string>AppIcon</string>
  <key>CFBundlePackageType</key>
  <string>APPL</string>
  <key>LSMinimumSystemVersion</key>
  <string>$MIN_SYSTEM_VERSION</string>
  <key>NSHighResolutionCapable</key>
  <true/>
  <key>NSPrincipalClass</key>
  <string>NSApplication</string>
</dict>
</plist>
PLIST
}

pkill -x "$APP_NAME" >/dev/null 2>&1 || true
pkill -x "$LEGACY_APP_NAME" >/dev/null 2>&1 || true

rm -rf "$BUILD_OUTPUT_DIR"
mkdir -p "$APP_MACOS" "$APP_RESOURCES"

swift build -c release
BUILD_DIR="$(swift build -c release --show-bin-path)"
BUILD_BINARY="$BUILD_DIR/$BUILD_TARGET_NAME"

cp "$BUILD_BINARY" "$APP_BINARY"
chmod +x "$APP_BINARY"

find "$BUILD_DIR" -maxdepth 1 -name '*.bundle' -print0 | while IFS= read -r -d '' bundle; do
  cp -R "$bundle" "$APP_RESOURCES/"
done

generate_app_icon
write_info_plist
codesign --force --deep --sign - "$APP_BUNDLE" >/dev/null

rm -rf "$TARGET_APP"
rm -rf "$LEGACY_TARGET_APP"
ditto "$APP_BUNDLE" "$TARGET_APP"

printf 'Installed %s\n' "$TARGET_APP"
/usr/bin/open "$TARGET_APP"
