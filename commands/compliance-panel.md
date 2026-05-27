---
description: Multi-agent EU digital compliance review by independent specialist assessor agents
argument-hint: [scope-path]
---

Invoke the `compliance-panel` skill on the current project.

**Scope**: $ARGUMENTS

If the scope above is empty, treat the entire repository at the current working directory as the review scope. If the scope is a path, narrow the assessment fan-out to that subtree only — but still load `CLAUDE.md`, package manifests, and any compliance documentation (`privacy-policy.md`, `dpa.md`, `ropa.md`, `dpia.md`, cookie policy, etc.) from the repo root, since regulatory scope crosses subtree boundaries.

Begin with Phase 0 (plan card) before spawning any agents. Do not skip the plan card even though the slash command was explicit; the user still needs to confirm roster, opt-in seats, and budget.
