#!/bin/bash
# Launch CQ-editor from the local virtual environment created by ./setup_venv.sh

set -e

APP_DIR=$(cd "$(dirname "$0")" && pwd)
cd "$APP_DIR"

VENV_DIR="$APP_DIR/.venv"

# Note: the Wayland workaround (forcing QT_QPA_PLATFORM=xcb so OpenCASCADE's X11
# viewer gets a real window) lives in run.py, so it applies no matter how the
# app is launched.

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
