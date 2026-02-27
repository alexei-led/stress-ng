#!/usr/bin/env bash
# Integration tests for the stress-ng Docker image.
# Tests both /stress-ng (default entrypoint) and /cg-inject (Pumba inject-cgroup helper).
set -euo pipefail

IMAGE="${TEST_IMAGE:?TEST_IMAGE must be set}"

echo "=== Testing image: ${IMAGE} ==="
PASS=0
FAIL=0

run_test() {
  local name="$1"; shift
  echo ""
  echo "── ${name}"
  if "$@"; then
    echo "   PASS"
    ((PASS++)) || true
  else
    echo "   FAIL (exit $?)"
    ((FAIL++)) || true
  fi
}

# ── stress-ng tests ───────────────────────────────────────────────────────────

run_test "[stress-ng] version output" \
  docker run --rm "${IMAGE}" --version

run_test "[stress-ng] CPU stress (2 workers, 5s)" \
  docker run --rm "${IMAGE}" --cpu 2 --timeout 5s --metrics-brief

run_test "[stress-ng] VM stress (1 worker, 32MB, 5s)" \
  docker run --rm "${IMAGE}" --vm 1 --vm-bytes 32M --timeout 5s --metrics-brief

# ── cg-inject tests ───────────────────────────────────────────────────────────
# These tests verify the cg-inject binary is present and behaves correctly
# for arg parsing. Actual cgroup injection requires kernel privileges and is
# tested end-to-end by Pumba's integration test suite.

run_test "[cg-inject] binary exists and shows usage on missing args" bash -c \
  "docker run --rm --entrypoint /cg-inject '${IMAGE}' 2>&1 | grep -q 'missing.*separator'"

run_test "[cg-inject] rejects unknown flag" bash -c \
  "docker run --rm --entrypoint /cg-inject '${IMAGE}' --bad-flag -- /stress-ng 2>&1 | grep -q 'unknown flag'"

run_test "[cg-inject] rejects invalid container ID" bash -c \
  "docker run --rm --entrypoint /cg-inject '${IMAGE}' --target-id not-hex -- /stress-ng 2>&1 | grep -q 'invalid container ID'"

run_test "[cg-inject] rejects path traversal in --cgroup-path" bash -c \
  "docker run --rm --entrypoint /cg-inject '${IMAGE}' --cgroup-path 'foo/../../etc' -- /stress-ng 2>&1 | grep -q 'must not contain'"

run_test "[cg-inject] rejects mutually exclusive flags" bash -c \
  "docker run --rm --entrypoint /cg-inject '${IMAGE}' --cgroup-path foo --target-id aabbccddeeff -- /stress-ng 2>&1 | grep -q 'mutually exclusive'"

echo ""
echo "═══════════════════════════════════════"
echo " Results: ${PASS} passed, ${FAIL} failed"
echo "═══════════════════════════════════════"

if [ "${FAIL}" -gt 0 ]; then
  exit 1
fi
