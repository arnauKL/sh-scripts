#!/bin/sh

# Minimal, fast app launcher using fzf for Cagebreak
cmd=$(echo "$PATH" | tr ':' '\n' | xargs -I {} find {} -maxdepth 1 -executable -type f 2>/dev/null | sort -u | fzf --prompt="Run: ")
if [ -n "$cmd" ]; then
    setsid "$cmd" >/dev/null 2>&1 &
fi
