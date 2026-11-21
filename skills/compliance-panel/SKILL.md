---
name: compliance-panel
description: Multi-agent EU digital compliance review. Spawn independent specialist assessor agents to evaluate the codebase and project documentation against GDPR, e-Privacy, NIS2, the EU AI Act, and the Data Act. Use when the user says "compliance review", "compliance audit", "GDPR check", "are we GDPR compliant", "privacy audit", "AI Act obligations", "are we AI Act compliant", "fine-print", "data protection review", or "regulatory risk". Also offer it proactively (plan card first, never run unprompted) when personal data processing, LLM/ML components, cookie/tracking code, IoT/connected-product code, or international data transfers are detected; "low-risk" and "B2B-only" are not reasons to skip the offer. NOT legal advice; engage a qualified DPO or privacy counsel before regulatory submissions.
argument-hint: [scope-path]
version: 0.2.1
---

# compliance-panel

A multi-agent EU regulatory compliance review skill. Independent specialist assessor agents evaluate distinct regulatory regimes with **no shared context during the assessment phase**; the Panel Chair cross-correlates findings afterward to surface compound regulatory exposure no single assessor would catch.

## What the user sees

1. **Plan card.** Before any agent spawns, the Chair shows a one-screen card: scope, roster (always-on plus opt-in seats with rationale for each opt-in), per-seat model, rough token/wall-clock budget. Reply `go`, `add dpia-assessor`, `drop data-act-assessor`, `narrow scope to <path>`, or `abort`.
2. **Spawn status.** After spawn: `SPAWN: 6/6 ok | started=[...] | failed=[]`. Spawn health visible, not inferred.
3. **Silent assessment phase.** Assessors run in parallel with no inter-agent communication. The Chair surfaces per-agent progress notifications.
4. **Report preview.** Before any file is written, the Chair posts the draft report to chat. Reply `save`, `amend <note>`, or `discard`.
5. **Output.** Final report at `~/.claude/compliance-panel/<yyyy-mm-dd>-<slug>/report.md` (outside the repo under review).
6. **Stop early.** Say "stop the compliance panel" at any phase — Chair stops in-flight agents, collects whatever findings are already in, writes a partial report with `status: halted` and `cancelled_at: <phase>`.

Invocation: `/compliance-panel:compliance-panel [scope-path]` or any of the trigger phrases above. With no scope, the whole repository at the current working directory is in scope. With a path, narrow the assessment fan-out to that subtree — but still read `CLAUDE.md`, package manifests, and compliance documentation (`privacy-policy.md`, `dpa.md`, `ropa.md`, `dpia.md`, cookie policy, etc.) from the repo root, since regulatory scope crosses subtree boundaries. Start at Phase 0 either way; an explicit invocation doesn't skip the plan card.

## When to invoke

Trigger phrases: "compliance review", "compliance audit", "GDPR check", "are we GDPR compliant", "privacy audit", "AI Act obligations", "are we AI Act compliant", "fine-print", "legal review" (compliance context), "data protection review", "regulatory risk".

**Proactive triggers** (pause for plan-card approval, do not run unprompted):
- Personal data processing detected in code (user records, session storage, analytics events)
- LLM or ML components identified (OpenAI/Anthropic SDKs, local models, embeddings, classification pipelines, automated decision logic)
- Cookie or tracking code (analytics tags, advertising pixels, fingerprinting libraries)
- International data transfers in config (non-EEA processor URLs, third-country storage regions)
- New public endpoints that accept personal data
- IoT / connected-product code (sensor ingestion, device-to-cloud telemetry, hardware identifiers)

Regulatory exposure doesn't correlate with company size; invoke for small apps too. Do **not** skip when the user says "it's low-risk" or "we're only B2B" — B2B is in scope for most of these regulations and "low-risk" is often the AI Act's specific term of art for something quite different.

**Do NOT invoke** for: code-style review, doc-only changes, internal-tooling work with zero personal data, products serving only non-EU users with no EU-based infrastructure, or feature work that doesn't change the existing processing surface.

## Phase 0 — Plan card

Before any spawn, post the following to chat. Wait for the user's reply.

```
COMPLIANCE PANEL PLAN
=====================
Scope:      [repo root | path/to/subtree]
Always-on:  gdpr-assessor, eprivacy-assessor, nis2-assessor,
            ai-act-assessor, data-act-assessor
Opt-in:     [list with one-line rationale per seat]
            e.g. dpia-assessor — high-risk processing detected
                 (large-scale special-category data in src/health/)
            e.g. bcr-assessor — intra-group transfer to US affiliate
                 detected in config/processors.yaml
Models:     [one line per seat: model / effort — e.g.
              gdpr-assessor      Opus   / high
              eprivacy-assessor  Sonnet / medium]
Budget:     ~Nk tokens, ~M minutes wall-clock
Output:     ~/.claude/compliance-panel/<date>-<slug>/report.md

Reply: go | add <seat> | drop <seat> | narrow scope to <path> | abort
```

