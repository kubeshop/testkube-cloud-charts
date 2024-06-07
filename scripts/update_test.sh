#!/bin/bash

script_dir=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
target_script="$script_dir/update.sh"
test_chart="testkube-test-chart"

# function to assert expected and actual values
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
output=$($target_script -d "$script_dir" -a v1.2.3 -v 2.3.4 -g 1.2.3 -c $test_chart --dry-run | tail +3)
expected_output=$(cat << EOF
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

echo "Test case 2: Get current Helm chart appVersion"
output=$($target_script -d "$script_dir" -c $test_chart --print-app-version)
expected_output="1.2.3"
assert_equal "$expected_output" "$output"

echo "Test case 3: Get current Helm chart version"
output=$($target_script -d "$script_dir" -c $test_chart --print-chart-version)
expected_output="1.0.0"
assert_equal "$expected_output" "$output"

echo "All tests passed!"
