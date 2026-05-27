# Compliance checklist

Master methodology checklist for the `compliance-panel` assessors. Each assessor uses the items relevant to its regulation as a hard-floor methodology — every item is applied to a finding, marked compliant (clean check), or marked not-applicable with rationale.

This is not a substitute for `regulation-summaries.md` (the conceptual map) or `ai-act-risk-classifier.md` (the AI tier decision tree). It's the working tick-list assessors run through to ensure coverage.

---

## GDPR (15 items)

1. **Lawful basis documented for every processing activity** (Art. 6) — and special-category extra basis (Art. 9) where applicable.
2. **Privacy notice present and accurate** (Arts. 13–14) — surfaced at point of collection, covers all required information.
3. **Data subject access path** (Art. 15) — endpoint or process to fulfil SAR within 1 month.
4. **Erasure path** (Art. 17) — soft-delete with hard-delete schedule; third-party processor cascade.
5. **Portability path** (Art. 20) — structured, commonly used, machine-readable format.
6. **Records of Processing Activities** (Art. 30) — exists, covers every processing activity, kept current.
7. **Data Processing Agreement signed with each processor** (Art. 28) — including sub-processor flow-down clauses.
8. **International transfer mechanism** (Arts. 44–50) — adequacy / SCCs / BCRs / Art. 49 derogation, documented per recipient.
9. **Privacy by Design and by Default** (Art. 25) — minimisation, purpose limitation, retention limits implemented in code/architecture, not just policy.
10. **Security of processing** (Art. 32) — encryption at rest and in transit, access control, backup, regular testing.
11. **Breach detection and notification path** (Arts. 33–34) — detection coverage, 72h DPA notification process, individual notification trigger and template.
12. **Data Protection Impact Assessment** (Art. 35) — completed for high-risk processing (see DPIA section below).
13. **Data Protection Officer designated** (Art. 37) — if required by core-activity criteria.
14. **Consent quality** (Art. 7) — freely given, specific, informed, unambiguous, withdrawable, documented with timestamp.
15. **Children's data protections** (Art. 8) — age verification, parental consent for under-16 (or member-state floor) where the service is an information-society service targeting children.

---

## e-Privacy Directive (8 items)

16. **Consent before non-essential cookies** (Art. 5(3)) — including analytics, advertising, fingerprinting.
17. **Consent banner UX**: reject as easy as accept (no dark patterns), no pre-ticked boxes, no scroll-as-consent.
18. **"Strictly necessary" cookies correctly scoped** — not over-claiming necessity for advertising/analytics.
19. **Cookie inventory accurate** — every cookie listed with purpose, retention, party (first / third), and category.
20. **Consent state respected across pages and sessions** — withdrawal possible at any time, same ease as grant.
21. **Tracking pixels and fingerprinting under consent** — not "legitimate interest" claims.
22. **Marketing communications opt-in** for non-customer prospects (Art. 13).
23. **Soft opt-in for existing customers** documented — similar products only, opt-out at every send.

---

## NIS2 Directive (10 items)

24. **In-scope determination** (Arts. 2–3) — entity type and size against Annex I/II, plus sectoral overlays.
25. **Risk-management measures documented and proportionate** (Art. 21) — covers all 10 named areas: incident handling, business continuity, supply chain security, network and information system security, vulnerability handling, cryptography, access control, asset management, basic cyber hygiene, MFA / continuous authentication.
26. **Incident detection coverage** for the systems in scope.
27. **Incident reporting path** — 24h early warning, 72h incident notification, 1-month final report (Art. 23).
28. **Vulnerability disclosure policy** published and reachable.
29. **Supply chain risk assessment** for critical ICT services.
30. **Business continuity plan** including backup, recovery, crisis management.
31. **Management body cybersecurity training** evidenced.
32. **Cryptography policy** appropriate to the system's risk profile.
33. **European cybersecurity certification scheme** used where applicable (Art. 24).

---

## EU AI Act (12 items)

34. **AI system inventory** — every AI system catalogued (use `ai-act-risk-classifier.md`).
35. **Prohibited-practice check** (Art. 5) — none of the 8 categories present.
36. **Risk tier classified** per system (high-risk, limited-risk, minimal-risk, GPAI).
37. **For high-risk: risk-management system** (Art. 9) in place.
38. **For high-risk: data governance** — training/validation/test data quality (Art. 10).
39. **For high-risk: technical documentation** complete per Annex IV (Art. 11).
40. **For high-risk: logging** of operations to ensure traceability (Art. 12).
41. **For high-risk: transparency to deployers** (Art. 13).
42. **For high-risk: human oversight measures** appropriate to risk (Art. 14).
43. **For high-risk: accuracy, robustness, cybersecurity** (Art. 15).
44. **For high-risk: conformity assessment + EU database registration** (Arts. 43, 49).
45. **Limited-risk transparency obligations** (Art. 50) — chatbots, deepfakes, AI-generated text disclosure.

For GPAI providers/deployers, also:

- **GPAI Art. 53 obligations** — training-data summary, technical documentation, copyright compliance, downstream-provider information.
- **Systemic-risk GPAI Art. 55** — evaluations, adversarial testing, serious-incident reporting, cybersecurity.

---

## Data Act (6 items, applies only if in scope)

46. **In-scope determination** — connected product, related service, data processing service provider, or B2B data-sharing party.
47. **User data access mechanism** for connected products (Art. 4).
48. **Third-party data sharing at user request** (Art. 5).
49. **B2B contract fairness** (Art. 13) — none of the listed unfair terms against SMEs.
50. **Cloud switching obligations** (Arts. 23–31) — portability, switching periods, egress-fee phase-out by 2027.
51. **B2G data sharing process** for exceptional circumstances (Arts. 14–22).

---

## DPIA (opt-in, applies on Art. 35 trigger — 5 items)

52. **DPIA triggers identified** — Art. 35(3) list plus member-state DPA blacklists.
53. **DPIA conducted with required content** — Art. 35(7): processing description, necessity and proportionality, risks to rights and freedoms, mitigations.
54. **DPO consulted** on the DPIA (Arts. 35(2), 39(1)(c)).
55. **Prior consultation with DPA** triggered where high residual risk remains (Art. 36).
56. **DPIA reviewed periodically** and on material change.

---

## BCRs (opt-in, applies on intra-group transfer — 4 items)

57. **BCRs in place and approved** by competent DPA (Art. 47), or an alternative mechanism documented for each transfer route.
58. **Group structure and entities listed** in the BCR documentation.
59. **Enforceable rights for data subjects** under the BCRs.
60. **BCRs aligned with current group transfer flows** — last review date, scope of approved transfers, any new entities or transfer paths not yet covered.
