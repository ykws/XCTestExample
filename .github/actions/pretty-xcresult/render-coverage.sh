#!/usr/bin/env bash
set -euo pipefail

COVERAGE_PATH="${1:?coverage json path is required}"

{
  echo "## Code Coverage"
  echo ""
  echo "| File | Coverage | Covered | Executable |"
  echo "| --- | ---: | ---: | ---: |"

  jq -r '
    .targets[] | select(.name | endswith(".app")) |
    (
      [.name, (.lineCoverage * 100), .coveredLines, .executableLines, "target"],
      (.files[] | [.name, (.lineCoverage * 100), .coveredLines, .executableLines, "file"])
    ) | @tsv
  ' "$COVERAGE_PATH" | while IFS=$'\t' read -r name coverage covered executable kind; do
    formatted=$(printf "%.2f%%" "$coverage")
    if [ "$kind" = "target" ]; then
      echo "| **$name** | **$formatted** | **$covered** | **$executable** |"
    else
      echo "| $name | $formatted | $covered | $executable |"
    fi
  done
} >> "$GITHUB_STEP_SUMMARY"
