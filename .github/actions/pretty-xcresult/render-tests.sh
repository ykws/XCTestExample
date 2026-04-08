#!/usr/bin/env bash
set -euo pipefail

TESTS_PATH="${1:?tests json path is required}"

{
  echo "## Test Cases"
  echo ""
  echo "| Bundle | Suite | Test | Result | Duration |"
  echo "| --- | --- | --- | --- | ---: |"

  jq -r '
    .testNodes[].children[] as $bundle |
    $bundle.children[] as $suite |
    ($suite.children // [])[] |
    select(.nodeType == "Test Case") |
    [
      $bundle.name,
      $suite.name,
      .name,
      (if .result == "Passed" then ":white_check_mark: Passed"
       elif .result == "Failed" then ":x: Failed"
       else .result end),
      (.duration // "-")
    ] | @tsv
  ' "$TESTS_PATH" | while IFS=$'\t' read -r bundle suite test result duration; do
    echo "| $bundle | $suite | \`$test\` | $result | $duration |"
  done
} >> "$GITHUB_STEP_SUMMARY"
