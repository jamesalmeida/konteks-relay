# MEMORY.md — Long-Term Memory

## Mission Statement
> **Build sustainable income streams that free James from the 9-to-5 trap — by shipping real products, not just starting them.**

- IAS consulting pays the bills now — protect and grow it
- Sheldn.ai is the residual income play — get it to paying customers
- Tersono handles the overhead so James can hyperfocus on building
- We finish things — the last 10% is where the money is
- North star: **$10k/month so Lauren has options**
- Everything we do should ladder up to that or get cut

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
- **Status (Feb 12):** **Phases 1-5 COMPLETE + major polish** — 11 issues closed in one day
- **Working flow:** Sign up → Stripe checkout (1-day trial for Pro) → Railway auto-provision → Dashboard shows token → One-click open AI assistant
- **Next:** Phase 6 — Channel onboarding (WhatsApp QR, Telegram, web chat)
- **Recent fixes (Feb 12):** Unique Railway domains per user, tier upgrade via subscription update (not new checkout), cancellation display, delete account flow, email normalization, Google OAuth email storage, PORT conflict fix
- **Key architecture:** Loopback + reverse proxy to bypass OpenClaw device pairing. Gateway on 127.0.0.1:18789, http-proxy on :8080 strips headers. Railway sees local connections.
- **Docker image:** ghcr.io/jamesalmeida/fastclaw-gateway:latest (multi-arch, PUBLIC on GHCR)
- **Railway API token:** c04dd483-d28e-460d-bdf4-7452d4a5f13a (stored in Vercel env vars)
- **Default AI model:** Kimi K2 (all tiers currently)
- **SEO:** Added OpenClaw/ClawdBot keywords, FAQ section, comparison section
- **Social proof toast:** Fake purchase notifications, toggle via /admin (pw: planets-mgm-TEMPER)
- **Competitor:** openclaw.new — selling hosted OpenClaw, ranks high for "openclaw" searches
- **Detailed docs:** `~/dev/actually-useful-ai/docs/` (roadmap, architecture, pricing)
- **Obsidian docs:** `~/Obsidian-Vault/1 - Projects/actually-useful-ai.com/`
- **Workflow:** GitHub issues → Codex → auto-merge to main (rapid iteration mode)
- **IMPORTANT:** Merging to main deploys to Vercel but does NOT deploy Convex functions. Must run `npx convex deploy --yes` separately (or `CONVEX_DEPLOYMENT=ideal-ferret-88 npx convex deploy --yes` from worktrees)
- **Admin auth caveat:** Admin page uses client-side password (`planets-mgm-TEMPER`), NOT Convex auth. Don't use `requireAdmin()` in Convex functions called from admin. Issue #29 tracks fixing this.
- **Vercel env vars:** Must enable Preview checkbox for `NEXT_PUBLIC_CONVEX_URL` — otherwise preview branch deploys fail
- **Open issues:** #29 (secure admin), #20 (support email), #19/#39 (Google OAuth for customers), #13 (logos), #12 (scarcity meter), #10 (Phase 6 channels), #6/#5 (social proof)

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

### Sheldn.ai (rebranded from Actually Useful AI)
- **Domain:** sheldn.ai (registered Feb 16), also actually-useful-ai.com
- **Registered on Cloudflare**, Google Search Console verified
- See Actually Useful AI section above for technical details

### Mercury Rx iOS App
- Close to App Store ready — needs final push
- Learning experience for IAP process
- Classic "last 10%" stall

### Other Projects
- **Echo Horizon AI Task Force** — Julian's school, volunteer
- **St. Mary's church + Mexico Mission Trip websites** — promised to mom, small paying gig
- **Memex iOS app** — back burner
- **Content creation (YouTube/X)** — prefers one-take style

## Discovery Interview (Feb 17, 2026)
Completed full 30-question interview. Key insights saved to USER.md.

### Critical Patterns
- **All-or-nothing personality** — hyperfocus or nothing, loves 0-90%, hates last 10%
- **Context-switching kills him** — needs long uninterrupted blocks (best window: 9am-3pm)
- **Level 1 ASD** — diagnosed ~34-35. Craves order, predictability, logic. Sensory sensitivities.
- **Deadlines stress him but he needs them** — creates the pressure to break through executive function barriers
- **Reminders are welcome** — both Lauren and I should nudge him. Not nagging.
- **Consolidated to 3 systems** (Feb 19, 2026): Google Calendar (3 accounts), Things 3 (tasks), Obsidian (notes). Dropped Notion, Konteks, Memex, iOS Notes.

### Family Dynamics
- Lauren stressed about finances since James left 9-5
- They used to do biweekly sprint standups — fell off, should restart
- Lauren doesn't always know what James is working on — communication gap
- Regina (Lauren's mom) is critical childcare support but getting fragile (70s, recent fall)
- Suhayl (Lauren's dad) founded IAS — makes the consulting pay conversation complicated (family)
- Suhayl pays for kids' school — huge financial help

### Health
- Was 239lbs → got down to 200lbs via calorie counting → regained after xAI layoff
- Possible fatty liver concern (scan clear but after weight loss)
- Turning 40 on May 22 — wants comprehensive wellness check (medical tourism research task created)
- All-or-nothing with health habits

### Financial
- $2.6M investment account, ~4.49 BTC
- Target: $10k/mo income ($120k/year)
- Wants to rename Arkham Ventures → GSV (gsv.to registered, paperwork pending)
- Needs capital gains tax strategy for 2026

### What He Wants From Me
1. Task consolidation across fragmented systems
2. Priority advisor — help pick highest-ROI work each day
3. Memory/reminder system for things that fall through cracks
4. Email watchdog — especially IAS/client communications
5. Coding partner via Codex
6. Executive function support
7. Be proactive — anticipate needs
8. Handle overhead so he can hyperfocus

## James's Goals
- Avoid traditional 9-5 employment
- Building toward $10k/mo residual income
- AI consulting (1 client: IAS)
- Sheldn.ai as SaaS play
- S-Corp business entity (Arkham Ventures → GSV rename in progress)

## Key Preferences
- Codex CLI for coding (not Claude Code)
- Private repos by default
- Vercel → Arkham Ventures team
- Domains on Cloudflare, proxy OFF for Vercel
- Acknowledge tasks immediately before starting work
- Direct on main for rapid prototyping, branches+PRs for features
- Direct feedback, no sycophancy
- Disagree with reasoning, no hedging
