#!/usr/bin/env python3
"""
SloanMelia Pre-Deploy Validator
Run before every deploy to catch missing constants/functions early.
Usage: python3 validate.py
"""
import re, sys

REQUIRED_CONSTANTS = [
    'NAV_ITEMS','STUDY_TOPICS','DOC_CATS','CAT_BADGE',
    'ACH_BADGE','SEED_ACHIEVEMENTS','SEED_SCHOOLS',
    'STATUS_COLORS','STATUS_LABELS','SCHOLARSHIPS_SEED','FAFSA_SECTIONS'
]
REQUIRED_FUNCTIONS = [
    'ErrorBoundary','Modal','Sidebar',
    'HomeModule','LibraryModule','VaultModule',
    'TrackerModule','AchievementsModule','FinancialModule','CoachModule','GpaModule','ProfileModule','App'
]

def validate(path='sloanmelia-app.html'):
    with open(path,'r') as f:
        content = f.read()

    errors = []

    # Check constants
    for c in REQUIRED_CONSTANTS:
        if f'const {c}' not in content and f'var {c}' not in content:
            errors.append(f'MISSING CONSTANT: {c}')

    # Check functions (can be function or class)
    for fn in REQUIRED_FUNCTIONS:
        if f'function {fn}' not in content and f'class {fn}' not in content:
            errors.append(f'MISSING FUNCTION/CLASS: {fn}')

    # Check brace balance in babel script
    script_start = content.find('<script type="text/babel">')
    script_end = content.rfind('</script>')
    if script_start > 0:
        script = content[script_start:script_end]
        diff = script.count('{') - script.count('}')
        if diff != 0:
            errors.append(f'BRACE IMBALANCE: {diff:+d} (opens minus closes)')

    # Check duplicate function definitions
    fns = re.findall(r'function (\w+)\s*[\({]', content)
    from collections import Counter
    dupes = {k:v for k,v in Counter(fns).items() if v > 1}
    for fn, count in dupes.items():
        errors.append(f'DUPLICATE FUNCTION: {fn} defined {count} times')

    # Check file size sanity (should be > 80KB)
    if len(content) < 80000:
        errors.append(f'FILE TOO SMALL: {len(content)} bytes (expected > 80KB — content may be missing)')

    if errors:
        print('\n❌ VALIDATION FAILED — DO NOT DEPLOY\n')
        for e in errors:
            print(f'  • {e}')
        print()
        sys.exit(1)
    else:
        print(f'✅ All checks passed ({len(content):,} bytes, {len(REQUIRED_CONSTANTS)} constants, {len(REQUIRED_FUNCTIONS)} functions)')
        sys.exit(0)

if __name__ == '__main__':
    validate()
