# Fmux

Fmux is a native macOS terminal canvas. It lets you place multiple terminal sessions in one zoomable workspace, group related terminals, and broadcast input to selected terminals.

## Quick Start

### Download the app

For the least setup, download the latest `.dmg` from [GitHub Releases](https://github.com/RaghuvirSingh23/fmux/releases/latest), open it, and drag `fmux.app` into Applications.

Current release artifacts are ad-hoc signed but not notarized, so macOS may show a Gatekeeper warning on first open.

### Clone and run

Requirements:

- macOS 14 or newer
- Xcode 16 or a Swift 6 toolchain

```bash
git clone https://github.com/RaghuvirSingh23/fmux.git
cd fmux
make run
```

`make run` builds a local app bundle at `dist/fmux.app` and opens it.

### Install from a clone

```bash
make install
```

This builds a release app, installs it to `/Applications/fmux.app`, and opens it.

To install into your user-local Applications folder instead:

```bash
INSTALL_DIR=~/Applications make install
```

## Development

```bash
make test       # run the test suite
make release    # build zip, dmg, and checksum artifacts under dist/release
make clean      # remove local build artifacts
```

The release workflow is documented in [docs/releasing.md](docs/releasing.md).

## Distribution Notes

The easiest path for most users is a signed and notarized GitHub Release `.dmg`. After that, a Homebrew cask can reduce installation to:

```bash
brew install --cask fmux
```

Until Developer ID signing and notarization are configured, clone-and-build avoids Gatekeeper download warnings because users build the app locally.
