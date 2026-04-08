#!/usr/bin/env bash
set -euo pipefail

TESTS_PATH="${1:?tests json path is required}"

{
  echo "## Test Summary"
  echo ""
  echo "| Suite | Total | ✅ | ❌ | ⏭️ | 🔶 |"
  echo "| --- | ---: | ---: | ---: | ---: | ---: |"

  jq -r '
    .testNodes[].children[].children[] |
    [
      .name,
      ([ (.children // [])[] ] | length),
      ([ (.children // [])[] | select(.result == "Passed") ] | length),
      ([ (.children // [])[] | select(.result == "Failed") ] | length),
      ([ (.children // [])[] | select(.result == "Skipped") ] | length),
      ([ (.children // [])[] | select(.result == "Expected Failure") ] | length)
    ] | @tsv
  ' "$TESTS_PATH" | while IFS=$'\t' read -r suite total passed failed skipped expected; do
    echo "| $suite | $total | $passed | $failed | $skipped | $expected |"
  done
} >> "$GITHUB_STEP_SUMMARY"
