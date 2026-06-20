#!/bin/bash
# Launch CQ-editor from the local virtual environment created by ./setup_venv.sh

set -e

APP_DIR=$(cd "$(dirname "$0")" && pwd)
cd "$APP_DIR"

VENV_DIR="$APP_DIR/.venv"

# CQ-editor's 3D viewer uses OpenCASCADE's X11 backend, which needs a real X11
# window. On a Wayland session Qt would otherwise hand it a Wayland surface,
# which crashes the app at startup with "X Error: BadWindow". Forcing the X11
# (xcb) backend routes the window through XWayland and fixes this. Native X11
# sessions already use xcb, so this is harmless there. Override by exporting
# QT_QPA_PLATFORM yourself before running.
export QT_QPA_PLATFORM="${QT_QPA_PLATFORM:-xcb}"

if [ ! -d "$VENV_DIR" ]; then
    echo "Virtual environment not found at $VENV_DIR"
    echo "Run ./setup_venv.sh first to create it and install the dependencies."
    exit 1
fi

# Activate the venv (so child processes inherit it) and launch using the venv's
# own interpreter directly. ".venv/bin/python" always exists even when the host
# only provides "python3".
# shellcheck disable=SC1091
source "$VENV_DIR/bin/activate"
exec "$VENV_DIR/bin/python" run.py
