# AI Act risk classifier — decision tree

The `ai-act-assessor` runs this classifier as its first methodology step. Risk tier determines which obligations apply; misclassifying the system invalidates everything downstream.

Walk every detected AI component through Steps 1–6 in order. Emit one finding per system (even minimal-risk systems, so the report can show the AI inventory was assessed).

---

## Step 1 — Is it an AI system?

Art. 3(1): "A machine-based system designed to operate with varying levels of autonomy and that may exhibit adaptiveness after deployment, and that, for explicit or implicit objectives, infers, from the input it receives, how to generate outputs such as predictions, content, recommendations, or decisions that can influence physical or virtual environments."

**Yes if:** hosted LLM API call (OpenAI, Anthropic, Mistral, Cohere, etc.); local model inference (transformers, llama.cpp, ggml, vLLM); ML classifier in production (sklearn, XGBoost, neural network); recommendation system; speech/vision/biometric processing; embeddings + similarity search used for decisions.

**No if:** pure rule-based system with no learning; statistical aggregation (mean, percentile, regression as descriptive statistics); deterministic algorithm (sort, search, hash, cryptographic operations); database query or stored-procedure logic.

**Borderline cases:**
- *Static rule engines with no inference* → not an AI system.
- *Statistical models used for decisions (e.g. risk score from logistic regression)* → AI system.
- *Vector search alone* → not an AI system; *vector search driving a recommendation* → AI system in aggregate.

If **No** → AI Act does not apply to this component. Emit clean check, stop classifier.

---

## Step 2 — Is it a prohibited practice (Art. 5)?

Check against each prohibited category:

| Prohibition (Art. 5(1)) | Detect when |
|---|---|
| (a) Subliminal / manipulative techniques materially distorting behaviour, causing significant harm | Persuasion engines targeting unconscious decision-making; dark-pattern UX optimised against the user's interests |
| (b) Exploiting vulnerabilities of a person or group (age, disability, social/economic situation) | Targeting children, elderly, low-literacy or low-income users for behaviour change to their detriment |
| (c) Social scoring by public authorities (or by private parties on their behalf) leading to detrimental or unjustified treatment | Aggregate trustworthiness scoring across unrelated contexts driving access decisions |
| (d) Real-time remote biometric identification in publicly accessible spaces for law enforcement | Live face-rec deployed in a public space for police use (narrow Art. 5(2) exceptions only) |
| (e) Predictive policing based solely on profiling or personality traits | Crime risk scoring without an objectively verifiable predicate fact |
| (f) Emotion recognition in workplace and education settings | Affective computing applied to employees or students (limited Art. 5(1)(f) medical/safety exceptions) |
| (g) Biometric categorisation inferring race, political opinions, trade-union membership, religious or philosophical beliefs, sexual orientation | Classifier inferring protected characteristics from biometric data |
| (h) Untargeted scraping of facial images from the internet or CCTV for facial-recognition databases | Web/CCTV scraping building face-rec datasets |

**If any match → BLOCKER finding.** Prohibited practices cannot be remediated by documentation; they must be removed or the system redesigned. Cite Art. 5 paragraph + detection evidence.

---

## Step 3 — Is it a high-risk system (Art. 6, Annex III)?

Annex III categories:

| # | Category | Examples |
|---|---|---|
| 1 | Biometrics | Remote biometric ID; biometric categorisation; emotion recognition (where not prohibited) |
| 2 | Critical infrastructure | Safety components of road/rail/air/water/electricity/gas/digital infrastructure |
| 3 | Education and vocational training | Admission decisions; assessment scoring; behaviour monitoring during exams; learning-outcome evaluation |
| 4 | Employment, worker management | Recruitment screening; CV ranking; promotion/termination decisions; task allocation; performance and behaviour monitoring |
| 5 | Access to essential services | Eligibility for public benefits; credit scoring (except for fraud detection); life and health insurance pricing; emergency-response triage |
| 6 | Law enforcement | Risk assessment of natural persons; polygraph / similar tools; deepfake detection in evidence; profiling |
| 7 | Migration, asylum, border control | Risk assessment; polygraph; identity verification; asylum-claim examination assistance |
| 8 | Administration of justice and democratic processes | Researching/interpreting facts and law; influencing voting behaviour |

**Plus**: any AI system intended as a safety component of a product covered by EU product-safety harmonisation legislation (Annex I) — e.g. medical devices, machinery, toys.

