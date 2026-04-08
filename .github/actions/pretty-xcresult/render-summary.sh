#!/usr/bin/env bash
set -euo pipefail

SUMMARY_PATH="${1:?summary json path is required}"

# まとめて抜く
IFS=$'\t' read -r TOTAL PASSED FAILED SKIPPED EXPECTED START END TITLE DEVICE OS BUILD PLATFORM CONFIG <<EOF
$(jq -r '
[
  (.totalTestCount // 0),
  (.passedTests // 0),
  (.failedTests // 0),
  (.skippedTests // 0),
  (.expectedFailures // 0),
  (.startTime // 0),
  (.finishTime // 0),
  ((.title // "Unknown") | sub("^Test - "; "")),
  (.devicesAndConfigurations[0].device.deviceName // "-"),
  (.devicesAndConfigurations[0].device.osVersion // "-"),
  (.devicesAndConfigurations[0].device.osBuildNumber // "-"),
  (.devicesAndConfigurations[0].device.platform // "-"),
  (.devicesAndConfigurations[0].testPlanConfiguration.configurationName // "-")
] | @tsv
' "$SUMMARY_PATH")
EOF

DURATION="$(awk "BEGIN {printf \"%.2fs\", $END - $START}")"

{
  echo "## Testing project $TITLE with scheme $TITLE"
  echo ""
  echo "### Summary"
  echo ""
  echo "| Total | ✅ Passed | ❌ Failed | ⏭️ Skipped | 🔶 Expected Failure | ⏱️ Time |"
  echo "| ---: | ---: | ---: | ---: | ---: | ---: |"
  echo "| $TOTAL | $PASSED | $FAILED | $SKIPPED | $EXPECTED | $DURATION |"
  echo ""
  echo "### Devices"
  echo ""
  echo "- **Device:** $DEVICE, $OS ($BUILD)"
  echo "- **Platform:** $PLATFORM"
  echo "- **Configuration:** $CONFIG"
  echo ""
  echo "### Failures"
  echo ""
  if [ "$FAILED" -eq 0 ]; then
    echo "All tests passed :tada:"
  else
    echo "$FAILED test(s) failed"
  fi
} >> "$GITHUB_STEP_SUMMARY"
