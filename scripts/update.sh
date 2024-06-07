#!/bin/bash

################################################################################
# Description: Bash script to update the Helm version and appVersion fields    #
#              in the Chart.yaml file based on command line options.           #
#              The script accepts flags for -a|--app-version and               #
#              -v|--helm-version to specify the versions, and -c|--chart       #
#              to provide the name of the chart.                               #
#                                                                              #
# Note: If -v|--helm-version is not provided, we take the latest version       #
# in Chart.yaml file and bump it. If --strategy is specified, the Helm version #
# is bumped based on the specified strategy.                                   #
################################################################################

## VARIABLES
# Helm app version
app_version=""
# Helm chart version
helm_version=""
# chart name
chart_name=""
# version bump strategy
bump_strategy="patch"
# allowed bumping strategies
strategy_options=("patch" "minor" "major" "none")
# base charts directory
base_charts_dir="charts"
# path to the provided chart
chart_path=""
# path to the Chart.yaml file
chart_yaml_path=""
# if dry run is enabled, it will echo the updated Chart.yaml instead of updating the file
dry_run=false
# if verbose is enabled, it will print the action logs
verbose=false
# if print_chart_version is enabled, it will print the chart version
print_chart_version=false
# if print_app_version is enabled, it will print the app version
print_app_version=false

show() {
  if [[ "$verbose" == "true" ]]; then
    echo "$@"
  fi
}

err() { echo "$@" 1>&2; }

# function to display script usage
usage() {
  echo "Usage: $0 -a|--app-version <version> -v|--helm-version <version> -c|--chart <chart_name> [--bump-path|--bump-minor|--bump-major] [--strategy <strategy>]"
  echo "Options:"
  echo "  -a, --app-version        Specify the application version"
  echo "  -v, --helm-version       Specify the Helm version"
  echo "  -c, --chart              Specify the chart name"
  echo "  -d, --base-dir           Specify the base charts directory (default: charts)"
  echo "  -s|--strategy <strategy> Specify the bumping strategy (patch, minor, major or none)"
  echo "  --dry-run                Print the updated Chart.yaml instead of updating the file"
  echo "  --print-chart-version    Print the version of the chart"
  echo "  --print-app-version      Print the app version of the chart"
  echo "  --dry-run                Print the updated Chart.yaml instead of updating the file"
  echo "  --verbose                Print the action logs"
  echo "  -h, --help               Display this help message"
}

# function to print the chart version from the Chart.yaml
print_chart_version() {
  local chart_version=""

  if [[ -f "$chart_yaml_path" ]]; then
    chart_version=$(grep -E '^version:' "$chart_yaml_path" | awk '{print $2}')
    printf "%s" "$chart_version"
  else
    err "$chart_yaml_path not found"
  fi
}

# Function to print the app version from the Chart.yaml
print_app_version() {
  local app_version=""

  if [[ -f "$chart_yaml_path" ]]; then
    app_version=$(grep -E '^appVersion:' "$chart_yaml_path" | awk '{print $2}')
    printf "%s" "$app_version"
  else
    err "$chart_yaml_path not found"
  fi
}

# function to update the Chart.yaml file
update_chart_yaml() {
  local app_version=$1
  local helm_version=$2

  if [[ -f "$chart_yaml_path" ]]; then
    if [[ "$dry_run" == true ]]; then
      # print the updated Chart.yaml if dry run is enabled
      printf -- "---\n"
      printf "# file %s\n" "$chart_yaml_path"
      sed -e "s/^appVersion:.*$/appVersion: $app_version/" -e "s/^version:.*$/version: $helm_version/" "$chart_yaml_path"
      printf -- "---\n"
    else
      # update the Chart.yaml
      sed -i '' -e "s/^appVersion:.*$/appVersion: $app_version/" -e "s/^version:.*$/version: $helm_version/" "$chart_yaml_path"
    fi
    show "$chart_yaml_path updated with appVersion: $app_version and version: $helm_version"

    if [[ -n $agent_version ]]; then
      sed -i "/^ *- name: testkube$/,/^ *- / s/^\( *version: \).*/\1$agent_version/" "$chart_yaml_path"
    else
      echo "Agent version was not provided, skipping update"
    fi
  else
    err "$chart_yaml_path not found"
  fi
}

