---
name: seo-audit
description: Run a quick SEO audit on any URL. Checks meta tags, headings, images, performance indicators, and accessibility basics. Returns a formatted report with scores and recommendations.
metadata:
  { "openclaw": { "emoji": "🔍" } }
---

# SEO Audit Skill

Quick SEO audit for any URL. Use when asked to "audit", "check SEO", or "analyze a website".

## How to Use

1. Fetch the target URL using `web_fetch` (markdown mode)
2. Run the audit script: `node /Users/james/clawd/skills/seo-audit/audit.mjs <URL>`
3. Present the results in a clean, readable format

## What It Checks

- **Meta tags:** title, description, og:image, canonical, viewport
- **Headings:** H1 presence, heading hierarchy
- **Images:** alt text coverage
- **Links:** broken internal links, external link count
- **Performance indicators:** page size estimate, render-blocking hints
- **Accessibility:** lang attribute, form labels, color contrast hints
- **Mobile:** viewport meta, responsive indicators
- **Security:** HTTPS, mixed content warnings

## Output Format

Present as a report card with letter grades (A-F) per category and specific recommendations. Keep it punchy — this is meant to impress in a demo setting.

## Fallback

If the audit script isn't available, do a manual audit using `web_fetch` to grab the page, then analyze the HTML yourself for the items above. You have the knowledge to do this without a script.
