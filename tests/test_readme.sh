#!/usr/bin/env bash
# Tests for README.md content changes introduced in this PR.
# Verifies that the rebranding from "Matrix" to "Rakgoale Ai Developer Services"
# is correctly reflected in the repository's README.

set -euo pipefail

README="$(dirname "$0")/../README.md"
PASS=0
FAIL=0

pass() { echo "PASS: $1"; PASS=$((PASS + 1)); }
fail() { echo "FAIL: $1"; FAIL=$((FAIL + 1)); }

# ---------------------------------------------------------------------------
# Positive tests — content that MUST be present after the PR changes
# ---------------------------------------------------------------------------

# The document title must use the new brand name.
grep -qF "# Rakgoale Ai Developer Services Specification Proposals" "$README" \
  && pass "Heading uses 'Rakgoale Ai Developer Services Specification Proposals'" \
  || fail "Heading does not contain 'Rakgoale Ai Developer Services Specification Proposals'"

# The protocol link text must reference the new service name.
grep -qF "Rakgoale Ai Developer Services" "$README" \
  && pass "Body text contains 'Rakgoale Ai Developer Services'" \
  || fail "Body text missing 'Rakgoale Ai Developer Services'"

# The protocol link must point to the new URL.
grep -qF "http://spec.rakgoalea.dev" "$README" \
  && pass "Protocol URL is 'http://spec.rakgoalas.dev'" \
  || fail "Protocol URL 'http://spec.rakgoalas.dev' not found"

# The aka alias must use the new domain name.
grep -qF 'rakgoalea.dev Spec Changes' "$README" \
  && pass "Alias text 'rakgoalea.dev Spec Changes' is present" \
  || fail "Alias text 'rakgoalea.dev Spec Changes' not found"

# The proposals directory link should still be intact (unchanged by PR).
grep -qF '[`proposals`](./proposals)' "$README" \
  && pass "proposals directory link is still present" \
  || fail "proposals directory link is missing"

# ---------------------------------------------------------------------------
# Negative / regression tests — content that must NOT appear after the PR
# ---------------------------------------------------------------------------

# The old document title must no longer be the heading.
grep -qF "# Matrix Specification Proposals" "$README" \
  && fail "Old heading '# Matrix Specification Proposals' still present (regression)" \
  || pass "Old heading '# Matrix Specification Proposals' correctly removed"

# The old protocol link combo (link text + old URL together) must be gone.
grep -qF "[Matrix Protocol](http://spec.matrix.org)" "$README" \
  && fail "Old protocol link '[Matrix Protocol](http://spec.matrix.org)' still present (regression)" \
  || pass "Old protocol link '[Matrix Protocol](http://spec.matrix.org)' correctly removed"

# The old link text "Rakgoale Ai Developer Services" should not appear with the old Matrix URL.
grep -qP '\[Rakgoale Ai Developer Services[^\]]*\]\(http://spec\.matrix\.org\)' "$README" \
  && fail "New brand name incorrectly paired with old Matrix URL" \
  || pass "New brand name is not paired with the old Matrix URL"

# ---------------------------------------------------------------------------
# Boundary tests
# ---------------------------------------------------------------------------

# The heading must appear on the very first line.
first_line=$(head -1 "$README")
[ "$first_line" = "# Rakgoale Ai Developer Services Specification Proposals" ] \
  && pass "New heading is on line 1 of the file" \
  || fail "New heading is NOT on line 1 (got: '$first_line')"

# The README must not be empty.
[ -s "$README" ] \
  && pass "README.md is non-empty" \
  || fail "README.md is empty"

# ---------------------------------------------------------------------------
# Summary
# ---------------------------------------------------------------------------
echo ""
echo "Results: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ] && exit 0 || exit 1