# compliance-panel eval suite

Regression tests for the skill, run with Claude Code's `claude plugin eval` (2.1.326+). Each case runs a fresh headless Claude in a sandbox (its own workspace and `home/`), optionally twice: with the plugin and without it. The score difference (Δ) shows the plugin is doing the work.

| Case | Tier | Checks |
|---|---|---|
| `01-trigger-plan-card` | 1 | "Are we GDPR compliant?" invokes the skill; it stops at a plan card with scope, the five always-on assessors, model **and effort** per seat, budget, and no list of suspected gaps; no `Agent` spawn before `go`. |
| `02-slash-scope` | 1 | `/compliance-panel:compliance-panel src` narrows scope to `src/` but still reads root config, manifests and `CLAUDE.md`. |
| `03-neg-typo` | 1 | Should **not** fire on a doc-only wording change. |
| `10-e2e-small-roster` | 2 | Pre-approved 3-assessor run (GDPR, e-Privacy, AI Act): unnamed spawns, no `run_in_background`, `SPAWN: 3/3`, finds the pre-consent cookie / US LLM transfer / automated account suspension with article cites, includes the disclaimer, stops at the report preview. |

Each case's `scaffold.sh` generates the same small EU-facing support-ticket app with planted compliance gaps. The harness only accepts a scaffold path inside the case directory, so every case carries its own copy; keep them identical when you change one.

## Running

```sh
# Tier 1 (cheap): one run per case, with and without the plugin
claude plugin eval . --tag tier1 --runs 1 --ablation with-without \
  --scaffold --trust-plugin --allow-tools Bash Edit --no-publish --max-cost-usd 4

# Tier 2 (one real multi-agent run)
claude plugin eval . --case 10-e2e-small-roster --runs 1 --ablation none \
  --scaffold --trust-plugin --allow-tools Bash Write --no-publish --max-cost-usd 5
```

Results land in `evals/results/` (gitignored); add `--keep-temp` to keep each run's sandbox and `trace.jsonl`.

## Gotchas

- `--scaffold` runs the case's bash as you; only use it on case files you've read.
- `--case` takes a simple glob (`01-*`), not character classes (`0[12]-*` matches nothing). Prefer one `--case` per invocation, or `--tag`.
- Write flags out literally in zsh: a variable holding several flags (`$common`) is passed as a single argument.
- `case.yaml` can only set `EVAL_*` environment variables. Anything else (e.g. `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS`) comes from the operator's shell — **and** from the `env` block of your `~/.claude/settings.json`, which the CLI applies to the sandboxed run regardless of the shell.
- On a Pro/Max subscription, `costUsd` is notional (API-price equivalent) but the runs count against your plan's usage limits. Tier 1 costs roughly $1 notional per full pass; the Tier 2 case a few dollars.
