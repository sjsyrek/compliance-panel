---
type: llm
---
The final message is a compliance-panel plan card that waits for the user's approval before any assessor runs. Pass only if ALL hold:
1. It names the scope (the repository root, or a path within it).
2. It lists the always-on assessor seats (gdpr-assessor, eprivacy-assessor, nis2-assessor, ai-act-assessor, data-act-assessor).
3. It gives a model for the seats AND an effort level (per seat or as a stated default). A model with no effort level fails this item.
4. It gives a rough budget (tokens and/or wall-clock time).
5. It does not list suspected compliance gaps, "early signals", or "what the panel will look hardest at". A one-line reason for each opt-in seat that names the detected trigger is fine; a separate list of likely gaps is not.
6. It asks the user to reply with go / add / drop / narrow scope / abort (or equivalent).
