---
type: llm
---
standard: v1 (card standard, claude-plugins/docs/card-standard.md, Grader section; layout only, the content graders check what the card says)

The final message's plan card follows the card standard v1. Pass only if ALL hold:
1. The card is not inside a code fence.
2. It starts with a bold title line naming the plugin (Compliance Panel), then an em dash and the mode or scope.
3. Single values are a bulleted list with bold labels.
4. Seats or findings, if listed, are a markdown table with a header row.
5. It contains no hand-drawn box characters and no `=====` underline.
6. When the card asks for a reply, its last line starts with `Reply:` and lists the plugin's verbs, each in backticks, separated by `|`.
