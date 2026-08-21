#!/usr/bin/env python3
"""Validate the ultra-bug-hunter knowledge base.

Checks:
  1. All required top-level directories exist.
  2. At least 120 skill files exist (expect 250).
  3. Every skill file follows the canonical template section structure.
  4. No empty files, no placeholder tokens.
  5. No duplicate skill filenames across categories.
  6. Backticked filename references resolve to existing files (by basename).
  7. No banned content (secret patterns, destructive instructions).
  8. Counts and summary report for the final validation.

Usage:
    python3 tools/validate_repo.py [root]

Exit code 0 on success, 1 on failure.
"""

import re
import sys
from collections import Counter
from pathlib import Path

ROOT = Path(sys.argv[1]) if len(sys.argv) > 1 else Path(__file__).resolve().parent.parent

REQUIRED_DIRS = [
    "context", "workflows", "skills", "checklists", "templates",
    "patterns", "languages", "references", "tools",
]

REQUIRED_SECTIONS = [
    "## Purpose",
    "## Scope",
    "## Trigger Conditions",
    "## Inputs",
    "## Investigation Method",
    "## Evidence Requirements",
    "## Confidence",
    "## Severity",
    "## Safe Reproduction",
    "## Root Cause",
    "## Impact",
    "## Remediation",
    "## Regression Test",
    "## Common False Positives",
    "## Related Skills",
    "## Review Checklist",
    "## References",
]

PLACEHOLDER_TOKENS = ["TODO", "TBD", "lorem ipsum", "PLACEHOLDER", "XXX"]

# Banned/unsafe content markers (defensive-testing guard).
BANNED_PATTERNS = [
    r"meterpreter",
    r"cobalt.?strike",
    r"msfvenom",
    r"BEGIN (RSA |EC |OPENSSH )?PRIVATE KEY",
    r"AKIA[0-9A-Z]{16}",
    r"sk_live_",
    r"-----BEGIN PGP PRIVATE",
]


def main() -> int:
    errors = []
    notes = []

    # 1. Required directories
    for d in REQUIRED_DIRS:
        if not (ROOT / d).is_dir():
            errors.append(f"Missing required directory: {d}")

    # 2. Skill inventory
    skills = sorted((ROOT / "skills").glob("*/*.md"))
    skill_files = [s for s in skills if s.suffix == ".md"]
    if len(skill_files) < 120:
        errors.append(f"Only {len(skill_files)} skill files (minimum 120)")

    by_name = Counter(s.name for s in skill_files)
    for name, count in by_name.items():
        if count > 1:
            errors.append(f"Duplicate skill filename: {name} ({count}x)")

    # 3. Structure per skill
    empty_files = []
    bad_sections = []
    for sf in skill_files:
        text = sf.read_text(encoding="utf-8", errors="replace")
        if not text.strip():
            empty_files.append(str(sf))
            continue
        if not text.lstrip().startswith("# Skill:"):
            bad_sections.append(f"{sf}: missing '# Skill:' title")
        missing = [s for s in REQUIRED_SECTIONS if s not in text]
        if missing:
            bad_sections.append(f"{sf}: missing sections {missing}")

    # 4. Empty/placeholder checks across ALL markdown
    all_md = sorted((ROOT / "skills").rglob("*.md")) + [
        p for p in ROOT.rglob("*.md")
        if p.parent != ROOT / "skills"
    ]
    for p in all_md:
        text = p.read_text(encoding="utf-8", errors="replace")
        if not text.strip():
            empty_files.append(str(p))
            continue
        for tok in PLACEHOLDER_TOKENS:
            if tok.lower() in text.lower():
                bad_sections.append(f"{p}: contains placeholder token '{tok}'")

    # 5. Reference resolution (backticked filenames)
    all_basenames = {p.name for p in all_md}
    bad_refs = []
    for p in all_md:
        if p.parent == ROOT / "skills":
            continue
        text = p.read_text(encoding="utf-8", errors="replace")
        refs = re.findall(r"`([a-zA-Z0-9_\-]+\.md)`", text)
        for ref in refs:
            if ref not in all_basenames:
                bad_refs.append(f"{p}: unresolved reference `{ref}`")

    # 6. Banned content
    banned_hits = []
    for p in all_md:
        text = p.read_text(encoding="utf-8", errors="replace")
        for pat in BANNED_PATTERNS:
            if re.search(pat, text, re.IGNORECASE):
                banned_hits.append(f"{p}: banned pattern {pat!r}")

    # 7. Counts
    cat_counts = Counter()
    for sf in skill_files:
        cat_counts[sf.parent.name] += 1

    # Report
    print("=" * 60)
    print("ULTRA-BUG-HUNTER REPOSITORY VALIDATION")
    print("=" * 60)
    print(f"Root: {ROOT}")
    print(f"Skill files: {len(skill_files)}")
    print(f"Skill categories: {len(cat_counts)}")
    for cat in sorted(cat_counts):
        print(f"  {cat}: {cat_counts[cat]}")
    print(f"Total markdown files: {len(all_md)}")
    print(f"Workflows: {len(list((ROOT / 'workflows').glob('*.md')))}")
    print(f"Checklists: {len(list((ROOT / 'checklists').glob('*.md')))}")
    print(f"Templates: {len(list((ROOT / 'templates').glob('*.md')))}")
    print(f"References: {len(list((ROOT / 'references').glob('*.md')))}")
    print(f"Languages: {len(list((ROOT / 'languages').glob('*.md')))}")
    print(f"Context files: {len(list((ROOT / 'context').glob('*.md')))}")
    print()

    for label, items in [
        ("Empty files", empty_files),
        ("Structure issues", bad_sections),
        ("Unresolved references", bad_refs),
        ("Banned content", banned_hits),
    ]:
        if items:
            errors.append(f"{label}: {len(items)}")
            print(f"FAIL: {label}")
            for i in items[:10]:
                print(f"  - {i}")
            if len(items) > 10:
                print(f"  ... and {len(items)-10} more")
        else:
            print(f"OK: {label}")

    print()
    if errors:
        print(f"RESULT: FAIL ({len(errors)} issue groups)")
        return 1
    print("RESULT: PASS")
    return 0


if __name__ == "__main__":
    sys.exit(main())
