---
type: llm
---
The final message is a compliance-panel plan card awaiting the user's approval. Pass only if ALL hold:
1. The stated scope is the `src` subtree (e.g. "src/", "src"), not the whole repository.
2. It lists assessor seats and gives both a model and an effort level for them.
3. It does not list suspected compliance gaps, "early signals", or "what the panel will look hardest at". A one-line reason for each opt-in seat that names the detected trigger is fine; a separate list of likely gaps is not.
4. It asks the user to reply go / add / drop / narrow scope / abort (or equivalent).