**If any match → high-risk obligations apply.** Confirm the system does not fall under the Art. 6(3) exemption (system performs a narrow procedural task, improves the result of a previously completed human activity, detects deviations from prior decision patterns without replacing or influencing them without proper human review, or performs a preparatory task). The Art. 6(3) exemption is narrowly construed by the AI Office; default to high-risk if uncertain.

**High-risk obligations (selected, Chap. III Section 2):**

- Risk-management system (Art. 9) — continuous, iterative, throughout lifecycle
- Data governance: training, validation, testing data quality (Art. 10)
- Technical documentation (Art. 11, Annex IV) — extensive, including data sources, system architecture, performance metrics
- Logging of operations sufficient for traceability (Art. 12)
- Transparency and provision of information to deployers (Art. 13)
- Human oversight measures appropriate to the risk (Art. 14)
- Accuracy, robustness, cybersecurity (Art. 15)
- Quality management system for providers (Art. 17)
- Conformity assessment (Art. 43) before placing on market
- Registration in EU database (Art. 49) for Annex III high-risk
- Post-market monitoring (Art. 72)
- Serious-incident reporting (Art. 73) — 15 days standard; 2 days for widespread infringement; 10 days for death/serious harm

**Deployer obligations (Art. 26)** apply separately if the user is *deploying* a high-risk system built by someone else. Includes human-oversight assignment, input-data quality (where deployer controls it), monitoring, and — for public authorities or some private deployers — Fundamental Rights Impact Assessment (Art. 27) before first use.

---

## Step 4 — Limited-risk transparency obligations (Art. 50)

Applies regardless of high-risk classification:

- **Chatbots and conversational AI** — users must be informed they are interacting with an AI system, unless obvious from circumstances and context.
- **Emotion recognition or biometric categorisation** (where permitted) — subjects must be informed of operation.
- **Deepfakes / AI-generated synthetic content** — must be marked as artificially generated or manipulated. Narrow exceptions for clearly artistic, creative, satirical, or fictional content (still subject to member-state law).
- **AI-generated text published to inform the public on matters of public interest** — must be labelled (exception for editorially reviewed content under human responsibility).

---

## Step 5 — GPAI obligations (Arts. 51–55)

Applies if the system *uses* a general-purpose AI model (not just an AI system built on top), or if you are the *provider* of a GPAI.

**All GPAI providers (Art. 53):**

- Technical documentation of the model
- Information for downstream providers (capabilities, limitations, integration guidance, training-process summary)
- Publicly available summary of training data, sufficient for rightsholders to assess
- Policy to comply with EU copyright law — including respecting rightsholder reservations under Directive 2019/790 Art. 4(3)
- (Open-source GPAI not classified as systemic-risk: lighter regime under Art. 53(2))

**Systemic-risk GPAI** (≥10^25 FLOPs cumulative training compute, or Commission-designated under Art. 51):

- Model evaluations against state-of-the-art protocols (red-teaming, adversarial testing)
- Systemic-risk assessment and mitigation
- Serious-incident reporting to the AI Office
- Adequate cybersecurity protection for the model and physical infrastructure

**Deployers using a GPAI** must comply with the downstream-provider obligations passed through, plus their own transparency duties to end users.

---

## Step 6 — Document the classification

Emit one finding per AI system identified — even minimal-risk systems get a finding so the report shows the AI inventory was assessed.

```json
{
  "id": "ai-act-<6char-hex>",
  "regulation": "AI Act",
  "article": "Art. 6 — High-risk classification | Art. 5 — Prohibited | Art. 50 — Transparency | Art. 53 — GPAI | Minimal-risk",
  "severity": "blocker | major | minor | advisory",
  "finding": "AI system [name/component] classified as [tier] under [article / Annex III category #]",
  "evidence": "src/ml/classifier.ts — sklearn LogisticRegression on credit-application inputs, output drives accept/reject (Annex III item 5, essential services)",
  "remediation": "Implement Art. 9 risk management; Art. 11 technical documentation per Annex IV; Art. 13 transparency to deployers; Art. 14 human oversight (review queue for borderline scores); conformity assessment per Art. 43 before placing on market",
  "effort": "weeks",
  "compound_potential": true
}
```

**Set `compound_potential: true` when:**

- AI system involves automated decision-making with legal effects (compounds with GDPR Art. 22)
- AI system processes large-scale special-category data (compounds with GDPR Arts. 9, 35 — DPIA likely required)
- AI system uses GPAI whose training data is opaque (compounds with GDPR Arts. 13/14 transparency duties)
- AI system is high-risk AND no human oversight is implemented (compounds with GDPR Art. 25 PbD failure)

The Chair uses these signals in Phase 3 cross-correlation to surface AI Act + GDPR compound exposure.
