# MEMORY.md — Long-Term Memory

## Active Projects

### Actually Useful AI (formerly FastClaw)
- **What:** Managed AI assistant hosting for non-techies. "Your Own AI Assistant in 60 Seconds."
- **Domain:** actually-useful-ai.com (primary), fastclaw.app (secondary)
- **Repo:** `jamesalmeida/actually-useful-ai` (local: `~/dev/actually-useful-ai`)
- **Docker repo:** `jamesalmeida/fastclaw-gateway` (PUBLIC, local: `~/dev/fastclaw-gateway`)
- **Stack:** Next.js 15, Tailwind, Convex (auth + data), Vercel (Arkham Ventures team)
- **Convex:** dev `elated-gecko-980`, prod `ideal-ferret-88`
- **Auth:** Convex Auth (Google OAuth + email/password) — working
- **Pricing:** Basic $9/mo (BYOK), Pro $29/mo (1-day free trial, Kimi K2 included), Premium $59/mo (coming soon)
- **Stripe:** Integrated! Checkout with Link, webhooks, billing portal. Sandbox: "Violet Beam"
- **Status (Feb 10):** **Phases 1-5 COMPLETE** — end-to-end working! Sign up → Stripe → Railway provisioning → live instance
- **Next:** Phase 6 — Channel onboarding (WhatsApp QR, Telegram, web chat)
- **Key architecture:** Loopback + reverse proxy to bypass OpenClaw device pairing. Gateway on 127.0.0.1:18789, http-proxy on :8080 strips headers. Railway sees local connections.
- **Docker image:** ghcr.io/jamesalmeida/fastclaw-gateway:latest (multi-arch, PUBLIC on GHCR)
- **Railway API token:** c04dd483-d28e-460d-bdf4-7452d4a5f13a (stored in Vercel env vars)
- **Default AI model:** Kimi K2 (all tiers currently)
- **SEO:** Added OpenClaw/ClawdBot keywords, FAQ section, comparison section
- **Social proof toast:** Fake purchase notifications, toggle via /admin (pw: planets-mgm-TEMPER)
- **Competitor:** openclaw.new — selling hosted OpenClaw, ranks high for "openclaw" searches
- **Detailed docs:** `~/dev/actually-useful-ai/docs/` (roadmap, architecture, pricing)
- **Obsidian docs:** `~/Obsidian-Vault/1 - Projects/FastClaw/`
- **Workflow:** GitHub issues → Codex → auto-merge to main (rapid iteration mode)
- **IMPORTANT:** Merging to main deploys to Vercel but does NOT deploy Convex functions. Must run `npx convex deploy --yes` separately (or `CONVEX_DEPLOYMENT=ideal-ferret-88 npx convex deploy --yes` from worktrees)
- **Admin auth caveat:** Admin page uses client-side password (`planets-mgm-TEMPER`), NOT Convex auth. Don't use `requireAdmin()` in Convex functions called from admin. Issue #29 tracks fixing this.
- **Vercel env vars:** Must enable Preview checkbox for `NEXT_PUBLIC_CONVEX_URL` — otherwise preview branch deploys fail
- **Open issues:** #26 (system theme default), #29 (secure admin with Convex auth)

### FastClaw iOS App (PAUSED)
- **Repo:** `jamesalmeida/fastclaw` (local: `~/dev/fastclaw`)
- **Status:** Paused — OpenClaw launching their own iOS app. Revisit as add-on later.
- **Convex:** dev `savory-goldfinch-108` (will consolidate with web later)
- **Note:** Uncommitted ChatListView.swift changes — preserve before any cleanup

### IAS Consulting
- **Client:** IAS (International Assembly Solutions)
- **S-Corp:** james@almeida.ventures
- **Key contacts:** Cam Stapelfeld (Oracle/NetSuite), Abdo Sauma, Jason Buist
- **Current:** Oracle NetSuite migration — fixed-bid SOW ready, need 1-hour review call with Jason+Abdo
- **AFC subsidiary** — handled natively in NetSuite (parent-child hierarchy, inter-company transactions)
- **Next step:** Email sent (draft in almeida.ventures) to schedule SOW review meeting
- **Obsidian notes:** `1 - Projects/IAS Consulting/2026-02-10 Cam Stapelfeld Call Notes.md`

### Konteks
- **Web repo:** `jamesalmeida/konteks-web`
- **Open PRs to test:** #25, #28, #29, #30, #31, #32, #33

## James's Goals
- Avoid traditional 9-5 employment
- Building toward $10k/mo residual income
- AI consulting (1 client: IAS)
- Actually Useful AI as SaaS play
- S-Corp business entity

## Key Preferences
- Codex CLI for coding (not Claude Code)
- Private repos by default
- Vercel → Arkham Ventures team
- Domains on Cloudflare, proxy OFF for Vercel
- Acknowledge tasks immediately before starting work
- Direct on main for rapid prototyping, branches+PRs for features
