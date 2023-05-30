#!/bin/bash

script_dir=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
target_script="$script_dir/update.sh"
test_chart="testkube-test-chart"

echo "script_dir: $script_dir"
echo "pwd: $(pwd)"

# Function to assert expected and actual values
assert_equal() {
  local expected="$1"
  local actual="$2"

  if diff <(echo "$expected") <(echo "$actual") >/dev/null; then
    echo "Test passed!"
  else
    echo "Test failed!"
    diff <(echo "$expected") <(echo "$actual")
    exit 1
  fi
}

echo "Test case 1: Update with specific app version and Helm version"
output="$($target_script -a v1.2.3 -v 2.3.4 -c $test_chart --dry-run)"
expected_output=$(cat << EOF
---
# file charts/testkube-test-chart/Chart.yaml
apiVersion: v2
name: testkube-test-chart
description: Testing Helm chart
type: application
version: 2.3.5
appVersion: 1.2.3
---

EOF
)
assert_equal "$expected_output" "$output"

echo "All tests passed!"
