#!/usr/bin/env bash
# SDM proxy injection hook — adds -x proxy flag for curl/wget to *.sdm.network
# For non-SDM targets: adds --noproxy '*' to ensure direct connection

if ! command -v jq &>/dev/null; then
  exit 0
fi

INPUT=$(cat)
CMD=$(echo "$INPUT" | jq -r '.tool_input.command // empty')

if [ -z "$CMD" ]; then
  exit 0
fi

SDM_PROXY="http://localhost:65230"
SDM_PATTERN="kaltura-ovp.eu.sdm.network"

FIRST_WORD=$(echo "$CMD" | awk '{print $1}')
case "$FIRST_WORD" in
  curl|wget) ;;
  *) exit 0 ;;
esac

if echo "$CMD" | grep -q "$SDM_PATTERN"; then
  # Target is SDM — inject proxy
  if [ "$FIRST_WORD" = "curl" ]; then
    REWRITTEN=$(echo "$CMD" | sed "s|^curl |curl -x $SDM_PROXY |")
  else
    REWRITTEN=$(echo "$CMD" | sed "s|^wget |wget -e http_proxy=$SDM_PROXY -e https_proxy=$SDM_PROXY |")
  fi
else
  # Target is external — ensure no proxy
  if [ "$FIRST_WORD" = "curl" ]; then
    REWRITTEN=$(echo "$CMD" | sed "s|^curl |curl --noproxy '*' |")
  else
    REWRITTEN=$(echo "$CMD" | sed "s|^wget |wget --no-proxy |")
  fi
fi

if [ "$CMD" = "$REWRITTEN" ]; then
  exit 0
fi

ORIGINAL_INPUT=$(echo "$INPUT" | jq -c '.tool_input')
UPDATED_INPUT=$(echo "$ORIGINAL_INPUT" | jq --arg cmd "$REWRITTEN" '.command = $cmd')

jq -n \
  --argjson updated "$UPDATED_INPUT" \
  '{
    "hookSpecificOutput": {
      "hookEventName": "PreToolUse",
      "permissionDecision": "allow",
      "permissionDecisionReason": "SDM proxy injection",
      "updatedInput": $updated
    }
  }'
