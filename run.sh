#!/bin/bash

APP_DIR=$(dirname $0)
cd $APP_DIR

source $HOME/miniforge/bin/activate cqgui && python run.py
