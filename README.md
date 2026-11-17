# Compliance Panel

> Independent specialist Claude agents assess your project against EU digital regulations in parallel — the Panel Chair cross-correlates findings to surface compound regulatory exposure no single check would catch.

## What problem it solves

Single-context compliance reviews suffer from the same tunnel-vision problem as security reviews: whichever regulation the reviewer starts from biases what gets surfaced afterward. A GDPR-first read misses the e-Privacy interaction on the same cookie-and-analytics fact pattern. An AI Act read in isolation misses the GDPR processing the AI system triggers. NIS2 incident-reporting gaps live alongside GDPR breach-notification gaps on the same incident. Iterating in one context doesn't fix this — each turn inherits the prior framing.

Compliance Panel spawns each regulatory assessor as an **independent Claude agent with its own context**. The `gdpr-assessor` doesn't see the `ai-act-assessor`'s working theories; the `eprivacy-assessor` isn't anchored on the `nis2-assessor`'s scope determination. After the parallel assessment phase, the Panel Chair cross-correlates the independent findings to surface compound exposure — combinations where two findings under different regimes together create a higher-tier risk than either alone.

## How it works

0. **Plan card (you confirm before anything spawns).** The Chair shows a one-screen card: scope, roster (always-on plus opt-in seats with rationale), per-seat model, rough token/wall-clock budget. You reply `go`, `add dpia-assessor`, `drop data-act-assessor`, `narrow scope to src/api`, or `abort`.
1. **Recon (Chair, single context).** The Chair scans the project: processing activities, data categories, AI components, connected devices, data transfers, user base, existing compliance documentation. The recon brief lands at `~/.claude/compliance-panel/<slug>/recon.md`. Every spawn prompt points to that path so the recon hits the prompt cache across parallel assessor spawns.
2. **Assessment fan-out (parallel).** In one message the Chair spawns every selected assessor as an unnamed background subagent (`Agent(model: …, effort: …, prompt: …)`). Each receives only its own role brief and the recon — **no inter-agent communication during the assessment phase**. Independence is the whole point.
3. **Spawn check.** The Chair emits one structured line — `SPAWN: 6/6 ok | started=[...] | failed=[]` — so spawn health is visible, not inferred.
4. **Cross-correlation (Chair).** The Chair tests findings against each other for compound regulatory exposure. Missing RoPA + missing DPA + missing breach notification = full GDPR accountability failure, not three minor gaps. Cookie consent gap + analytics without lawful basis = dual e-Privacy + GDPR exposure on the same facts. High-risk AI system + no DPIA + no human oversight = AI Act + GDPR compound obligation.
5. **Report preview + write.** The Chair posts the draft report to chat for `save` / `amend` / `discard`. On save: `~/.claude/compliance-panel/<yyyy-mm-dd>-<slug>/report.md` (outside the repo under review).

**Stop early** at any phase by saying "stop the compliance panel" — the Chair stops in-flight agents, collects whatever findings are in, writes a partial report with `status: halted`.

## Benefits

- **Genuine independence.** Each assessor is a separate Claude with its own context — no priming bleeds between regulatory regimes. You catch gaps that a single-context reviewer (whether human or AI) would unify under one frame and miss in another.
- **Compound-exposure discovery.** Cross-correlation finds risk patterns that exist *between* regulations, not within any single one. A minor GDPR gap and a minor e-Privacy gap on the same fact pattern is one major dual-regime exposure, not two separate minors.
- **Cheap fan-out via prompt cache.** Recon brief written once, referenced by every spawn — identical reads hit the 5-minute prompt cache, recovering meaningful tokens on multi-assessor reviews.
- **Clean checks are real results.** Regulations or articles the Chair explicitly reviewed and found compliant get a "Clean Checks" line in the report. Omission would be ambiguous — did the assessor check this and find nothing, or never look?
- **Severity rooted in enforcement risk and effort to fix**, not theoretical compliance-checkbox theatre. A consent-banner reject-button buried two clicks deep is `minor` (real but low-priority exposure), not `blocker`. Cookies set before consent is `blocker` regardless of how small the app is.

## Tradeoffs

