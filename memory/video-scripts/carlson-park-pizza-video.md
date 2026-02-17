# Video Script: "Idea to Live Website in 10 Minutes with AI"

## Concept
Show how James went from a real-world need (neighborhood organizing) to a fully deployed website with database backend — just by talking to his AI assistant via WhatsApp voice messages.

## The Hook (0:00-0:15)
> "I built a fully functional website with a database, deployed to production, in under 10 minutes. And I didn't write a single line of code — I just sent voice messages from my couch."
>
> *[Show the finished site: carlson-park-pizza.vercel.app]*

## The Setup (0:15-0:45)
- Quick context: "I run an AI assistant called OpenClaw on my Mac Mini. It's always on, always listening for my messages."
- "My neighborhood has this pizza truck that comes every Wednesday — Windsor Hills Pizza. They got hit with a code violation and might lose their spot. The neighborhood wanted to organize."
- "So I grabbed my phone and just... told my AI what I needed."

## The Build — Real Conversation Flow (0:45-4:00)
*[Screen recording of WhatsApp conversation + live site updating]*

### Message 1 — The Ask (18:14 PST)
> James (voice message): "We need a landing page that's gonna take people's email addresses... the pizza place has been here for four years but they got dinged for a code violation... we want a landing page to explain the situation and let people put in their email address..."

- **AI responds instantly:** "Love it — community organizing, let's go." Confirms the plan: hero section, email signup, CTA, mobile-friendly.
- Asks one clarifying question: domain name?

### Message 2 — The Name (18:15)
> James: "CarlsonParkPizza"

- AI creates the GitHub repo, scaffolds Next.js app, builds the page, deploys to Vercel
- **Site is LIVE in ~2 minutes**

### Message 3 — Real Details (18:16)
> James sends a photo of a neighborhood sign with all the details

- AI reads the image, extracts the key facts (300ft rule, Dan O'Brien's council request, upcoming vote)
- Updates the copy with real information
- Redeploys automatically

### Message 4 — Database (18:21)
> James: "What about the email input? Can you connect it to Supabase?"

- AI creates a new Supabase project, sets up the table, updates the API route, configures env vars on Vercel
- **Full database connected in ~5 minutes**

### Message 5 — OG Image (18:29)
> James: "When I share the link it's not showing a preview image..."

- AI generates a dynamic OG image using Next.js
- Link previews now work everywhere

### Message 6 — Final Polish (19:38)
> James: "The pizza place is called Windsor Hills Pizza, link their site"

- AI updates all references, adds the link, redeploys

## The Recap (4:00-5:00)
*[Show the final tech stack visually]*

**What got built:**
- ✅ Next.js landing page with responsive design
- ✅ GitHub repo (private → public)
- ✅ Vercel deployment (auto-deploys on push)
- ✅ Supabase database for email collection
- ✅ Dynamic OG image for social sharing
- ✅ Real copy from a photo of a neighborhood sign

**Total time:** ~10 minutes
**Lines of code written by James:** 0
**Tools used:** WhatsApp voice messages from the couch

## The CTA (5:00-5:30)
- "This is OpenClaw — an open-source AI assistant that runs on your own hardware"
- "If you want one set up for you without the technical setup, check out Actually Useful AI"
- Links in description

## B-Roll / Visual Ideas
- Screen recording of the WhatsApp chat (blur phone number)
- Split screen: left = phone messages, right = website updating in real-time
- Terminal/code flying by (the AI working)
- Final site walkthrough on mobile
- Supabase dashboard showing emails coming in

## Key Talking Points to Hit
1. **Voice messages** — didn't even type, just talked naturally
2. **Image understanding** — sent a photo, AI read it and used the info
3. **Full stack** — not just a pretty page, real database, real deployment
4. **Iterative** — kept adding features conversationally
5. **Real use case** — not a demo, actual neighborhood organizing tool
6. **Speed** — idea to production in 10 minutes

## Timestamps from Actual Session
- 18:13 — James asks "what can you do?"
- 18:14 — The pizza landing page request (voice message)
- 18:15 — Repo name given
- 18:16 — Site is LIVE + photo sent with real details
- 18:21 — Supabase request
- 18:26 — Database connected and deployed
- 18:29 — OG image request
- 18:30 — OG image deployed
- 19:38 — Windsor Hills Pizza name/link added
- **Total elapsed: ~16 minutes** (with gaps where James was doing other things, active build time ~10 min)
