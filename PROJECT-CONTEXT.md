# SloanMelia — Complete Project Context
*Compiled from all past Claude conversations · Last updated Feb 28, 2026*

---

## 🎯 What This Is
A college application platform built by a father (Daddy Boy) for his daughter Sloan Smith, a high school senior at Alton High School, Alton, Illinois. Graduating May 2026. Goal: PhD in Forensic Psychology.

This document compiles every key decision, technical spec, lesson learned, and artifact from all past build sessions so no context is ever lost.

---

## 👤 Sloan's Profile (Hardcoded in Edge Function + App)
- **Full Name:** Sloan Smith
- **School:** Alton High School, Alton, Illinois
- **Graduation:** May 2026
- **GPA:** 3.84 (updated — previously stored as 3.684, corrected Feb 28 2026)
- **Target Degree:** PhD in Forensic Psychology
- **Email:** sloan@sloanmelia.com / suncollectives@gmail.com

**Senior Year Courses:**
AP Psychology, AP Statistics, CP English 4 AP, Human Body Systems PLTW 2, Biomedical Internship, Sociology, Environmental Science, Spanish 2A & 2B

**Achievements (pre-seeded in DB):**
1. Patient Enrichment Program — Founder (annual hospital enrichment program)
2. Mu Alpha Theta — Member (National Math Honor Society)
3. Link Crew — Peer Mentor (mentoring freshmen)
4. Salvation Army — Volunteer (meal service)
5. Church Nursery — Volunteer (caregiver)
6. Mathematics Tutoring — Peer Tutor

**Target Schools (pre-seeded in DB):**
- Southern Illinois University Edwardsville (SIUE)
- University of Illinois Springfield
- Missouri Baptist University
- Saint Louis University

---

## 🏗 Architecture

### Stack
| Layer | Service | Plan | Cost |
|-------|---------|------|------|
| Hosting | Netlify | Pro ($19/mo) | ~$19/mo |
| Database + Auth | Supabase | Free tier | $0 |
| AI Coach | Claude API via Supabase Edge Function | Pay per use | ~$5-10/mo |
| Domain | Cloudflare | Registered | ~$12/yr |
| Repo | GitHub (sign-it-now/sloanmelia) | Free | $0 |

**Total: ~$15-25/month**

### URLs
- **Public profile:** https://sloanmelia.com (index.html)
- **App dashboard:** https://sloanmelia.com/sloanmelia-app.html
- **Login:** https://sloanmelia.com/login.html (legacy — now redirects)
- **Supabase project:** https://gpktuflimoqeyxtwadsy.supabase.co
- **GitHub repo:** https://github.com/sign-it-now/sloanmelia

### Supabase Credentials (hardcoded in app)
- **Project URL:** `https://gpktuflimoqeyxtwadsy.supabase.co`
- **Anon Key:** `eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imdwa3R1ZmxpbW9xZXl4dHdhZHN5Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzE2ODM2MDEsImV4cCI6MjA4NzI1OTYwMX0.q3RMeKEo17qXgt-a9ljtMfKJ46etHy4_rrj1cs64A4U`
- **Coach Edge Function URL:** `https://gpktuflimoqeyxtwadsy.supabase.co/functions/v1/coach`

**Note:** Credentials are hardcoded in a `<script>` tag at the top of sloanmelia-app.html that pre-seeds localStorage on every page load. This was done to fix the blank page / setup screen issue.

---

## 📁 File Map (All Files in Repo)

