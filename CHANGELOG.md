# Changelog

All notable changes to the compliance-panel plugin are documented here. The format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/), and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

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
