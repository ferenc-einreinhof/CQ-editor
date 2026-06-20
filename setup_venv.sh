#!/bin/bash
# One-time setup: create a Python virtual environment in ./.venv and install
# all of CQ-editor's dependencies into it with pip (no conda/mamba needed).
#
# Usage:
#     ./setup_venv.sh          # runtime dependencies only
#     ./setup_venv.sh --dev    # also install the test dependencies
#
# Afterwards, start the app with ./run.sh

set -e

APP_DIR=$(cd "$(dirname "$0")" && pwd)
cd "$APP_DIR"

VENV_DIR="$APP_DIR/.venv"

# Find a Python interpreter on the host. Most systems only ship "python3"
# (there is no bare "python"), so prefer that. Override with e.g.
#     PYTHON=/usr/bin/python3.11 ./setup_venv.sh
PYTHON=${PYTHON:-}
if [ -z "$PYTHON" ]; then
    if command -v python3 >/dev/null 2>&1; then
        PYTHON=python3
    elif command -v python >/dev/null 2>&1; then
        PYTHON=python
    else
        echo "Error: no 'python3' or 'python' interpreter found on PATH." >&2
        echo "Install Python 3.10+ and try again." >&2
        exit 1
    fi
fi

if [ ! -d "$VENV_DIR" ]; then
    echo "Creating virtual environment in $VENV_DIR (using $PYTHON) ..."
    "$PYTHON" -m venv "$VENV_DIR"
fi

# Use the interpreter inside the venv directly. This always exists as
# ".venv/bin/python" even when the host only provides "python3", and avoids
# depending on 'source activate' having run.
VENV_PYTHON="$VENV_DIR/bin/python"

echo "Upgrading pip ..."
"$VENV_PYTHON" -m pip install --upgrade pip

if [ "$1" = "--dev" ]; then
    echo "Installing runtime + development dependencies ..."
    "$VENV_PYTHON" -m pip install -r requirements.txt -r requirements-dev.txt
else
    echo "Installing runtime dependencies ..."
    "$VENV_PYTHON" -m pip install -r requirements.txt
fi

echo
echo "Done. Start CQ-editor with:  ./run.sh"
