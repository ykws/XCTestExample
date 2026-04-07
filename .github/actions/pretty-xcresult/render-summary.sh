#!/usr/bin/env bash
set -euo pipefail

SUMMARY_PATH="${1:?summary json path is required}"

# まとめて抜く
read -r TOTAL PASSED FAILED SKIPPED EXPECTED START END TITLE DEVICE OS BUILD PLATFORM CONFIG <<EOF
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

cat <<EOF >> "$GITHUB_STEP_SUMMARY"
## Testing project $TITLE with scheme $TITLE

### Summary

| Total | Passed | Failed | Skipped | Expected Failure | Time |
| ---: | ---: | ---: | ---: | ---: | ---: |
| $TOTAL | $PASSED | $FAILED | $SKIPPED | $EXPECTED | $DURATION |

### Devices

- **Device:** $DEVICE, $OS ($BUILD)
- **Platform:** $PLATFORM
- **Configuration:** $CONFIG

### Failures

EOF

if [ "$FAILED" -eq 0 ]; then
  echo "All tests passed :tada:" >> "$GITHUB_STEP_SUMMARY"
else
  echo "$FAILED test(s) failed" >> "$GITHUB_STEP_SUMMARY"
fi
