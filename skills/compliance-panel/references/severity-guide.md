# Severity guide

Compliance Panel uses four severity levels: `blocker`, `major`, `minor`, `advisory`. Severity is calibrated to **enforcement risk and effort to fix**, not to blame.

When in doubt between two levels, pick the lower one and explain in the finding. Over-severity dilutes the rest of the report.

---

## Definitions

### `blocker`

Enforcement risk is concrete and material. Should resolve before launch, the next audit cycle, or the next regulatory touchpoint. A blocker is typically:

- A directly named prohibition or hard rule being violated
- A fine-triggering pattern that an enforcement authority has already published guidance against
- An absent foundational artefact (no lawful basis at all, no DPA at all, no breach notification path at all)
- A prohibited AI practice (Art. 5 of the AI Act) — these are not remediable by documentation; the system must change

### `major`

Significant non-compliance requiring remediation. Authorities will treat as a finding in an audit; may not be immediately enforceable. Typically:

- Required documentation incomplete or out of date
- An obligation partially implemented with named gaps
- A pattern that has triggered enforcement against peer companies but no harmonised guidance yet exists
- A control implemented in policy but not in code/architecture

### `minor`

Technical non-compliance with low enforcement priority but real legal exposure. Treat as cleanup work. Typically:

- Documentation present but unclear in places
- UX friction in a rights-fulfilment path
- Retention period slightly long for the stated purpose
- Logging covers most but not all of an obligation
- Privacy notice slightly behind reality (e.g. names a retired sub-processor)

### `advisory`

Best-practice gap or emerging obligation not yet enforced. Often forward-looking. Typically:

- A voluntary measure recommended by EDPB / ENISA / AI Office guidance
- A regulation entering into force later that the system will need to address
- A defensive measure beyond strict legal requirement that materially reduces risk
- A **clean check** (finding emitted as advisory severity to record that an area was assessed and found compliant)
- Out-of-scope flag (e.g. UK GDPR likely applies but is out of scope for this tool)

---

## Examples per regulation

### GDPR

| Severity | Example |
|---|---|
| `blocker` | No lawful basis documented for any processing activity (Art. 6 baseline failure) |
| `blocker` | International transfer to a non-adequate country with no SCCs/BCRs/derogation (Schrems II–grade exposure) |
| `blocker` | No breach notification path at all — incident detection exists but no 72h DPA notification process |
| `blocker` | Special-category data processing with no Art. 9(2) basis identified |
| `major` | RoPA missing entirely, OR present but missing material processing activities |
| `major` | DPA missing for a processor handling personal data |
| `major` | No erasure path for user data — soft-delete only, no hard-delete schedule, no third-party cascade |
| `major` | Consent banner allows withdrawal but the withdrawal does not propagate to downstream processors |
| `minor` | Privacy notice slightly outdated (e.g. names a sub-processor that was replaced 3 months ago) |
| `minor` | Retention periods documented but inconsistent across systems |
| `minor` | DSAR endpoint exists but response time is uncertain (no SLA, no metric) |
| `advisory` | DPIA recommended for an upcoming feature even though the strict Art. 35 trigger is not yet met |
| `advisory` | Consider a Data Protection Officer designation as scale increases past the Art. 37 threshold |

### e-Privacy

| Severity | Example |
|---|---|
| `blocker` | Non-essential cookies (analytics, advertising) set before consent is obtained |
| `blocker` | Consent banner has no reject button at all, only "accept all" |
| `major` | Reject button buried 2+ clicks deep behind "manage preferences"; accept is one click |
| `major` | Analytics under "legitimate interest" with no consent path (rejected by most EU DPAs) |
| `major` | Consent state stored in localStorage but not respected on the server when serving subsequent pages |
| `minor` | Cookie inventory missing 1–2 trackers |
| `minor` | Consent banner persists across sessions but withdrawal requires 3+ clicks |
| `advisory` | Consider Consent Management Platform (CMP) certification ahead of the e-Privacy Regulation |

### NIS2

| Severity | Example |
|---|---|
| `blocker` | Entity is in scope (Annex I/II) but has no documented cybersecurity risk-management framework |
| `blocker` | No incident reporting path defined — 24h / 72h notifications would be missed |
| `major` | Risk-management measures present but missing 2+ of the 10 named areas (Art. 21(2)) |
| `major` | Vulnerability disclosure policy missing or unreachable |
| `major` | Management body has no documented cybersecurity training |
| `minor` | Supply chain risk assessment exists but doesn't cover all critical ICT services |
| `minor` | Logging covers production but not staging where production data is mirrored |
| `advisory` | A European cybersecurity certification scheme is available for the use case but not yet adopted |

### AI Act

| Severity | Example |
|---|---|
| `blocker` | Prohibited practice (Art. 5) — e.g. emotion recognition in workplace, social scoring, biometric categorisation inferring protected characteristics |
| `blocker` | High-risk system (Annex III) in production with no conformity assessment, no technical documentation, no human oversight |
| `blocker` | GPAI used as the basis of a high-risk system with no downstream-provider information |
| `major` | High-risk system has documentation but is missing 2+ Annex IV elements |
| `major` | GPAI deployed without downstream transparency information from provider |
| `major` | Limited-risk transparency missing — chatbot does not disclose it is an AI |
| `major` | High-risk system shipped without registration in the EU database (Art. 49) |
| `minor` | High-risk system logging covers operations but is missing retention metadata |
| `minor` | Deepfake disclosure present in UI but missing in API responses |
| `advisory` | AI system not yet classified; runs classifier now even though no obligations are triggered |
| `advisory` | High-risk-system rules apply from Aug 2026; start documentation now |

### Data Act (when in scope)

| Severity | Example |
|---|---|
| `blocker` | Connected-product user has no path to access the data their device generates (Art. 4 baseline) |
| `major` | Cloud-switching provisions absent from data processing service contracts (Art. 23) |
| `major` | B2B contract contains unfair terms against an SME customer (Art. 13 list) |
| `minor` | User data access portal exists but doesn't include all data categories |
| `advisory` | Egress-fee structure should phase out by 2027 — start planning |

---

## When to upgrade severity

The Chair upgrades severity in two cases:

1. **Compound exposure** (Phase 3 cross-correlation): when a `minor` GDPR finding and a `minor` e-Privacy finding cover the same fact pattern, the compound is at least `major` — the combined enforcement risk is higher than either alone. See SKILL.md Phase 3 for compound patterns.
2. **Documented enforcement against peer companies**: if an assessor cites an EDPB / DPA / AI Office decision against another company for an analogous gap, upgrade by one level.

The Chair does **not** downgrade assessor findings unilaterally. If a downgrade is warranted, surface it in the report's "Calibration notes" section and let the user decide on `amend`. Single-context downgrades reintroduce the framing bias that the parallel-assessor pattern is designed to avoid.
