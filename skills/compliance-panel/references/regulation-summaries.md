# Regulation summaries

Quick-reference summaries for the five EU digital regulations covered by `compliance-panel`. Assessors load this file to ground their analysis. For decision-tree classification of AI systems, see `ai-act-risk-classifier.md`. For the working tick-list, see `compliance-checklist.md`.

---

## GDPR — General Data Protection Regulation (Regulation 2016/679)

**Scope.** Any processing of personal data of individuals in the EU/EEA, regardless of where the controller or processor is established. "Personal data" = any information relating to an identified or identifiable natural person.

**Enforcement body.** National data protection authorities (DPAs); coordinated through the European Data Protection Board (EDPB).

**Fine regime.** Up to €20M or 4% of global annual turnover, whichever is higher, for serious infringements (Art. 83(5)). Lower tier: up to €10M / 2% (Art. 83(4)).

**Key obligations for software products.**

- **Lawful basis** (Art. 6) for every processing activity — and a separate special-category basis (Art. 9) for health, biometric, genetic, political, religious, sexual orientation, etc.
- **Transparency** (Art. 13–14) — privacy notice at collection time covering all required elements
- **Data subject rights** (Art. 15–22) — access, rectification, erasure, portability, restriction, objection, automated-decision rights
- **Records of Processing Activities** (RoPA, Art. 30)
- **Data Processing Agreement** with every processor (Art. 28), with sub-processor flow-down
- **Data Protection Impact Assessment** (DPIA, Art. 35) for high-risk processing
- **Privacy by Design and by Default** (Art. 25)
- **Security of processing** (Art. 32) — encryption, access control, resilience, testing
- **Breach notification** (Art. 33–34) — 72 hours to DPA; "without undue delay" to affected individuals if high risk
- **International transfers** (Arts. 44–50) — adequacy decision, SCCs, BCRs, or narrow Art. 49 derogations
- **Data Protection Officer** (Art. 37) if core activities require systematic monitoring or large-scale special-category processing

**Most-cited articles for software:** Art. 5 (principles), Art. 6 (lawful basis), Art. 25 (PbD), Art. 28 (processors), Art. 30 (RoPA), Art. 32 (security), Art. 33 (breach), Art. 35 (DPIA).

---

## e-Privacy Directive (2002/58/EC, as amended)

**Scope.** Electronic communications in the EU. The cookie law lives here (Art. 5(3)). The proposed e-Privacy Regulation has been pending since 2017; the directive is still in force and transposed into national law in every member state.

**Enforcement body.** National DPAs in most member states; national telecoms regulators also have a role.

**Fine regime.** Member-state-specific (no harmonised cap like GDPR). In practice, e-Privacy violations are often pursued under GDPR Art. 6 (no lawful basis for cookie-set processing) for headline-grabbing fines.

**Key obligations for software products.**

- **Storing or accessing information on a user's device requires prior consent** (Art. 5(3)), except for cookies "strictly necessary" for a service the user actively requested
- **Consent must meet the GDPR standard** — freely given, specific, informed, unambiguous, withdrawable, opt-in not opt-out, reject as easy as accept
- **Marketing communications opt-in** for non-customer prospects (Art. 13)
- **Soft opt-in** allowed for similar products to existing customers
- **Confidentiality of communications** — no interception or traffic-analysis without consent

**Most-cited articles for software:** Art. 5(3) (cookies / device storage), Art. 6 (traffic data), Art. 13 (marketing communications).

**Common pitfalls.** Pre-ticked consent boxes; scroll-as-consent; accept-all easier than reject-all; cookies set on the same request that renders the banner; analytics under "legitimate interest" claims (rejected by most EU DPAs); consent state not persisted; withdrawal harder than grant.

---

## NIS2 — Network and Information Security Directive 2 (Directive 2022/2555)

**Scope.** "Essential" and "important" entities operating in the EU. Includes (non-exhaustive): cloud providers, data centres, content delivery networks, managed service providers, online marketplaces, search engines, social platforms, digital infrastructure, public administrations, healthcare, transport, energy, water, postal/courier, food, manufacturing of critical products. Transposition deadline was October 2024.

**Enforcement body.** National cybersecurity authorities (CSIRTs / NCAs); coordinated through ENISA.

**Fine regime.** Essential entities: up to €10M or 2% of global annual turnover. Important entities: up to €7M or 1.4%. Some member states have introduced personal liability for management bodies.

**Key obligations for software products in scope.**

