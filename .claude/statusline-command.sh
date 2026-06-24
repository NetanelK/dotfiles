#!/bin/bash
input=$(cat)

MODEL=$(echo "$input" | jq -r '.model.display_name')
DIR=$(echo "$input" | jq -r '.workspace.current_dir')
COST=$(echo "$input" | jq -r '.cost.total_cost_usd // 0')
PCT=$(echo "$input" | jq -r '.context_window.used_percentage // 0' | cut -d. -f1)
DURATION_MS=$(echo "$input" | jq -r '.cost.total_duration_ms // 0')

CYAN='\033[36m'; GREEN='\033[32m'; YELLOW='\033[33m'; RED='\033[31m'; RESET='\033[0m'

# Pick bar color based on context usage
if [ "$PCT" -ge 90 ]; then BAR_COLOR="$RED"
elif [ "$PCT" -ge 70 ]; then BAR_COLOR="$YELLOW"
else BAR_COLOR="$GREEN"; fi

FILLED=$((PCT / 10)); EMPTY=$((10 - FILLED))
printf -v FILL "%${FILLED}s"; printf -v PAD "%${EMPTY}s"
BAR="${FILL// /█}${PAD// /░}"

MINS=$((DURATION_MS / 60000)); SECS=$(((DURATION_MS % 60000) / 1000))

BRANCH=""
REPO_LINK=""
if git -C "$DIR" rev-parse --git-dir > /dev/null 2>&1; then
  CURRENT_BRANCH=$(git -C "$DIR" branch --show-current 2>/dev/null)
  BRANCH=" | 🌿 ${CURRENT_BRANCH}"

  REMOTE_URL=$(git -C "$DIR" remote get-url origin 2>/dev/null)
  if [ -n "$REMOTE_URL" ]; then
    # Normalize SSH remote (git@github.com:org/repo.git) to HTTPS URL
    if echo "$REMOTE_URL" | grep -q "^git@"; then
      REMOTE_URL=$(echo "$REMOTE_URL" | sed 's|git@\(.*\):\(.*\)\.git|https://\1/\2|; s|git@\(.*\):\(.*\)|https://\1/\2|')
    else
      REMOTE_URL=$(echo "$REMOTE_URL" | sed 's|\.git$||')
    fi
    # Build branch URL: append /tree/<branch> if branch is known
    if [ -n "$CURRENT_BRANCH" ]; then
      BRANCH_URL="${REMOTE_URL}/tree/${CURRENT_BRANCH}"
    else
      BRANCH_URL="$REMOTE_URL"
    fi
    # Make the branch name itself a clickable OSC 8 hyperlink
    BRANCH=" | 🌿 \033]8;;${BRANCH_URL}\033\\${CURRENT_BRANCH}\033]8;;\033\\"
  fi
fi

echo -e "${CYAN}[$MODEL]${RESET} 📁 ${DIR##*/}${BRANCH}"
COST_FMT=$(printf '$%.2f' "$COST")
echo -e "${BAR_COLOR}${BAR}${RESET} ${PCT}% | ${YELLOW}${COST_FMT}${RESET} | ⏱️ ${MINS}m ${SECS}s"
