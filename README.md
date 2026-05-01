# Supurr Apps / Supurr Codex Plugin

Repo-local Codex plugin for Supurr trading workflows on Hyperliquid.

## What It Does

| Prompt | Behavior |
|---|---|
| Create a bot | Routes to Grid, DCA, or spot-perp arb config creation. |
| Backtest / paper trade | Runs Supurr Doctor first, then uses local Supurr CLI. |
| Deploy / stop / update | Requires explicit user confirmation. |
| FOMO / opportunities | Treats recommendations as candidates, not guarantees. |

## Runtime Gate

The `UserPromptSubmit` hook checks the local Supurr runtime before executable workflows.

```text
User prompt
  -> Supurr hook
  -> supurr-doctor-hook.py
  -> supurr-doctor.sh
  -> skill receives ready/missing/broken context
```

If Supurr CLI is missing, the assistant should stop and ask the user to install it.

## Install Supurr CLI

```bash
curl -fsSL https://cli.supurr.app/install | bash
supurr --version
supurr init
```

Do not paste private keys into chat. Use `supurr init` locally.

## Plugin Install

For local development, add this checkout as a marketplace from the Codex plugin directory. If your Codex CLI build includes plugin marketplace commands:

```bash
codex plugin marketplace add /Users/amitsharma/Desktop/ai-agent/plugins/supurr
```

This GitHub repo uses plugin-at-root layout:

```text
.agents/plugins/marketplace.json
.codex-plugin/plugin.json
skills/
hooks/
scripts/
assets/
```

Then install from Git:

```bash
codex plugin marketplace add Supurr-App/supurr-codex-plugin --ref main
```

If the local CLI does not expose `codex plugin`, use the Codex app plugin directory and add the marketplace there.

## Publish Blockers

| Blocker | Owner |
|---|---|
| Public plugin repo name | Done: `Supurr-App/supurr-codex-plugin` |
| License decision | Supurr |
| Real privacy policy URL | Supurr |
| Real terms of service URL | Supurr |
| Marketplace screenshots | Supurr/product |