# function to increment the version number based on the bumping strategy
increment_version() {
  local version=$1
  local strategy=$2
  local major=""
  local minor=""
  local patch=""

  major=$(echo "$version" | awk -F. '{print $1}')
  minor=$(echo "$version" | awk -F. '{print $2}')
  patch=$(echo "$version" | awk -F. '{print $3}')

  case $strategy in
    "patch")
        patch=$((patch + 1))
        ;;
    "minor")
        minor=$((minor + 1))
        patch=0
        ;;
    "major")
        major=$((major + 1))
        minor=0
        patch=0
        ;;
  esac

  echo "$major.$minor.$patch"
}

# parse command line arguments
while [[ $# -gt 0 ]]; do
  key="$1"

  case $key in
    -a|--app-version)
    app_version="$2"
    shift
    shift
    ;;
    -g|--agent-version)
    agent_version="$2"
    shift
    shift
    ;;
    -v|--helm-version)
    helm_version="$2"
    shift
    shift
    ;;
    -c|--chart)
    chart_name="$2"
    shift
    shift
    ;;
    -s|--strategy)
    bump_strategy="$2"
    shift
    shift
    ;;
    -d|--base-dir)
    base_charts_dir="$2"
    shift
    shift
    ;;
    --print-chart-version)
    print_chart_version=true
    shift
    ;;
    --print-app-version)
    print_app_version=true
    shift
    ;;
    --verbose)
    verbose=true
    shift
    ;;
    --dry-run)
    dry_run=true
    shift
    ;;
    -h|--help)
    usage
    exit 0
    ;;
    *)
    err "Unknown option: $key"
    usage
    exit 1
    ;;
  esac
done

if [[ "$dry_run" == true ]]; then
  show "Running script in dry run mode"
fi

# check if required arguments are provided
if [[ -z "$chart_name" ]]; then
  err "Chart name not specified. Use the -c|--chart flag."
  usage
  exit 1
fi

chart_path="${base_charts_dir}/${chart_name}"
if [[ ! -d "$chart_path" ]]; then
  err "Chart not found: $chart_path"
  exit 1
fi

show "Updating chart $chart_path"


chart_yaml_path="${chart_path}/Chart.yaml"

# use latest git tag if helm_version is not specified
if [[ -z "$helm_version" ]]; then
  helm_version=$(grep -E '^version:' "$chart_yaml_path" | awk '{print $2}')
  if [[ -z "$helm_version" ]]; then
    err "Helm version not specified or available. Use the -v|--helm-version flag or ensure there are Git tags."
    usage
    exit 1
  fi
fi

helm_version=${helm_version#v}

# validate Helm chart version is a valid semver tag
semver_regex="^[0-9]+\.[0-9]+\.[0-9]+$"
if [[ ! $helm_version =~ $semver_regex ]]; then
  err "Invalid Helm chart version, expected semver ('X.Y.Z'), got: $helm_version"
fi

show "Current Helm chart version: $helm_version"

if [[ "$print_chart_version" == true ]]; then
  print_chart_version
  exit 0
fi

if [[ "$print_app_version" == true ]]; then
  print_app_version
  exit 0
fi

# extract current appVersion from Chart.yaml if not specified
if [[ -z "$app_version" ]]; then
  app_version=$(grep -E '^appVersion:' "$chart_yaml_path" | awk '{print $2}')
fi

app_version=${app_version#v}
show "New Helm chart appVersion: $app_version"

if [[ ! " ${strategy_options[*]} " =~ ${bump_strategy} ]]; then
  err "Invalid bumping strategy. Allowed strategies: ${strategy_options[*]}"
  usage
  exit 1
fi

show "Bumping $bump_strategy version in chart $chart_name"

# bump the version if a strategy is specified
helm_version=$(increment_version "$helm_version" "$bump_strategy")
show "New Helm chart version: $helm_version"

update_chart_yaml "$app_version" "$helm_version"