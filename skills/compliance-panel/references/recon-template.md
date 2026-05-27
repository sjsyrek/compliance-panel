# Recon brief template

The Chair fills out this template during Phase 1 (Recon) and writes it to `~/.claude/compliance-panel/<slug>/recon.md`. Every assessor's spawn prompt points to this path so identical reads hit the prompt cache across parallel spawns.

The recon brief is the **only shared context** across all assessors. It must be precise and bounded — anything ambiguous here becomes ambiguous in five-to-seven independent parallel contexts.

---

## Template (copy below into `recon.md`)

# Compliance Panel Recon Brief

**Date**: YYYY-MM-DD
**Scope**: [repo root | path/to/subtree]
**Repository**: [owner/repo]

---

### PROCESSING ACTIVITIES

Numbered list of distinct personal-data processing activities identified in code/docs. Each entry: short name + 1-line description + file path(s).

1. User authentication and session — `src/auth/*.ts`
2. Analytics events — `src/analytics/*.ts`
3. Marketing email — `src/email/marketing.ts` + Postmark integration
4. Customer support transcripts — `src/support/*.ts` + Intercom integration
5. ...

### DATA CATEGORIES

- **Personal**: [email, name, IP, device ID, etc. — be specific]
- **Special category** (Art. 9): [health, biometric, political, religious, sexual orientation, etc. — or "none detected"]
- **Children's data** (Art. 8): [age verification present? — or "no info-society service targeting under-16"]
- **Employee data**: [if any — usually out of scope for product compliance, note for completeness]

### AI COMPONENTS

List every AI system identified, with preliminary classification per `ai-act-risk-classifier.md`. Or "none detected".

- `src/ai/classifier.ts` — sklearn classifier on credit-application inputs — likely high-risk (Annex III item 5, access to essential services)
- `src/ai/chat.ts` — OpenAI GPT-4 wrapper for customer support — limited-risk transparency obligation (Art. 50)
- `src/ai/embeddings.ts` — text-embedding-3 for similarity search driving recommendations — likely AI system, minimal/limited-risk
- ...

### CONNECTED DEVICES

IoT, sensors, hardware integrations — basis for Data Act in-scope determination.

- [list with file paths and brief purpose, or:]
- "No IoT or connected products detected → Data Act not triggered for connected-product obligations"

### DATA TRANSFERS

Any personal data leaving the EEA. Third-country processors, non-EEA storage regions.

- AWS region `us-east-1` for analytics warehouse — third-country transfer to US, requires SCC/adequacy assessment (DPF currently in force)
- Sentry processing — Frankfurt (EEA, no transfer)
- Stripe — Ireland (EEA controller), some processing in US (DPF-covered)
- ...

### USER BASE

- **Type**: [B2C / B2B / public sector / mixed]
- **Geography**: [EU/EEA primary, UK secondary, US tertiary — or specifics from config / marketing copy]
- **Estimated scale**: [DAU/MAU/users — for "large-scale" determinations under GDPR Art. 35 and NIS2 size thresholds]

### EXISTING DOCUMENTATION

What compliance documentation was found in the repo. Use ✓ / ✗ / ⚠ (incomplete).

| Document | Path | Status | Notes |
|---|---|---|---|
| Privacy Policy | `docs/privacy.md` | ✓ | Last updated 2026-01-15 |
| Cookie Policy | — | ✗ | Not found |
| RoPA | — | ✗ | Not found |
| DPAs | `docs/dpas/` | ⚠ | Found 2/4 expected processors |
| DPIA | — | ✗ | Not found — see opt-in trigger below |
| Incident Response Plan | `docs/security/ir-plan.md` | ✓ | Covers GDPR Art. 33 + NIS2 Art. 23 |
| AI System Technical Documentation | — | ✗ | Not found — see AI components above |
| Cybersecurity Risk Management Framework | — | ✗ | Not found — NIS2 in-scope determination first |

### OPT-IN SEATS

Each opt-in seat the Chair recommends activating, with one-line rationale tied to evidence above.

- `dpia-assessor` — large-scale special-category data detected (health classifier on >100k records, `src/ai/classifier.ts`) triggers Art. 35
- `bcr-assessor` — config references intra-group transfer to US affiliate `ourco-us-inc` (`config/processors.yaml:34`)

### OUT-OF-SCOPE OBSERVATIONS

Non-EU obligations the Chair noticed but won't assess. Flagged for the report's Advisory section.

- UK GDPR likely applies (UK user analytics events detected in `analytics-config.json`) — out of scope for compliance-panel
- CCPA likely applies (California-routed users in `geo-routing.ts`) — out of scope for compliance-panel
- HIPAA may apply (US healthcare data in `src/health/` if US-customer flag set) — out of scope

---

## Notes for the Chair filling this in

- **Be precise about absences.** "RoPA not found at `docs/ropa.md` or repo root" is more useful than "no RoPA". Assessors then know whether to verify the absence themselves or trust the recon.
- **Cite file paths**, not generalisations. "Auth code processes email + IP" + `src/auth/login.ts:42` beats "the app handles user data".
- **Do not pre-judge findings.** The recon enumerates the facts; assessors interpret them. "Cookies set before consent" is a finding (for the e-Privacy assessor), not a recon observation. Recon-level observation is "Cookies set in `src/middleware/analytics.ts:42` on every request" — let the assessor connect it to Art. 5(3).
- **If a category has no detected content, state that explicitly.** "Connected devices: none detected" is better than omitting the heading. Silence is ambiguous.
- **Recon does not need to be exhaustive on documentation read** — assessors will read the docs themselves. Recon just confirms presence/absence and points at the path.
- **Recon is allowed to be wrong.** Assessors verify against code; recon errors get caught at assessment time. Aim for fast and reasonably complete, not perfect.
