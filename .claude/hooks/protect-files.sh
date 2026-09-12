#!/bin/bash
# PreToolUse hook — denies Write/Edit/NotebookEdit calls that target protected files.
#
# Emits the documented PreToolUse decision shape:
#   {"hookSpecificOutput": {"hookEventName": "PreToolUse",
#                           "permissionDecision": "deny",
#                           "permissionDecisionReason": "..."}}
#
# Always exits 0 — the decision travels in the JSON payload, not the exit code.

set -uo pipefail

INPUT=$(cat)

# Read the target path for each tool that writes to disk. NotebookEdit uses
# notebook_path rather than file_path.
FILE_PATH=$(printf '%s' "$INPUT" | jq -r '.tool_input.file_path // .tool_input.notebook_path // empty' 2>/dev/null)

[ -z "$FILE_PATH" ] && exit 0

BASENAME=$(basename "$FILE_PATH")

deny() {
  jq -n --arg reason "$1" '{
    hookSpecificOutput: {
      hookEventName: "PreToolUse",
      permissionDecision: "deny",
      permissionDecisionReason: $reason
    }
  }'
  exit 0
}

# Secrets and credentials — never writable by Claude.
case "$BASENAME" in
  .env|.env.*|*.pem|*.key|*.p12|*.pfx|id_rsa|id_ed25519)
    deny "Blocked: '$FILE_PATH' holds credentials. Put values in .env (untracked) yourself, and reference them via import.meta.env in code."
    ;;
esac

# Lockfiles — regenerate through the package manager, never by hand.
case "$BASENAME" in
  package-lock.json|yarn.lock|pnpm-lock.yaml)
    deny "Blocked: '$FILE_PATH' is a lockfile. Run the matching npm/yarn/pnpm command so the lockfile is regenerated consistently."
    ;;
esac

# Git internals.
case "$FILE_PATH" in
  */.git/*|.git/*)
    deny "Blocked: '$FILE_PATH' is inside .git/. Use git commands instead of editing repository internals."
    ;;
esac

exit 0