The plan card describes scope, seats and the reason for each opt-in — not a list of suspected gaps or "early signals", even obvious ones. Finding gaps is the assessors' job; listing suspects here pre-empts the independent assessment phase and, if they reach `recon.md`, anchors every assessor on the Chair's guesses.

User commands:
- `go` — proceed to Phase 1
- `add <seat>` / `drop <seat>` — adjust roster
- `narrow scope to <path>` — re-recon with tighter scope
- `abort` — stop, no spawn, no artifact

## Phase 1 — Recon (Chair, single context)

Build the recon brief. This is the only shared context across all assessors — it must be precise and bounded.

Steps:

1. Read `CLAUDE.md` if present — extract architecture constraints, known compliance posture, out-of-scope areas.
2. Scan project structure for the recon inputs:
   - **Processing activities** — what personal-data flows exist (analytics, auth, billing, support, marketing, ML training, etc.)
   - **Data categories** — personal, special category (health, biometric, political, etc.), children's data, employee data
   - **AI components** — LLM SDK imports, hosted-model URLs, classification pipelines, automated-decision logic
   - **Connected devices / IoT** — sensor inputs, device identifiers, telemetry endpoints
   - **Data transfers** — non-EEA processor URLs, storage regions outside the EEA, third-country sub-processors
   - **User base** — B2C / B2B / public sector inferences from auth flow, target-region config, marketing copy
   - **Existing documentation** — `privacy-policy.md`, `cookie-policy.md`, `dpa.md`, `ropa.md`, `dpia.md`, security policy, incident-response runbook
3. Identify which opt-in seats apply (see triggers in roster table below).

Write the brief to `~/.claude/compliance-panel/<slug>/recon.md`. Every assessor's spawn prompt points to this path, so you write the recon once instead of inlining it into each spawn.

Brief format: see `references/recon-template.md`.

## Phase 2 — Assessment fan-out (parallel)

Spawn all selected assessors in one message, one `Agent(subagent_type: "general-purpose", model: …, effort: …, description: "compliance-panel: <slug>", prompt: …)` call per assessor. Subagents run in the background by default and their results arrive as notifications. Do not give assessors a `name`: when agent teams are enabled, a named spawn becomes a teammate that can message other agents, which breaks the independence below. Each assessor receives:

- Its **role brief** loaded from `references/agents/<slug>.md`
- A `Read` instruction for the recon brief at `~/.claude/compliance-panel/<slug>/recon.md`
- The **finding schema** (below)
- Pointers to `references/regulation-summaries.md`, `references/compliance-checklist.md`, and `references/severity-guide.md`
- For `ai-act-assessor`: an additional pointer to `references/ai-act-risk-classifier.md`
- Full tool access (file reads, bash, dependency manifests)

Assessors do not communicate during this phase. Independence is the whole point. Shared context contaminates findings — the Chair must not let the `gdpr-assessor`'s framing leak into the `eprivacy-assessor`'s analysis.

### Finding schema

Each assessor emits one JSON block per finding:

```json
{
  "id": "<regulation>-<6char-hex>",
  "regulation": "GDPR | e-Privacy | NIS2 | AI Act | Data Act",
  "article": "Article XX — short title",
  "severity": "blocker | major | minor | advisory",
  "finding": "one-sentence description of the gap",
  "evidence": "file path, config value, code pattern, or absence of expected documentation",
  "remediation": "concrete action — not 'add a privacy policy' but 'add a RoPA document listing the 4 processing activities identified in src/analytics.ts, src/auth.ts, src/email.ts, and the CRM integration'",
  "effort": "hours | days | weeks",
  "compound_potential": true
}
```

The `id` field is required — Phase 3 cross-correlation references findings by id when assembling compound exposure. Use the regulation prefix plus a short hex hash of the evidence (e.g., `gdpr-7f3a2b`, `eprivacy-9c8a11`).

If an assessor finds nothing in its domain, it must emit one `advisory`-severity entry naming what was reviewed:

```json
{
  "id": "gdpr-clean-001",
  "regulation": "GDPR",
  "article": "n/a",
  "severity": "advisory",
  "finding": "No gaps identified. Reviewed lawful basis documentation, RoPA, DPAs, breach notification path, and data subject rights endpoints.",
  "evidence": "privacy-policy.md, docs/ropa.md, src/api/dsr/*.ts, src/lib/breach-notification.ts",
  "remediation": "n/a",
  "effort": "n/a",
  "compound_potential": false
}
```

A clean check is a real result. Omission is ambiguous — did no assessor check this regulation, or did they check and find nothing?

