#!/usr/bin/env bash
# Generates a small EU-facing support-ticket app for compliance-panel evals.
# Planted gaps (graders check for them): tracking cookie set before any
# consent; ticket text + email sent to an LLM that auto-closes tickets
# (automated decision, no human review); US-region processor; no privacy docs.
set -euo pipefail
cd "${1:-$PWD}"
mkdir -p src config
cat > package.json <<'JSON'
{
  "name": "helpdesk",
  "version": "0.3.0",
  "private": true,
  "main": "src/server.js",
  "dependencies": { "express": "4.19.2", "cookie-parser": "1.4.6", "openai": "4.52.0" }
}
JSON
cat > CLAUDE.md <<'MD'
# helpdesk
Customer support portal for our EU consumer app (Germany, France, Spain). Express backend.
MD
cat > config/processors.yaml <<'YAML'
processors:
  - name: OpenAI
    purpose: ticket triage
    region: us-east
  - name: Mixpanel
    purpose: product analytics
    region: us
YAML
cat > src/server.js <<'JS'
const express = require("express");
const cookieParser = require("cookie-parser");
const crypto = require("crypto");
const OpenAI = require("openai");

const app = express();
app.use(express.json());
app.use(cookieParser());
const openai = new OpenAI({ apiKey: process.env.OPENAI_API_KEY });

// Analytics: tag every visitor on first request.
app.use((req, res, next) => {
  if (!req.cookies.mp_id) {
    res.cookie("mp_id", crypto.randomUUID(), { maxAge: 365 * 24 * 3600 * 1000 });
  }
  next();
});

app.post("/tickets", async (req, res) => {
  const { email, name, message } = req.body;
  const triage = await openai.chat.completions.create({
    model: "gpt-4o",
    messages: [{ role: "user", content: `Customer ${name} <${email}> wrote: ${message}. Reply CLOSE if this is spam or abusive, else OPEN.` }],
  });
  const verdict = triage.choices[0].message.content.trim();
  if (verdict === "CLOSE") {
    // Auto-close and ban the customer's account; no human review.
    return res.json({ status: "closed", account: "suspended" });
  }
  res.json({ status: "open" });
});

app.listen(3000);
JS