### Main App
| File | Purpose | Status |
|------|---------|--------|
| `sloanmelia-app.html` | **Main app** — single file React+Babel dashboard | ✅ Live |
| `index.html` | Public profile page (Sloan's "brag page") | ✅ Live |
| `login.html` | Legacy login page (was used before credentials hardcoded) | Legacy |

### Study Library Posters (all live at sloanmelia.com/poster*.html)
| File | Topic | OpenStax Link |
|------|-------|--------------|
| `poster1-brain.html` | Brain & Neuroscience | Psychology 2e Ch 3 |
| `poster2-dsm5.html` | DSM-5 Diagnostic Reference | Psychology 2e Ch 15 |
| `poster3-theorists.html` | Theorists Timeline | Psychology 2e Ch 1 |
| `poster4-research.html` | Research Methods & Statistics | Psychology 2e Ch 2 |
| `poster5-defense.html` | Defense Mechanisms | Psychology 2e Ch 11 |
| `poster6-development.html` | Human Development | Psychology 2e Ch 9 |
| `poster7-biases.html` | Cognitive Biases | Psychology 2e Ch 7 |
| `poster8-ethics.html` | APA Ethics Code | Psychology 2e Ch 1 |
| `support1-biology.html` | Biology & Physiology | Anatomy & Physiology 2e |
| `support2-sociology.html` | Sociology & Social Theory | Introduction to Sociology 3e |
| `support3-philosophy.html` | Philosophy of Mind | Introduction to Philosophy |
| `support4-pharmacology.html` | Pharmacology Basics | Psychology 2e Ch 16 |
| `support5-law.html` | Law & Psychology Interface | Psychology 2e |
| `support6-comm-write-admin.html` | Communication & Writing | Psychology 2e |

### Reference Docs
| File | Purpose |
|------|---------|
| `forensic-psych-reference.html` | Forensic psychology field reference |
| `sloan-forensic-stats.html` | AP Stats + forensic psych connection |
| `sloanmelia-build-guide.html` | Interactive build checklist (all 5 phases) |
| `sloanmelia-roadmap-coach.html` | Roadmap with coach progress tracker |
| `deployment-guide.html` | Netlify/GitHub deployment workflow |
| `netlify-guide.html` | Netlify-specific setup guide |
| `sloanmelia-dyad-prompt.txt` | Dyad build prompt (legacy) |

---

## 🗄 Database Tables (Supabase)

### `documents`
```sql
id, user_id, name, category, file_path, file_size, created_at
```
Categories: Transcript, Test Scores, Recommendation Letter, Essay, Certificate, Resume, Financial, Other

### `achievements`
```sql
id, user_id, title, role, description, impact, created_at
```

### `college_applications` (tracker)
```sql
id, user_id, school_name, portal_url, status, deadline, notes, created_at
```
Statuses: researching, in-progress, submitted, accepted, waitlisted, rejected

### `scholarships` (financial aid)
```sql
id, user_id, name, amount_min, amount_max, status, url, requirements, created_at
```

---

## 🤖 AI Coach (Edge Function)

### Deployment
- **Function name:** `coach`
- **Verify JWT:** `true` (requires Authorization header)
- **Auth method:** Anon key as Bearer token (NOT session JWT — timing issues with session approach)

### How Auth Works
The app uses `getAnonKey()` which reads `localStorage.sm_key` and passes it as `Authorization: Bearer <anon_key>`. The anon key itself is a valid JWT accepted by `verify_jwt: true` edge functions.

```javascript
function getAnonKey() {
  return localStorage.getItem('sm_key') || '';
}
// Used in fetch:
headers: { 'Content-Type': 'application/json', 'Authorization': 'Bearer ' + getAnonKey() }
```

### GPA Correction (Workaround)
Edge function system prompt has old GPA (3.684). Permanent fix requires new Supabase PAT. Current workaround: `vaultContext` sent with every coach request is prepended with:
```
"CORRECTION — Sloan's current GPA is 3.84 (updated). Use 3.84 in all responses."
```

### Coach Capabilities
- Chat (main tab)
- Form analyzer (paste any college form, auto-fill with Sloan's data)
- Essay coach (generate/improve application essays)
- Achievements formatter (Common App format)
- Quiz mode (forensic psychology study)
- Financial aid guidance

---

## 🐛 Bugs Fixed (History)

### Feb 28 2026 — Blank Page After Study Library Update
**Root cause:** Python string replacement created a duplicate `function LibraryModule` declaration. Babel strict mode sees duplicate function in same scope, refuses to compile, leaves blank cream page with no visible error.
**Fix:** Remove one instance of the duplicate.
**Lesson:** Always run duplicate function check after any automated string replacement.

### Feb 28 2026 — Coach "No Response" Error
**Root cause:** Edge function deployed with `verify_jwt: true` but app was sending no Authorization header (or sending expired/missing session JWT due to async timing).
**Fix:** Switch from `getJwt()` (session JWT) to `getAnonKey()` (anon key from localStorage). Anon key is a valid JWT that edge functions accept.

### Feb 28 2026 — GPA Shows 3.684 Instead of 3.84
**Root cause:** Edge function system prompt hardcoded Sloan's GPA. Edge function redeploy blocked (expired PAT, MCP tool InternalServerError, CLI needs Docker).
**Workaround:** Inject correction into vaultContext on every chat request.
**Permanent fix:** Generate new Supabase access token → redeploy edge function.

### Feb 28 2026 — Supabase CDN Shadowing Issue
**Root cause:** `let supabase = null` inside Babel script shadowed `window.supabase` from UMD CDN. Babel compiles `var supabase` in strict mode, which shadows the global.
**Fix:** Use `window['supabase']` bracket notation and rename internal variable to `_smClient`.

### Feb 28 2026 — Blank Page on Login (getSession missing catch)
**Root cause:** `sb.auth.getSession()` could throw if Supabase wasn't initialized. No catch handler meant unhandled promise rejection crashed React silently.
**Fix:** Add `.catch(()=>setAuthLoading(false))` after getSession.

### Feb 22 2026 — File Upload Duplicate Naming
**Root cause:** When uploading to GitHub, macOS was saving files as `dashboard (1).html` due to naming conflict. Netlify served the old file.
**Fix:** Delete the old file first, then upload fresh.

---

## 📐 App Architecture (sloanmelia-app.html)

### Structure
Single HTML file with:
1. `<script>` — Bootstrap: pre-seeds localStorage with hardcoded credentials
2. CDN scripts — React 18, ReactDOM, Babel standalone, Supabase JS
3. `<script type="text/babel">` — All React components compiled in-browser

### Key Components
```
App
├── ErrorBoundary (catches all React crashes, shows readable error)
├── ToastContainer (notification system)
├── Sidebar (NAV_ITEMS navigation)
└── Pages:
    ├── HomeModule
    ├── LibraryModule (14 cards: 8 Core Forensic + 6 Supporting)
    │   └── Modal with: poster link, OpenStax link, Ask Coach button
    ├── VaultModule (document upload/management)
    ├── TrackerModule (college application tracking)
    ├── AchievementsModule (log + Common App formatter)
    ├── FinancialModule (FAFSA guide + scholarships + 529 calc)
    └── CoachModule (chat + form filler + essay coach)
```

### NAV_ITEMS
```javascript
{ id:'home', icon:'🏠', label:'Home' }
{ id:'library', icon:'📚', label:'Study Library' }
{ id:'vault', icon:'📁', label:'Document Vault' }
{ id:'tracker', icon:'🎓', label:'College Tracker' }
{ id:'achievements', icon:'⭐', label:'Achievements' }
{ id:'financial', icon:'💰', label:'Financial Aid' }
{ id:'coach', icon:'🤖', label:'Coach', special:true }
```

### Color System (CSS vars)
```css
--ink: #1a1209    /* dark backgrounds */
--cream: #faf7f2  /* light backgrounds */
--gold: #c8922a   /* accent/CTA */
--teal: #0d9488   /* secondary accent */
--dim: #64748b    /* muted text */
```

---

## 📋 Phase Completion Status

| Phase | Name | Status |
|-------|------|--------|
| Phase 0 | Accounts setup | ✅ Complete |
| Phase 1 | Public Profile + Domain | ✅ Complete |
| Phase 2 | Login + Document Vault + Study Library | ✅ Complete |
| Phase 3 | AI Coach Integration | ✅ Complete |
| Phase 4 | Financial Aid Hub | ✅ Complete |
| Phase 5 | Profile Builder & Lifetime | 🔄 In Progress |

---

## 🔧 Deployment Process

### Standard Deploy
```bash
cd /home/claude/sloanmelia
git add -A
git commit -m "description"
git push
# Zip and deploy to Netlify:
rm -f *.zip && zip -r deploy.zip . -x "*.git*" "*.zip"
curl -X POST "https://api.netlify.com/api/v1/sites/e1e01062-9fb7-4375-bed4-b6a9f82e3baa/deploys" \
  -H "Authorization: Bearer nfp_6XxET1W1aBYXezHLccgnpMuLsd9sgogG362b" \
  -H "Content-Type: application/zip" \
  --data-binary @deploy.zip
```

### Netlify Credentials
- **Site ID:** `e1e01062-9fb7-4375-bed4-b6a9f82e3baa`
- **Token:** `nfp_6XxET1W1aBYXezHLccgnpMuLsd9sgogG362b`

---

## 🎓 Forensic Psychology Curriculum (Study Library)

### Core Forensic (8 topics)
1. Brain & Neuroscience
2. DSM-5 Diagnostic Reference
3. Theorists Timeline
4. Research Methods & Statistics
5. Defense Mechanisms
6. Human Development
7. Cognitive Biases
8. APA Ethics Code

### Supporting Subjects (6 topics)
9. Biology & Physiology
10. Sociology & Social Theory
11. Philosophy of Mind
12. Pharmacology Basics
13. Law & Psychology Interface
14. Communication & Writing

All 14 cards link to:
- The actual HTML poster file (e.g. `sloanmelia.com/poster1-brain.html`)
- The matching OpenStax textbook chapter (free, open source)
- "Ask Coach About This Topic" button

---

## 💡 Key Design Decisions & Lessons

### Why Single-File HTML (Not React App)
Early attempts with Base44 and Dyad for React SPA failed (rate limits, deployment complexity). Settled on single `.html` file with React loaded via CDN + Babel standalone compiled in-browser. No build step, no npm, no bundler. Works everywhere.

### Why Credentials Are Hardcoded
Setup screen UX was confusing for non-technical users. Hardcoding in bootstrap script pre-seeds localStorage so app loads directly to login without setup. Trade-off: less secure but massively simpler for the intended user.

### Why Not Session JWT for Coach Auth
`sb.auth.getSession()` is async. When fired immediately at page load before session is fully resolved, returns null. Anon key is synchronously available from localStorage and is itself a valid JWT. Simpler and more reliable.

### Daddy Boy's Preferences (Critical)
- Step-by-step instructions with exact terminology from the platform being used
- Copy-paste ready code — no partial examples
- Tell him which app/platform each step applies to
- Early-stage learner instructions, not expert-level
- Prefer reliable HTML over complex React when in doubt
- No setup screens — just make it work directly
- Use `platform.claude.com` (not `console.anthropic.com`) for all Claude developer references

---

## 🔮 What's Left (Pending)

### High Priority
- [ ] Fix edge function GPA (3.684 → 3.84 permanently) — needs new Supabase access token
- [ ] Profile Builder module (Phase 5) — let Sloan edit public profile from dashboard
- [ ] Netlify deploy hook — auto-publish public profile when edited

### Nice to Have
- [ ] Mobile-responsive improvements
- [ ] Sloan's own login (currently shared with Daddy Boy's account)
- [ ] Email notifications for application deadlines
- [ ] Zoho email setup (sloan@sloanmelia.com)
- [ ] Google SSO authentication

### Scholarships Pre-loaded (Financial Aid Hub)
1. Illinois MAP Grant — Up to $5,968/yr
2. APA Psychology Undergraduate Scholarship — $1,000
3. American Psychology-Law Society — $500-$2,000
4. Jack Kent Cooke Foundation — Up to $55,000
5. Alton Community Foundation — $500-$5,000
6. Phi Kappa Phi — Up to $8,500
7. Women in STEM — $500-$5,000

---

## 📎 Key Chat Links

| Session | Topic | Link |
|---------|-------|------|
| Feb 28 2026 | Coach auth fix + GPA correction | Current session |
| Feb 23 2026 | Roadmap + coach progress tracker | https://claude.ai/chat/35ba4e81-b4ed-4c3b-bcf2-89a7266fe2a9 |
| Feb 22 2026 | App assessment + full module build | https://claude.ai/chat/04c63cdb-261c-48df-9d96-cc27cdd3380d |
| Feb 22 2026 | Artifact link storage + roadmap | https://claude.ai/chat/c6b1b089-6eb0-4235-a7af-af31f44e04bd |
| Feb 21 2026 | Launch button bug + rebuild | https://claude.ai/chat/4859957a-cfc1-418d-b5a9-49a5c12e8ace |
| Feb 21 2026 | Supabase setup + publishable key issue | https://claude.ai/chat/188dc10c-4cc1-47ba-9fc2-458ca62ba92b |
| Feb 20 2026 | Phase checklist + PDF to build guide | https://claude.ai/chat/823be537-439e-4589-a059-cf12ba0f4080 |
| Feb 20 2026 | Netlify deployment guide + builder | https://claude.ai/chat/7aaeadda-18f9-4ba7-aecd-06552bc5f213 |
