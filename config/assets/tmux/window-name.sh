#!/usr/bin/env bash
# Prints "project[branch]" for the given directory.
# Usage: window-name.sh <path>

dir="${1:-$PWD}"
name="$(basename "$dir")"

branch="$(git -C "$dir" symbolic-ref --short HEAD 2>/dev/null \
  || git -C "$dir" rev-parse --short HEAD 2>/dev/null)"

if [ -n "$branch" ]; then
  printf '%s[%s]' "$name" "$branch"
else
  printf '%s' "$name"
fi
