#!/usr/bin/env bash
set -euo pipefail

COVERAGE_PATH="${1:?coverage json path is required}"

{
  echo "## Code Coverage"
  echo ""

  read -r COVERED EXECUTABLE COVERAGE <<EOF
$(jq -r '[.coveredLines, .executableLines, (.lineCoverage * 100 | round)] | @tsv' "$COVERAGE_PATH")
EOF

  echo "**Overall: ${COVERAGE}% (${COVERED}/${EXECUTABLE} lines)**"
  echo ""
  echo "| Target / File | Coverage | Covered | Executable |"
  echo "| --- | ---: | ---: | ---: |"

  jq -r '
    .targets[] as $target |
    [
      ("**" + $target.name + "**"),
      (($target.lineCoverage * 100 | round | tostring) + "%"),
      ($target.coveredLines | tostring),
      ($target.executableLines | tostring)
    ] | @tsv,
    (
      $target.files[] |
      [
        ("  " + .name),
        ((.lineCoverage * 100 | round | tostring) + "%"),
        (.coveredLines | tostring),
        (.executableLines | tostring)
      ] | @tsv
    )
  ' "$COVERAGE_PATH" | while IFS=$'\t' read -r name coverage covered executable; do
    echo "| $name | $coverage | $covered | $executable |"
  done
} >> "$GITHUB_STEP_SUMMARY"
