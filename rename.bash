#!/bin/bash
#
# File renaming
# arg1 - directory

for f in *\ *; do mv "$f" "${f// /_}"; done
