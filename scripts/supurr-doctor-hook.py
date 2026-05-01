#!/usr/bin/env python3
import json
import subprocess
import sys
from pathlib import Path


KEYWORDS = (
    "supurr",
    "supurr cli",
    "super",
    "supercli",
    "super cli",
    "hyperliquid",
    "grid bot",
    "dca",
    "backtest",
    "deploy bot",
    "paper trade",
    "fomo",
)


def main() -> int:
    try:
        payload = json.load(sys.stdin)
    except Exception:
        payload = {}

    prompt = str(payload.get("prompt", "")).lower()
    if not any(keyword in prompt for keyword in KEYWORDS):
        return 0

    script = Path(__file__).with_name("supurr-doctor.sh")
    result = subprocess.run(
        [str(script), "--json"],
        text=True,
        capture_output=True,
        timeout=15,
        check=False,
    )

    doctor_text = result.stdout.strip() or result.stderr.strip()
    if not doctor_text:
        doctor_text = "Supurr Doctor did not return a result."

    context = (
        "Supurr Doctor preflight result for this prompt:\n"
        f"{doctor_text}\n\n"
        "Before executable Supurr workflows, follow the Supurr skill: stop on missing CLI, "
        "ask the user before installation, never request private keys in chat, and require "
        "confirmation before deploy/stop/update."
    )

    print(
        json.dumps(
            {
                "hookSpecificOutput": {
                    "hookEventName": "UserPromptSubmit",
                    "additionalContext": context,
                }
            }
        )
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
