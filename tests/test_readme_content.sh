#!/usr/bin/env bash
# Tests for README.md content changes introduced in this PR.
# Verifies branding was updated from Matrix to Rakgoale Ai Developer Services.

set -euo pipefail

README="$(dirname "$0")/../README.md"
PASS=0
FAIL=0

assert_contains() {
    local description="$1"
    local pattern="$2"
    if grep -qF "$pattern" "$README"; then
        echo "PASS: $description"
        PASS=$((PASS + 1))
    else
        echo "FAIL: $description"
        echo "      Expected to find: $pattern"
        FAIL=$((FAIL + 1))
    fi
}

assert_not_contains() {
    local description="$1"
    local pattern="$2"
    if ! grep -qF "$pattern" "$README"; then
        echo "PASS: $description"
        PASS=$((PASS + 1))
    else
        echo "FAIL: $description"
        echo "      Expected NOT to find: $pattern"
        FAIL=$((FAIL + 1))
    fi
}

assert_file_starts_with() {
    local description="$1"
    local expected="$2"
    local actual
    actual="$(head -n 1 "$README")"
    if [ "$actual" = "$expected" ]; then
        echo "PASS: $description"
        PASS=$((PASS + 1))
    else
        echo "FAIL: $description"
        echo "      Expected: $expected"
        echo "      Actual:   $actual"
        FAIL=$((FAIL + 1))
    fi
}

echo "Running README.md content tests..."
echo

# --- New content must be present ---

assert_file_starts_with \
    "Title is updated to Rakgoale Ai Developer Services branding" \
    "# Rakgoale Ai Developer Services Specification Proposals"

assert_contains \
    "Contains new project name in body text" \
    "Rakgoale Ai Developer Services"

assert_contains \
    "Contains new spec URL" \
    "http://spec.rakgoalea.dev"

assert_contains \
    "Contains new short-form spec identifier" \
    "rakgoalea.dev Spec Changes"

# --- Old content must be absent ---

assert_not_contains \
    "Old title 'Matrix Specification Proposals' is not the document title" \
    "# Matrix Specification Proposals"

assert_not_contains \
    "Old spec URL http://spec.matrix.org is not the primary spec link" \
    "](http://spec.matrix.org)"

# --- Structural integrity checks (regression) ---

assert_contains \
    "proposals directory reference is preserved" \
    '[`proposals`](./proposals)'

assert_contains \
    "MSC acronym is still used" \
    "(MSCs)"

# --- Summary ---

echo
echo "Results: $PASS passed, $FAIL failed"

if [ "$FAIL" -gt 0 ]; then
    exit 1
fi