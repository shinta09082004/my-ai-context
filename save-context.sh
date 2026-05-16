#!/usr/bin/env bash
# save-context.sh
# Usage:
#   save-context.sh [--global] <filename.md> "<content to append>"
#
# --global  → writes to /workspaces/my-ai-context/00_Global/
# (default) → writes to the project folder linked by ./AI_CONTEXT_SPEC

set -euo pipefail

CONTEXT_BASE="/workspaces/my-ai-context"
ORIGINAL_DIR="$(pwd)"
USE_GLOBAL=false

# Parse optional --global flag
if [[ "${1:-}" == "--global" ]]; then
  USE_GLOBAL=true
  shift
fi

FILENAME="${1:-}"
CONTENT="${2:-}"

if [[ -z "$FILENAME" || -z "$CONTENT" ]]; then
  echo "Usage: save-context [--global] <filename.md> \"<content>\""
  echo ""
  echo "  --global    Write to 00_Global/ instead of the project folder"
  echo ""
  echo "Examples:"
  echo "  save-context Rules.md \"Added Electron IPC routing rule\""
  echo "  save-context --global Philosophy.md \"Prefer simplicity over abstraction\""
  exit 1
fi

# Determine target directory
if [[ "$USE_GLOBAL" == true ]]; then
  TARGET_DIR="$CONTEXT_BASE/00_Global"
else
  # Resolve AI_CONTEXT_SPEC symlink from original directory
  SYMLINK="$ORIGINAL_DIR/AI_CONTEXT_SPEC"
  if [[ -L "$SYMLINK" ]]; then
    TARGET_DIR="$(readlink -f "$SYMLINK")"
  else
    echo "Error: No AI_CONTEXT_SPEC symlink found in $ORIGINAL_DIR"
    echo "       Run with --global to target 00_Global/ instead."
    exit 1
  fi
fi

TARGET_FILE="$TARGET_DIR/$FILENAME"

# Create file if it doesn't exist
if [[ ! -f "$TARGET_FILE" ]]; then
  echo "# $(basename "$FILENAME" .md)" > "$TARGET_FILE"
  echo "Created: $TARGET_FILE"
fi

# Append content with timestamp
{
  echo ""
  echo "<!-- updated: $(date '+%Y-%m-%d %H:%M') -->"
  echo "$CONTENT"
} >> "$TARGET_FILE"

echo "Updated: $TARGET_FILE"

# Git commit and push
cd "$CONTEXT_BASE"
git add .
git commit -m "Update context: $FILENAME"
git push origin main

echo ""
echo "Pushed to origin/main."

# Return to original directory
cd "$ORIGINAL_DIR"
