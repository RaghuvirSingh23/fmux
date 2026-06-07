# Fmux

Fmux is a native macOS terminal canvas. It lets you place multiple terminal sessions in one zoomable workspace, group related terminals, and broadcast input to selected terminals.

## Use It

Requirements:

- macOS 14 or newer
- Xcode 16 or a Swift 6 toolchain

```bash
git clone https://github.com/RaghuvirSingh23/fmux.git
cd fmux
make run
```

`make run` builds a local app bundle at `dist/fmux.app` and opens it.

To install it into Applications:

```bash
make install
```

This builds the app, installs it to `/Applications/fmux.app`, and opens it.