### Severity definitions

- **`blocker`** — enforcement risk, potential fines, must resolve before launch or next audit cycle. Examples: no lawful basis documented for processing; cookies set before consent; prohibited AI practice (social scoring, real-time biometric ID in public spaces); high-risk AI system shipped without conformity assessment.
- **`major`** — significant non-compliance requiring remediation, may not be immediately enforceable. Examples: no DPA with a processor handling personal data; no erasure path for user data; missing AI system technical documentation; NIS2 incident-reporting path not defined.
- **`minor`** — technical non-compliance with low enforcement priority but real legal exposure. Examples: consent banner reject button harder to find than accept; retention periods undocumented; AI system transparency obligations met inconsistently.
- **`advisory`** — best-practice gap or emerging obligation not yet enforced. Examples: voluntary DPIA recommended; AI Act registration timeline approaching; consider Binding Corporate Rules for intra-group transfers.

See `references/severity-guide.md` for calibration examples per regulation. Severity is about **enforcement risk and effort to fix**, not about blame.

## Phase 2.5 — Spawn check

Each `Agent` call returns either an agent ID or an error. Emit:

```
SPAWN: N/N ok | started=[...] | failed=[...]
```

For any failed assessor:
- Retry once with the same role brief
- If second spawn fails, proceed and list the failed regulation in the report's "Scope Gaps" section so the user knows that regime was not covered

## Phase 3 — Cross-correlation (Chair)

After all assessors report back, the Chair cross-correlates before writing the report. **This is the phase that catches compound regulatory exposure.**

### Algorithm

1. Collect all findings into a single list, keyed by `id`.
2. For each finding where `compound_potential: true`, ask: which other findings does this combine with under a different regime to produce higher cumulative exposure?
3. Common compound patterns:
   - **No RoPA + no DPA + no breach notification path** → full GDPR accountability failure (Arts. 28, 30, 33). One compound `blocker`, not three separate `minor` gaps.
   - **Cookie consent gap + analytics without lawful basis** → dual e-Privacy (Art. 5(3)) + GDPR (Art. 6) exposure on the same fact pattern. Treat as one compound `major` with cross-regulation cite.
   - **High-risk AI system + no DPIA + no human oversight** → AI Act (Art. 14, Annex III obligations) + GDPR (Art. 35) compound obligation. Compound `blocker`.
   - **NIS2 incident reporting gap + GDPR breach notification gap** → dual regulatory exposure on a single security incident. Compound `major`.
   - **International transfer to non-adequate country + no SCCs/BCRs** → Schrems II-grade exposure. Compound `blocker` even if no other gap.
   - **AI system using EU user data + GPAI vendor opaque about training data** → AI Act (Art. 53) + GDPR (Art. 13/14) compound transparency gap.
4. For each compound, create a finding with:
   - `severity`: one level above the highest component finding (cap at `blocker`)
   - `components`: list of component finding `id`s
   - `combined_risk`: prose explanation of why the combination is worse than the sum of parts (3–5 sentences)
   - `remediation_path`: sequenced actions to clear the compound (not just each component independently)

## Phase 4 — Report

Skeleton: `references/report-template.md`. Severity calibration: `references/severity-guide.md`.

**Tone.** The report should read like a briefing document handed to a COO before a regulatory touchpoint — actionable, forward-looking, prioritised. **Not** a legal threat, not a condemnation. Severity is about enforcement risk and effort to fix, not blame. The audience is a team that wants a remediation roadmap.

**Preview before write.** Post the draft report to chat:

```
[draft report markdown]

Reply: save | amend <note> | discard
```

On `save`: write to `~/.claude/compliance-panel/<yyyy-mm-dd>-<slug>/report.md`. On `amend`: revise per the note, re-preview. On `discard`: clean up artifacts, no file written.

The path is **per-user artifact space, outside the repo under review**. Compliance findings can name processors, internal endpoint paths, data subject ID patterns, and other identifiers that should not land in the project's git history by accident.

## Stop early

User says "stop the compliance panel" at any phase:

1. Stop each still-running assessor with `TaskStop`
2. Collect whatever findings are already in
3. Skip cross-correlation (or run an abbreviated pass on whatever is collected)
4. Write partial report with frontmatter `status: halted`, `cancelled_at: <phase>`, `cancellation_reason: user_request`
5. Clean up

The partial report is still useful — it tells you what was assessed before you stopped, and what wasn't.

## Roster

### Always-on

