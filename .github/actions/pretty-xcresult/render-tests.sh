#!/usr/bin/env bash
set -euo pipefail

TESTS_PATH="${1:?tests json path is required}"

FAILED_COUNT=$(jq '[.testNodes[].children[].children[] | (.children // [])[] | select(.result == "Failed")] | length' "$TESTS_PATH")

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

  if [ "$FAILED_COUNT" -gt 0 ]; then
    echo ""
    echo "### Failures"
    echo ""
    jq -r '
      .testNodes[].children[] as $bundle |
      $bundle.children[] as $suite |
      ($suite.children // [])[] |
      select(.result == "Failed") |
      [$bundle.name, $suite.name, .name, (.details // ""), (.duration // "-")] | @tsv
    ' "$TESTS_PATH" | while IFS=$'\t' read -r bundle suite test details duration; do
      echo "- ❌ \`$test\` ($suite · $bundle) — $duration"
      if [ -n "$details" ]; then
        echo "  > $details"
      fi
    done
  fi
} >> "$GITHUB_STEP_SUMMARY"