- **Token cost.** 5+ parallel contexts, each receiving role brief + recon brief + tool access for static analysis. Expect roughly **5–10×** the tokens of a single-context compliance review. The proactive triggers are deliberately bounded.
- **Wall-clock latency.** Even parallel, the phase ends only when the slowest assessor is in.
- **Not a substitute for legal counsel.** This is design-time / pre-launch automated review against the codebase and project documentation. It does not represent a formal compliance audit, does not constitute legal advice, and does not adapt to jurisdictional nuance the way a qualified DPO or privacy lawyer would. Use it as the cheap layer before engaging counsel.
- **EU scope.** Coverage is the five named EU digital regulations. UK GDPR, US state privacy laws (CCPA / CPRA / etc.), Brazilian LGPD, and other regimes are explicitly out of scope.
- **False-positive surface area.** Multiple assessors will sometimes flag non-issues or things resolved in documentation the assessor didn't have access to. The `amend` step in the report preview is the safety valve.

## When to invoke

Trigger phrases: "compliance review", "compliance audit", "GDPR check", "are we GDPR compliant", "privacy audit", "AI Act obligations", "are we AI Act compliant", "fine-print", "legal review" (in a compliance context), "data protection review", "regulatory risk".

**Proactive triggers** (Chair pauses for plan-card approval, doesn't run unprompted):
- Personal data processing detected in code (user records, session storage, analytics events)
- LLM or ML components identified (OpenAI, Anthropic, local models, embeddings, classification pipelines)
- Cookie or tracking code found (analytics, advertising tags, fingerprinting)
- International data transfers in config (third-country processor URLs, non-EEA storage regions)
- New public endpoints that accept personal data
- IoT or connected-product code (sensor ingestion, device-to-cloud telemetry)

**Do NOT invoke** for: code-style review, internal-tooling work with no personal data, single-jurisdiction US-only products (use a US-focused tool), or feature work that adds nothing to the existing processing surface.

## Roster

**Always-on (5):** `gdpr-assessor` · `eprivacy-assessor` · `nis2-assessor` · `ai-act-assessor` · `data-act-assessor`

**Opt-in (Chair adds during recon):** `dpia-assessor` (high-risk processing detected) · `bcr-assessor` (international group transfers detected)

Per-assessor methodology lives in [`skills/compliance-panel/references/agents/`](./skills/compliance-panel/references/agents/). Each file is loaded only when that assessor is spawned.

## Slash command

```
/compliance-panel:compliance-panel [scope-path]
```

Optional `scope-path` argument narrows the review (e.g., `/compliance-panel:compliance-panel src/api`). Without it, the entire repo is in scope. The recon still reads `CLAUDE.md`, package manifests, and any `privacy-policy.md` / `dpa.md` / `ropa.md` from the repo root regardless — regulatory scope crosses subtree boundaries.

## Output location

`~/.claude/compliance-panel/<yyyy-mm-dd>-<slug>/report.md` — per-user artifact space, **not** plugin-owned, **not** in your repo. Compliance findings can include identifiers (data subject ID patterns, internal endpoint paths, processor names) that should not be committed by accident.

## Installation

```
/plugin marketplace add sjsyrek/claude-plugins
/plugin install compliance-panel@sjsyrek
```

The marketplace lives at [sjsyrek/claude-plugins](https://github.com/sjsyrek/claude-plugins) and points at this repo.

## Runtime requirements

- `Agent` with `model` and `effort` — spawns each assessor as an independent background subagent (background is the default)
- `TaskStop` — stops in-flight assessors when you say "stop the compliance panel"
- File-system write access to `~/.claude/compliance-panel/`
- Read access to the project repo under review (for assessors to inspect code, config, and documentation)

No external services are called. All assessment runs locally against the codebase.

## Limitations & disclaimer

**This is not legal advice.** Compliance Panel is an automated review tool that surfaces likely gaps against the named regulations based on the contents of the repository and project documentation. It does **not** constitute:

- A formal compliance audit
- Legal advice
- A substitute for a qualified Data Protection Officer (DPO), privacy lawyer, or regulatory consultant
- Adaptation to jurisdictional nuance (member-state-specific GDPR derogations, enforcement-authority guidance, sectoral overlays)

Regulatory interpretation varies by jurisdiction, enforcement context, and business model. Findings are starting points for review by a qualified professional, **not** conclusions to act on directly. Engage a DPO, privacy counsel, or regulatory advisor before relying on these findings for compliance decisions, regulatory submissions, or representations to customers and partners.

**Scope is EU-only.** UK GDPR, US state privacy laws (CCPA, CPRA, VCDPA, CTDPA, UCPA, etc.), Brazilian LGPD, Canadian PIPEDA, and other non-EU regimes are explicitly out of scope. A "clean" Compliance Panel report does not imply compliance with any non-EU regulation.

## Version history

See [CHANGELOG.md](./CHANGELOG.md).

## License

MIT
