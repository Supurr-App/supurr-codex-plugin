#!/usr/bin/env sh
set -u

json=false
if [ "${1:-}" = "--json" ]; then
  json=true
fi

escape_json() {
  python3 -c 'import json,sys; print(json.dumps(sys.stdin.read().strip()))'
}

emit_text() {
  printf '%s\n' "$1"
}

emit_json() {
  status="$1"
  message="$2"
  detail="${3:-}"
  printf '{"status":"%s","message":%s,"detail":%s}\n' \
    "$status" \
    "$(printf '%s' "$message" | escape_json)" \
    "$(printf '%s' "$detail" | escape_json)"
}

finish() {
  code="$1"
  status="$2"
  message="$3"
  detail="${4:-}"
  if [ "$json" = true ]; then
    emit_json "$status" "$message" "$detail"
  else
    emit_text "Supurr Doctor: $message"
    if [ -n "$detail" ]; then
      emit_text "$detail"
    fi
  fi
  exit "$code"
}

if ! command -v supurr >/dev/null 2>&1; then
  finish 20 "missing_cli" "Supurr CLI is not installed or is not on PATH." "Install Supurr before running backtests, deploys, or bot-management commands."
fi

version_output="$(supurr --version 2>&1)"
version_status=$?
if [ "$version_status" -ne 0 ]; then
  finish 21 "broken_cli" "Supurr CLI exists but failed to run." "$version_output"
fi

whoami_output="$(supurr whoami 2>&1)"
whoami_status=$?
if [ "$whoami_status" -ne 0 ]; then
  finish 30 "not_initialized" "Supurr CLI is installed, but wallet/API-wallet initialization is missing or invalid." "Run supurr init before live backtests, deploys, or bot-management commands."
fi

engine_detail=""
if [ -n "${BOT_ENGINE_PATH:-}" ] && [ -x "${BOT_ENGINE_PATH:-}" ]; then
  engine_detail="BOT_ENGINE_PATH is set and executable."
elif [ -x "$HOME/.supurr/bin/bot" ]; then
  engine_detail="Found bot engine at $HOME/.supurr/bin/bot."
elif [ -x "bot_api/bin/bot-linux-x64" ]; then
  engine_detail="Found repo-local bot engine at bot_api/bin/bot-linux-x64."
else
  engine_detail="Bot engine was not found in common locations. Supurr CLI may still resolve it during backtest; verify before backtesting."
fi

finish 0 "ready" "Supurr CLI is installed and initialized." "$(printf '%s\n%s' "$version_output" "$engine_detail")"
