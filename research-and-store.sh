#!/usr/bin/env bash
# research-and-store.sh
# Wrapper that invokes the Claude Code /research-and-store custom command
# from the terminal, targeting the current project directory.
#
# Usage:
#   research-and-store "Research topic or question" "TargetFile.md"
#   research-and-store "Electron IPC security best practices" "Security_Rules.md"

set -euo pipefail

TOPIC="${1:-}"
TARGET_FILE="${2:-Research_Notes.md}"

if [[ -z "$TOPIC" ]]; then
  echo "Usage: research-and-store \"<Research Topic>\" \"<TargetFile.md>\""
  echo ""
  echo "Examples:"
  echo "  research-and-store \"Electron IPC security best practices\" \"Security_Rules.md\""
  echo "  research-and-store \"WebAudio API oscillator patterns\" \"WebAudio_API_Specs.md\""
  echo ""
  echo "Inside Claude Code, you can also run:"
  echo "  /research-and-store \"<topic>\" \"<file.md>\""
  exit 1
fi

# Verify we're in a project with AI_CONTEXT_SPEC
if [[ ! -L "./AI_CONTEXT_SPEC" ]]; then
  echo "Error: No AI_CONTEXT_SPEC symlink found in $(pwd)"
  echo "       Make sure you're inside a project directory that has been set up."
  exit 1
fi

PROJECT_DIR="$(pwd)"
TARGET_PATH="$(readlink -f ./AI_CONTEXT_SPEC)/$TARGET_FILE"

echo "research-and-store"
echo "══════════════════════════════════════"
echo "Topic:      $TOPIC"
echo "File:       $TARGET_PATH"
echo "Project:    $PROJECT_DIR"
echo ""
echo "Launching Claude to research and write..."
echo ""

# Invoke Claude Code non-interactively with the custom command
claude --print "/research-and-store \"$TOPIC\" \"$TARGET_FILE\""
