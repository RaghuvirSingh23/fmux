#!/usr/bin/env bash
set -euo pipefail

APP_NAME="fmux"
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BUILD_OUTPUT_DIR="$ROOT_DIR/dist/install"
INSTALL_DIR="${INSTALL_DIR:-/Applications}"
OPEN_AFTER_INSTALL=1

usage() {
  cat <<USAGE
Usage: bash ./script/install.sh [options]

Build and install fmux.app from this checkout.

Options:
  --dir PATH   Install into PATH instead of /Applications
  --no-open    Do not open the app after installing
  -h, --help   Show this help
USAGE
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --dir)
      shift
      if [[ $# -eq 0 ]]; then
        echo "error: --dir requires a path" >&2
        exit 2
      fi
      INSTALL_DIR="$1"
      ;;
    --no-open)
      OPEN_AFTER_INSTALL=0
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "error: unknown option: $1" >&2
      usage >&2
      exit 2
      ;;
  esac
  shift
done

if ! command -v swift >/dev/null 2>&1; then
  echo "error: Swift was not found. Install Xcode or the Xcode Command Line Tools first." >&2
  echo "hint: xcode-select --install" >&2
  exit 1
fi

DIST_DIR="$BUILD_OUTPUT_DIR" \
RELEASE_VERSION="${RELEASE_VERSION:-local}" \
RELEASE_BUILD_NUMBER="${RELEASE_BUILD_NUMBER:-0}" \
  "$ROOT_DIR/script/build_release.sh"

SOURCE_APP="$BUILD_OUTPUT_DIR/$APP_NAME.app"
TARGET_APP="$INSTALL_DIR/$APP_NAME.app"

if [[ ! -d "$SOURCE_APP" ]]; then
  echo "error: expected app bundle was not created at $SOURCE_APP" >&2
  exit 1
fi

mkdir -p "$INSTALL_DIR"
rm -rf "$TARGET_APP"
ditto "$SOURCE_APP" "$TARGET_APP"

printf 'Installed %s\n' "$TARGET_APP"

if [[ "$OPEN_AFTER_INSTALL" -eq 1 ]]; then
  /usr/bin/open "$TARGET_APP"
fi
