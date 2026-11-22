# Changelog

All notable changes to the compliance-panel plugin are documented here. The format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/), and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Changed

- **Cards follow the plugin family's card standard v1.** The plan card is rendered markdown instead of a fenced block with an `=====` underline: a bold `**Compliance Panel plan** — <scope>` title, bulleted bold-label fields (Scope, Budget, Output, and Trigger when proactive), a seat count line and a `Seat | Model | Effort` table holding every seat, a `Why` bullet per opt-in seat, and a final `Reply:` line of backticked verbs separated by pipes. Claude Code draws the table borders and stacks the table on narrow terminals and in screen-reader mode. The `SPAWN` status line is one whole-line code span with its text unchanged. The report preview is rendered without a fence and ends with `Reply:` `save` | `amend <note>` | `discard`. The README shows an example plan card. New layout graders in `01-trigger-plan-card` and `02-slash-scope`: `card-format`, `reply-line` and `no-boxes`. The title is always separated by an em dash, never a colon.

## [0.2.1] — 2026-11-21

### Fixed

- **Recon rationale and the "no external services" note.** README, `SKILL.md` and `recon-template.md` claimed the shared `recon.md` read hit the prompt cache across assessors; each assessor's prompt diverges before that read, so the real saving is the Chair writing the recon once (same correction as design-council 0.5.0). The README's "No external services are called" now says the assessors are Claude agents in your session.

## [0.2.0] — 2026-11-19

### Added

- **Eval suite** (`evals/`) for `claude plugin eval`: plan-card, scoped slash command and should-not-fire cases, plus one end-to-end three-assessor run on a generated support-ticket app with planted gaps. `evals/results/` is gitignored. See `evals/README.md`.

### Changed

- **Assessors spawn as unnamed background subagents** — `Agent(model: …, effort: …, prompt: …)`, one per assessor, in one message. `run_in_background` is no longer an `Agent` parameter (background is the default). The skill now says not to name assessors: with agent teams enabled, a named spawn becomes a teammate that can message other agents.
- **Phase 2.5 is a spawn check, not a handshake.** Subagents don't message back; each `Agent` call returns an ID or an error. Status line is now `SPAWN: N/N ok | started=[...] | failed=[...]`; retry-once is unchanged.
- **"Stop the compliance panel" stops each in-flight assessor with `TaskStop`** instead of a broadcast.
- **Plan card shows effort as well as model per seat.**
- **Proactive triggering is an offer, stated plainly.** The description no longer tells Claude to run "even if the user didn't ask"; it offers the plan card when regulated processing is detected and never runs unprompted (which the body already required).

### Removed

- **`commands/compliance-panel.md`.** The skill is already invocable as `/compliance-panel:compliance-panel`, so the command was a second copy listed alongside it. Its `argument-hint` and scope-narrowing rules moved into `SKILL.md`. The invocation is unchanged.

### Fixed

- **Plan card no longer lists suspected gaps, and shows effort per seat.** The Chair listed "early signals" and "what the panel will look hardest at" before any assessor ran, pre-empting the independent assessment phase; and its Models line gave no effort levels. Phase 0 now says the card describes scope, seats and opt-in reasons only, and the template shows one `model / effort` line per seat. Found by the new eval suite.

## [0.1.1] — 2026-05-28

Documentation-only patch. The README "Slash command" section and the SKILL.md "What the user sees" invocation note now show the actual namespaced form of the slash command (`/compliance-panel:compliance-panel`) instead of the bare form. Claude Code namespaces every plugin slash command as `/<plugin>:<command>` to avoid collisions across third-party plugins; the bare `/compliance-panel` form (advertised in 0.1.0) was never a valid invocation.

### Fixed

- **README**: `/compliance-panel [scope-path]` → `/compliance-panel:compliance-panel [scope-path]` in the Slash command section and example.
- **SKILL.md**: same fix in the "What the user sees" invocation note.

## [0.1.0] — 2026-05-28

Initial release. Multi-agent EU digital compliance review modeled on the parallel-fan-out + cross-correlation pattern from `red-team` (sibling plugin in the same marketplace). Independent specialist assessor agents per regulation; the Panel Chair synthesizes findings into a prioritised gap report with concrete remediation guidance.

### Added

- **Five always-on assessor seats** for the core EU digital regulations: `gdpr-assessor`, `eprivacy-assessor`, `nis2-assessor`, `ai-act-assessor`, `data-act-assessor`. The Data Act assessor activates findings only if the recon detects IoT, connected products, or B2B data sharing — the seat is always spawned, but its output is bounded by scope detection.
- **Two opt-in assessor seats**: `dpia-assessor` (added when high-risk processing is detected — large-scale special-category data, systematic monitoring, automated decisions with legal effects) and `bcr-assessor` (added when international group transfers are detected).
- **Cross-correlation pass** that identifies compound regulatory exposure — e.g., missing RoPA + missing DPA + missing breach notification path together constitute a full GDPR accountability failure, not three separate minor gaps; cookie-consent gap + analytics without lawful basis exposes the same fact pattern to both e-Privacy and GDPR.
- **Structured finding schema**: regulation, article (with short title), severity (blocker / major / minor / advisory), one-sentence finding, evidence (file path / config value / absence), concrete remediation, effort estimate (hours / days / weeks).
- **`/compliance-panel` slash command** with optional `[scope-path]` argument.
- **Phase 0 plan card** before any agent spawns — user confirms scope, roster (with opt-in rationale), per-seat model, and budget.
- **Report preview before write** — user reviews the draft report in chat and replies `save`, `amend <note>`, or `discard`.
- **Stop-early path** — saying "stop the compliance panel" cancels in-flight agents and writes a partial report with `status: halted`.
- **Reference files**: `regulation-summaries.md` (scope, key obligations, fine regime, key articles per regulation), `ai-act-risk-classifier.md` (decision tree for AI system risk tiers), `compliance-checklist.md` (~60-item master methodology), `severity-guide.md` (enforcement-risk calibration), `recon-template.md`, `report-template.md`.
- **Output written outside the repo under review** to `~/.claude/compliance-panel/<yyyy-mm-dd>-<slug>/report.md` — compliance findings sometimes include reproduction details (data subject ID patterns, internal endpoint paths, processor identities) that should not land in the project's git history.
- **Disclaimer** in three places (report template, README, SKILL.md non-negotiable rules): this skill is automated review tooling, not legal advice; engage a qualified DPO or privacy lawyer before relying on findings for regulatory submissions or material compliance decisions.
