# Report template

The Chair writes the final report from this template after Phase 3 (cross-correlation). Output path: `~/.claude/compliance-panel/<yyyy-mm-dd>-<slug>/report.md`.

**Preview before write.** Post the draft to chat in the preview shape from `SKILL.md` (rendered markdown, no code fence, ending with `Reply:` `save` | `amend <note>` | `discard`). Do not write the file until the user replies `save`.

The **Disclaimer** block at the bottom is mandatory and never abbreviated.

---

## Template (copy into `report.md`)

# Compliance Panel Report: <Project Name>

**Date**: YYYY-MM-DD
**Regulations assessed**: GDPR · e-Privacy · NIS2 · AI Act · [Data Act if active]
**Panel seats**: [list of assessor slugs that ran]
**Scope**: [repo root | path/to/subtree]
**Status**: completed | halted

---

### Executive Summary

3–5 sentences. Overall compliance posture in one paragraph. The biggest risks named explicitly. What must be resolved before launch or the next regulatory touchpoint. Briefing-document tone — actionable, not theatrical.

---

### Blockers

For each blocker:

#### [REGULATION] Art. XX: [Title]

**Finding**: one sentence.
**Evidence**: file path / config value / named absence of expected documentation.
**Remediation**: concrete action — not "add a privacy policy" but "add a RoPA listing the 4 processing activities identified in `src/analytics.ts`, `src/auth.ts`, `src/email.ts`, and the CRM integration".
**Effort**: hours / days / weeks.

Order by enforcement risk × likelihood, not alphabetically.

---

### Major Gaps

Same format as Blockers.

---

### Compound Risks

Surfaced by Phase 3 cross-correlation. Compound risks may pull together items already listed individually above — that is fine; the point is to make the combined exposure visible.

#### [Compound title]

**Components**: Finding A (GDPR Art. 28) + Finding B (GDPR Art. 30) + Finding C (GDPR Art. 33)
**Combined risk**: 3–5 sentences. Why the combination is worse than the sum of parts. Reference enforcement framing — "this combination is what the EDPB / Italian DPA / etc. characterise as accountability failure."
**Remediation path**: sequenced actions to clear the compound, not just each component independently.

---

### Minor Gaps

Condensed table format:

| Regulation | Article | Finding | Remediation sketch | Effort |
|---|---|---|---|---|
| GDPR | Art. 13 | Privacy notice names retired processor "Old SaaS Inc" | Update notice; replace with current vendor | hours |
| e-Privacy | Art. 5(3) | Cookie banner persists across sessions but withdrawal requires 3 clicks | Move "withdraw consent" to footer link, single-click toggle | days |

---

### Advisory

Bullet list. Emerging obligations, approaching deadlines, recommended best practices, voluntary measures. Non-EU regimes noted as out-of-scope go here.

- AI Act high-risk system registration in the EU database — open from Aug 2026. Plan the registration workflow now.
- UK GDPR likely applies to UK users; compliance-panel does not cover it. Engage UK counsel for a separate review.
- Consider DPF re-certification check before the next adequacy review.

---

### Documentation Inventory

What compliance documentation was found versus expected.

| Document | Status | Notes |
|---|---|---|
| Privacy Policy | ✓ Found | `docs/privacy.md`, updated 2026-01 |
| Records of Processing Activities (RoPA) | ✗ Missing | Required under Art. 30; flagged blocker above |
| Data Processing Agreements (DPAs) | ⚠ Incomplete | 2/4 expected processors covered; see major gap "DPA gap" |
| Data Protection Impact Assessment (DPIA) | ✗ Missing | Recommended (`dpia-assessor` advisory) — high-risk processing detected |
| Cookie Policy | ✗ Missing | e-Privacy needs a separate cookie notice or equivalent in the privacy policy |
| AI System Technical Documentation | ✗ Missing | Required under AI Act Art. 11 for high-risk system in `src/ai/classifier.ts` |
| Incident Response Plan | ✓ Found | `docs/security/ir-plan.md` — covers GDPR Art. 33 and NIS2 Art. 23 paths |
| Cybersecurity Risk Management Framework | ⚠ Partial | Covers 7/10 NIS2 Art. 21(2) areas |

---

### Clean Checks

Regulations or articles explicitly reviewed by the assessors and found compliant. Each is a real result — omission would be ambiguous (did no assessor check, or did they check and find nothing?).

- **GDPR Art. 32 (security of processing)**: encryption at rest (AES-256 via AWS KMS), in transit (TLS 1.3 enforced), access control via SSO + MFA — reviewed and adequate.
- **NIS2 Art. 23 (incident reporting)**: process documented in `docs/security/ir-plan.md` lines 42–80; 24h / 72h / 1-month timeline matched.
- **e-Privacy Art. 6 (traffic data)**: no traffic-data processing beyond billing-required minimum — adequate.
- **Data Act**: out of scope (no IoT, no connected products, no cloud-service-provider status detected).

---

### Scope Gaps

Regulations or surfaces that were not reviewed in this run. Causes: assessor spawn failure, scope narrowing, regulation out of scope per in-scope determination.

- `bcr-assessor`: not activated (no intra-group international transfers detected).

---

### Disclaimer

This report is generated by an automated compliance review tool (`compliance-panel`). It is **not legal advice** and does not constitute a formal compliance audit. Findings are based on the contents of the repository and project documentation at the time of review; they do not reflect operational practice that lives outside the codebase, member-state-specific derogations, enforcement-authority guidance, or sectoral overlays.

Regulatory interpretation varies by jurisdiction, enforcement context, and business model. Engage a qualified Data Protection Officer (DPO), privacy lawyer, or regulatory consultant before relying on these findings for compliance decisions, regulatory submissions, or representations to customers and partners.

Scope is limited to the named EU regulations (GDPR, e-Privacy, NIS2, AI Act, Data Act). Non-EU regimes — UK GDPR, US state privacy laws, LGPD, PIPEDA, etc. — are explicitly out of scope. A "clean" Compliance Panel report does not imply compliance with any non-EU regulation.
