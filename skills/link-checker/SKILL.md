---
name: sloanmelia-link-checker
emoji: 🔗
description: Check all internal and external links across the SloanMelia site for broken references
requires:
  bins: [bash, curl, grep]
triggers:
  - check links
  - verify links
  - are links working
  - link check
  - check sloanmelia links
  - broken links
---

# SloanMelia Link Checker

Checks every HTML file in the SloanMelia project for broken links. Catches 404s and missing files before they reach the live site.

## When to use this skill

Use this skill whenever the user asks:
- "Check the links" / "Are the links working?"
- "Verify links" / "Find broken links"
- "Link check sloanmelia"
- Any time after changes are pushed and the user wants to confirm nothing is broken

## How to run

### Local check (fast — no network needed)
Scans all `.html` files in the project directory and verifies every local `href` resolves to an existing file.

```bash
bash skills/link-checker/scripts/check-links.sh
```

### Live site check (includes HTTP status of real URLs)
Also curls each page on https://sloanmelia.com and reports non-200 responses.

```bash
bash skills/link-checker/scripts/check-links.sh --live
```

## Reporting results

After running the script, report back to the user:
- Total number of links checked
- List every broken link with: the file it appears in, the href value, and the error (MISSING FILE or HTTP status code)
- If all links pass, confirm with "All links are working ✓"
- If there are broken links, suggest the fix (e.g. "coach.html should be sloanmelia-roadmap-coach.html")