- **Cybersecurity risk-management measures** proportionate to risk (Art. 21) — covers 10 named areas: incident handling, business continuity, supply chain security, network and information system security, vulnerability disclosure and handling, cryptography, access control, asset management, basic cyber hygiene, MFA / continuous authentication
- **Incident reporting** (Art. 23): early warning within 24 hours, incident notification within 72 hours, final report within 1 month
- **Management body** approves and oversees cybersecurity measures; training obligations
- **Supply chain risk assessment** for critical ICT services and suppliers

**Most-cited articles for software:** Art. 21 (risk-management measures), Art. 23 (incident reporting), Art. 24 (European cybersecurity certification schemes).

**Scope determination is the first question.** If the entity is not in scope, most obligations don't apply directly — but supply-chain obligations of in-scope customers may flow downstream.

---

## EU AI Act (Regulation 2024/1689)

**Scope.** AI systems placed on the EU market, put into service in the EU, or whose output is used in the EU — regardless of where the provider or deployer is established. Also covers general-purpose AI models (GPAI). Phased entry into force: prohibitions Feb 2025; GPAI obligations Aug 2025; high-risk-system rules Aug 2026 (some extend to 2027).

**Enforcement body.** AI Office (European Commission) for GPAI; national market surveillance authorities for AI systems; European AI Board for coordination.

**Fine regime.** Up to €35M or 7% of global annual turnover for prohibited-practices violations; up to €15M / 3% for high-risk system violations; up to €7.5M / 1.5% for supplying incorrect information.

**Risk tiers.**

1. **Prohibited (Art. 5)** — e.g. social scoring by public authorities; real-time remote biometric ID in public spaces by law enforcement (narrow exceptions); manipulative systems exploiting vulnerabilities; emotion recognition in workplace/education (narrow exceptions); untargeted facial-image scraping; predictive policing on profiling alone; biometric categorisation inferring protected characteristics.
2. **High-risk (Art. 6, Annex III)** — biometrics; critical infrastructure; education access; employment decisions; access to essential services (credit, insurance); law enforcement; migration; democratic processes; some medical devices. Triggers conformity assessment, technical documentation, human oversight, accuracy/robustness, post-market monitoring, EU-database registration.
3. **Limited-risk (Art. 50)** — transparency obligations: chatbots disclose AI; deepfakes labelled; AI-generated content marked.
4. **Minimal-risk** — no specific obligations.
5. **GPAI models (Arts. 51–55)** — technical documentation, training-data summary, copyright compliance, transparency to downstream. Systemic-risk GPAI (≥10^25 FLOPs cumulative compute, or designated): model evaluations, adversarial testing, serious-incident reporting, cybersecurity.

**Most-cited articles for software:** Art. 5 (prohibited), Art. 6 + Annex III (high-risk classification), Art. 9 (risk management), Art. 10 (data governance), Art. 11 + Annex IV (technical documentation), Art. 13 (transparency), Art. 14 (human oversight), Art. 15 (accuracy/robustness), Art. 26 (deployer obligations), Art. 50 (transparency), Art. 53 (GPAI).

**Always run the classifier first.** Misclassifying the system invalidates the obligation analysis. See `ai-act-risk-classifier.md`.

---

## Data Act (Regulation 2023/2854)

**Scope.** Connected products (Art. 3 — IoT devices and related services); B2B and B2G data sharing; cloud-switching obligations for data processing service providers. Applies from September 2025.

**Enforcement body.** National competent authorities (varies by member state); European Data Innovation Board for coordination.

**Fine regime.** Member-state-specific; GDPR-aligned penalty levels for violations that overlap with personal-data processing.

**Key obligations for software products in scope.**

- **User data access** for connected products (Art. 4) — users can access data their device generates
- **Third-party sharing at user request** (Art. 5)
- **Contractual fairness** for B2B data-sharing contracts (Art. 13) — listed unfair terms unenforceable against SMEs
- **Cloud switching** (Arts. 23–31) — providers of data processing services must enable switching: data portability, contractual maxima on switching periods, ban on egress fees by 2027
- **B2G data sharing** in exceptional circumstances (Arts. 14–22)

**Most-cited articles for software:** Art. 3 (connected products), Art. 4 (user access), Art. 5 (third-party sharing), Art. 13 (B2B fairness), Arts. 23–31 (cloud switching).

**Activation rule.** The Data Act applies only to IoT/connected products and to cloud/data-processing service providers. The `data-act-assessor` runs an in-scope determination first; if neither is detected, it emits a single advisory clean check noting non-applicability. This is by design — the seat is always spawned, but its findings are bounded by scope detection.
