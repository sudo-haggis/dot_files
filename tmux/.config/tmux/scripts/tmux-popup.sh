#!/usr/bin/env bash
# tmux-popup.sh
# Generic tmux floating popup launcher
# Usage: tmux-popup.sh [-w WIDTH] [-h HEIGHT] [-d DIR] <command>

set -euo pipefail

# ── Defaults ──────────────────────────────────────────────────────────────────
WIDTH="90%"
HEIGHT="90%"
WORKDIR="$(pwd)"

# ── Args ──────────────────────────────────────────────────────────────────────
while getopts "w:h:d:" opt; do
    case $opt in
        w) WIDTH="$OPTARG"   ;;
        h) HEIGHT="$OPTARG"  ;;
        d) WORKDIR="$OPTARG" ;;
        *) echo "Usage: tmux-popup.sh [-w WIDTH] [-h HEIGHT] [-d DIR] <command>" && exit 1 ;;
    esac
done
shift $((OPTIND - 1))

CMD="${*:-bash}"

# ── Guard ─────────────────────────────────────────────────────────────────────
if [[ -z "${TMUX:-}" ]]; then
    echo "Error: must be run inside a tmux session" && exit 1
fi

# ── Launch ────────────────────────────────────────────────────────────────────
tmux display-popup -E -w "$WIDTH" -h "$HEIGHT" -d "$WORKDIR" "$CMD"
