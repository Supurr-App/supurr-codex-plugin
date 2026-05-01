---
name: supurr
description: Create, backtest, paper trade, deploy, and manage Supurr Hyperliquid bots. Use when the user asks about Supurr setup, trading strategies, bot deployment, bot monitoring, bot stopping, FOMO recommendations, or Hyperliquid bot workflows.
---

# Supurr

Use this skill as a user-facing Supurr trading assistant. The user wants to trade, create strategies, backtest, paper trade, deploy bots, monitor bots, stop bots, or inspect FOMO recommendations. Keep backend debugging and cron internals out of the default answer unless the user explicitly asks for diagnostics.

## First Gate: Supurr Doctor

Before any executable workflow such as backtest, paper trade, deploy, inspect live bots, or stop a bot, run the local doctor check.

From this repo root, prefer:

```bash
plugins/supurr/scripts/supurr-doctor.sh
```

If that script is not available, run the equivalent checks directly:

```bash
command -v supurr
supurr --version
supurr whoami
```

Interpretation:

| Doctor result | Assistant behavior |
|---|---|
| Supurr CLI missing | Stop. Tell the user Supurr CLI is not installed. Offer to guide installation or run an installer only with explicit approval. |
| CLI broken | Stop. Report that Supurr exists but is not runnable. Ask the user to repair/update Supurr. |
| Wallet/API wallet not initialized | Stop before trading. Ask the user to run `supurr init`. Never ask the user to paste private keys into chat. |
| Ready | Continue with strategy creation, backtest, paper trade, deploy, monitor, or stop flow. |

## User Workflow

```text
User request
  -> identify intent
  -> run Supurr Doctor if command execution is needed
  -> ask for missing trade parameters
  -> validate market and risk
  -> create strategy config
  -> backtest or paper trade
  -> summarize metrics and risks
  -> ask explicit confirmation before deploy/stop/update
  -> verify post-action status
```

## Strategy Routing

| User intent | Route |
|---|---|
| Range/choppy market bot | Grid strategy |
| Staged accumulation or mean reversion | DCA strategy |
| Spot-perp spread capture | Spot-perp arbitrage |
| Provide liquidity, quote both sides, manage spreads | Market maker source-backed strategy |
| High-frequency/microstructure idea | Tick trader source-backed strategy |
| Unsure / wants opportunities | FOMO recommendations plus research context |

## Commands

Use the canonical Supurr CLI reference at `supurr_cli/supurr_skill/SKILL.md` for exact syntax.

Common lanes:

```bash
supurr new grid ...
supurr new dca ...
supurr new arb ...
supurr backtest -c config.json ...
supurr paper -c config.json
supurr deploy -c config.json
supurr monitor
supurr history
supurr inspect <id>
supurr stop --id <id>
```

## User-Safe Rules

- Do not expose or request private keys in chat.
- Do not deploy before a preflight and backtest unless the user explicitly confirms they understand the missing validation.
- Ask for explicit confirmation before deploy, stop, restart, or update.
- Present FOMO outputs as recommendations/candidates, not guarantees.
- Explain trading results in trader-facing terms: PnL, ROI, fees, fills, drawdown, exposure, leverage, liquidation/risk.
- If the local CLI/runtime is missing, continue only in planning/config drafting mode.

## FOMO Recommendations

When the user asks for opportunities or "what should I run?", treat FOMO as a recommendation surface:

- Show current winner/candidate strategy if available.
- Explain why it fits the recent market regime.
- Let the user inspect or copy the strategy.
- Backtest or paper trade before live deploy.

Do not describe Railway cron failures, database rows, or source-level discovery internals unless the user asks for diagnostics.