| Slug | Regulation | Mission |
|---|---|---|
| `gdpr-assessor` | GDPR (Regulation 2016/679) | Lawful basis, minimisation, DSR fulfilment, consent quality, transfers, DPAs, RoPA, breach notification, privacy-by-design |
| `eprivacy-assessor` | e-Privacy Directive (2002/58/EC) | Cookie consent before non-essential cookies, banner UX, tracking pixels, fingerprinting, marketing opt-in |
| `nis2-assessor` | NIS2 Directive (2022/2555) | In-scope determination first; proportionate security measures, 24h/72h incident reporting, supply chain, vulnerability disclosure, business continuity |
| `ai-act-assessor` | EU AI Act (2024/1689) | Identify AI systems, classify by risk tier, conformity assessment for high-risk, GPAI obligations, prohibited-practices check, AI Office registration |
| `data-act-assessor` | Data Act (2023/2854) | Activates findings only if IoT/connected products/B2B data sharing detected in recon; user/third-party access rights, contractual fairness, cloud switching |

### Opt-in (Chair adds during recon based on detected context)

| Slug | Add when |
|---|---|
| `dpia-assessor` | High-risk processing detected — large-scale special-category data, systematic monitoring, automated decisions with legal effects, or any GDPR Art. 35 trigger |
| `bcr-assessor` | International intra-group transfers detected — multi-entity multinational with EU and non-EU affiliates sharing personal data |

Per-assessor methodology lives in `references/agents/<slug>.md`. **Load only when writing that assessor's spawn prompt** — keeps the always-loaded SKILL context lean.

## Non-negotiable rules

- **This is not legal advice.** The Chair must include the disclaimer block in every report. Never word a finding as a legal conclusion ("you are in violation of Art. X") — word it as an observed gap with a remediation path. Engage qualified DPO/counsel before any regulatory submission or material compliance decision.
- **EU scope only.** Findings are framed against the five named regulations. If recon detects non-EU obligations (UK GDPR, CCPA, LGPD, etc.), surface a single advisory item noting they are out of scope for this tool. Do not silently extend.
- **Severity is calibrated to enforcement risk and effort to fix**, not to blame. A finding can be `blocker` without anyone having done anything wrong (regulation came into force after the system was built; new sub-processor without paperwork yet).
- **Assessors run in parallel with no inter-agent communication.** Independence is the protection against single-frame tunnel vision; do not introduce a "review each other's findings" phase.
- **Clean checks are reported, not omitted.** Every regulation or article explicitly reviewed and found compliant gets a Clean Checks line. Omission is ambiguous.
- **Report lives outside the repo under review.** Default `~/.claude/compliance-panel/`.
- **Preview before write.** No file lands without the user's `save` reply.
- **Scope discipline.** Unrelated issues surfaced during assessment → flagged in the report's Advisory section, not silently corrected in code.

## Notes for the Panel Chair

**On evidence standards.** Assessors must cite specific file paths, line numbers, config values, or named absences of expected documentation. "There might be a consent issue" is not a finding. "Cookies set on first request at `src/middleware/analytics.ts:42` before any consent prompt is rendered" is a finding.

**On the Data Act assessor.** It is always spawned, but its in-scope determination runs first. If the recon shows no IoT, no connected products, and no B2B data sharing, the assessor emits a single `advisory` clean check ("Data Act not applicable — no IoT, connected products, or B2B data sharing detected in scope") and exits. This is fast and cheap; do not skip the assessor entirely based on recon — it confirms negative scope.

**On the AI Act risk classifier.** The `ai-act-assessor` must run `references/ai-act-risk-classifier.md` as its first methodology step before assessing obligations. Risk tier determines which obligations apply; getting the tier wrong invalidates everything else.

**On proactive triggering.** When triggered proactively (not from a user trigger phrase), the plan card includes the **proactive trigger reason** — e.g., "Detected new LLM integration in `src/ai/classifier.ts` — AI Act + GDPR exposure on automated decisioning." The user can `defer` (records as a known unaudited compliance surface, will not re-trigger on the same surface for 7 days) or `go`.

**On compound findings vs separate findings.** Three minor GDPR gaps that together create accountability failure should be one compound `blocker`, not three minors stacked. The Chair's job in Phase 3 is to see the shape that no single assessor sees.

## Reference files

- `references/agents/<slug>.md` — Per-assessor methodology + spawn brief (load when writing that assessor's spawn prompt)
- `references/regulation-summaries.md` — Scope, key obligations, enforcement body, fine regime, and most-relevant articles per regulation
- `references/ai-act-risk-classifier.md` — Decision tree to classify AI systems by risk tier (prohibited, high-risk, limited-risk, minimal-risk, GPAI)
- `references/compliance-checklist.md` — ~60-item master checklist organised by regulation → article (assessor methodology)
- `references/severity-guide.md` — Enforcement-risk-based severity rubric with per-regulation examples
- `references/recon-template.md` — Phase 1 brief format
- `references/report-template.md` — Phase 4 markdown skeleton (includes mandatory disclaimer block)
