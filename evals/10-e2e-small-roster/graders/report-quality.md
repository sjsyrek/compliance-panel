---
type: llm
---
The final message is a draft compliance report preview for this repo. Pass only if ALL hold:
1. It reports that the `mp_id` tracking cookie is set on first request before any consent, citing the e-Privacy Directive Art. 5(3) and src/server.js.
2. It reports that customer name, email and message are sent to OpenAI (a US-region processor per config/processors.yaml) and raises the international-transfer and/or processor-agreement gap under GDPR.
3. It reports the automated CLOSE verdict that suspends accounts with no human review, citing GDPR Art. 22 and/or AI Act human-oversight obligations.
4. It includes the not-legal-advice disclaimer.
5. Findings are worded as observed gaps with remediation steps, not as legal conclusions ("you are in violation of…").
6. It ends by asking the user to save, amend, or discard (or equivalent) rather than claiming the report was saved.
