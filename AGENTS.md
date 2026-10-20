# Working with testkube-cloud-charts

A legacy repository: the Control Plane charts moved to `testkube-cloud-api`, and only the demo profile `values.demo.v2.yaml` and the `gh-pages` Helm index are still live.

Owner: `@kubeshop/testkube-devops`, per `.github/CODEOWNERS`, which assigns it every path.

The seven sections below are: verifying a change, reproducing a bug, the repository map, the conventions reviewers enforce, what never to do, the pull request checks, and the skills and how to start a component.

## 1. Verifying a change

The only change worth making here is to the demo profile, and there is no automated check for it. Render it against the current chart:

```bash
helm repo add testkubeenterprise https://kubeshop.github.io/testkube-cloud-charts
helm repo update
helm template testkube testkubeenterprise/testkube-enterprise \
  -f charts/testkube-enterprise/profiles/values.demo.v2.yaml > /dev/null
```

Check every key against `helm/testkube-enterprise/values.yaml` in `testkube-cloud-api`. A key the current chart no longer reads is silently ignored.

After the merge, the `enterprise-installation-test` TestWorkflow in the `testkube` repo (`test/testkube/installation-tests/crd-workflow/enterprise-installation.yaml`) runs `testkube init demo` end to end.

## 2. Reproducing a bug

A demo install problem reproduces with `testkube init demo`, which reads the profile from this repo's `main`. The CLI has no flag for another URL, so a fix on a branch can only be installed with Helm directly, on a local cluster. The `helm template` command in section 1 catches a profile that does not render.

Installing the enterprise chart with the profile alone gives a Control Plane that starts but runs nothing: there is no runner, and the profile's bootstrap runner keeps its placeholder `secret_key`. To exercise workflow execution, do what `testkube init demo` does (`HelmUpgradeOrInstallTestkubeOnPremDemo` and `HelmUpgradeOrInstallTestkubeOnPremDemoRunner` in `testkube/cmd/kubectl-testkube/commands/common/helper.go`): pass the license, give the bootstrap runner a generated key, and install a separate `testkube-runner` with the same key and the IDs the CLI uses.

```bash
NS=testkube
# Reuse the key of an existing runner: the Control Plane bootstrapped its runner with it.
if kubectl get deployment testkube-demo-runner -n "$NS" >/dev/null 2>&1; then
  KEY="$(kubectl get deployment testkube-demo-runner -n "$NS" \
    -o jsonpath='{.spec.template.spec.containers[*].env[?(@.name=="TESTKUBE_PRO_API_KEY")].value}')"
  [ -n "$KEY" ] || { echo "runner key unreadable; delete namespace $NS and start again" >&2; exit 1; }
elif kubectl get deployment testkube-enterprise-api -n "$NS" >/dev/null 2>&1; then
  echo "Control Plane without a runner: its key is lost; delete namespace $NS and start again" >&2; exit 1
else
  KEY="tkckey_agent_$(LC_ALL=C tr -dc 'A-Za-z0-9' </dev/urandom | head -c 32)"
fi
helm repo add testkubeenterprise https://kubeshop.github.io/testkube-cloud-charts
helm repo add kubeshop https://kubeshop.github.io/helm-charts
helm repo update
helm upgrade --install testkube testkubeenterprise/testkube-enterprise \
  --namespace "$NS" --create-namespace --wait \
  -f charts/testkube-enterprise/profiles/values.demo.v2.yaml \
  --set global.enterpriseLicenseKey="<license key>" \
  --set "testkube-cloud-api.api.features.bootstrapConfig.config.organizations[0].runners[0].secret_key=$KEY" \
  --set testkube-cloud-api.api.agent.host="testkube-enterprise-api.$NS.svc.cluster.local" \
  --set testkube-cloud-api.api.minio.signing.hostname="testkube-enterprise-minio.$NS.svc.cluster.local:9000"
helm upgrade --install testkube-demo-runner kubeshop/testkube-runner \
  --namespace "$NS" --wait \
  --set fullnameOverride=testkube-demo-runner \
  --set runner.id=tkcrun_demo-runner --set runner.name=demo-runner \
  --set runner.orgId=tkcorg_demo --set runner.envId=tkcenv_my-first-environment \
  --set runner.secret="$KEY" \
  --set cloud.url="testkube-enterprise-api.$NS.svc.cluster.local:8089" \
  --set cloud.tls.enabled=false --set listener.enabled=true
```

The Control Plane bootstraps the runner and its key only once, on an empty database, so a new key on a rerun would be rejected. The first lines therefore reuse the deployed runner's key, and stop when it cannot be recovered, as `ResolveDemoAgentSecretKey` in the CLI does; a fresh namespace starts over with a new key. Run the block as a script with `bash`, since it exits when it stops. The license is the one `testkube init demo` asks for; a trial comes from https://testkube.io/download. The runner IDs must match the bootstrap runner in the profile (section 3). If the CLI's helpers change, follow them rather than this copy.

## 3. Repository map

The Control Plane charts moved to [`testkube-cloud-api`](https://github.com/kubeshop/testkube-cloud-api) under `helm/` (`testkube-enterprise` and its components, `hosted-runners-service`, `testkube-backoffice`, `testkube-usage-export`). That is where chart changes, their tests and their lint belong; see `helm/README.md` there. The charts under `charts/` here stopped being released in October 2025 (`testkube-enterprise` 2.319.44), and nothing deploys from them. `CONTRIBUTING.md` and `scripts/` describe that old release flow.

Two things here are still used, and changing either affects users directly:

- **`charts/testkube-enterprise/profiles/values.demo.v2.yaml`** is the values file for `testkube init demo`. The CLI downloads it from `main` at install time (`demoValuesUrl` in `testkube/cmd/kubectl-testkube/commands/init.go`).
  - It is applied to the **latest `testkube-enterprise` chart published from `testkube-cloud-api`**, not to the chart in this repo.
  - The runner declared under `bootstrapConfig` must match `demoRunnerID`/`OrgID`/`EnvID` in the CLI (`testkube` repo, see "On-prem demo install" in its `AGENTS.md`).
  - `values.demo.yaml` is the deprecated profile for older CLIs (bundled agent, MongoDB). Leave it alone unless an old CLI is broken by it.
- **The `gh-pages` branch** serves the legacy Helm repository `https://kubeshop.github.io/testkube-cloud-charts` (repo name `testkubeenterprise`), which the CLI and existing installs still use. Its `index.yaml` points at the OCI charts in Google Artifact Registry. `testkube-cloud-api`'s release workflow (`new-build.yaml`) dispatches `.github/workflows/index-update.yaml` here after every chart publish.

## 4. Conventions reviewers enforce

PR titles follow Conventional Commits, with the chart as the scope, for example `fix(testkube-enterprise): make the demo v2 profile start on Postgres only`. `lint-pr.yaml` checks the type; the scope is convention.

## 5. Never do these

- **Do not change a chart under `charts/`** to fix or add Control Plane behaviour: it will never ship. Make the change in `testkube-cloud-api` instead.
- **Do not merge an unchecked profile change.** The CLI reads the profile from `main`, so a merge changes every new demo install immediately, with no release.
- **Do not run `scripts/sync.sh`**, even though `CONTRIBUTING.md` says to. It writes to `charts/testkube-enterprise/local-values.yaml`, which no longer exists.
- **Do not edit `gh-pages` by hand.** `index-update.yaml` maintains it.
- **Do not push a `sandbox/*` branch.** It dispatches a sandbox update to `testkube-deployment`; sandboxes are created there with its `env-create.yaml` workflow.

## 6. Pull request checks and the MCP tools

There are no Testkube TestWorkflow checks for this repository, so the MCP tools do not apply. The GitHub Actions below still run but serve the old charts. Ignore their results for a demo-profile change. Times are from recent runs.

| Workflow | Trigger | What it does | Time |
| --- | --- | --- | --- |
| `lint-pr.yaml` | pull request | checks the PR title type | under 10 s |
| `lint.yaml` | pull request | chart-testing on `charts/` | about 30 s |
| `test.yaml` | pull request | tests `scripts/update.sh` | about 10 s |
| `lint-images.yaml` | every push | checks image registries, pull secrets and CVEs; it failed on every push in recent runs | 2.5 to 3 min |
| `dispatch-sandbox-push.yaml`, `dispatch-sandbox-delete.yaml` | `sandbox/**` branches | dispatch sandbox events to `testkube-deployment` | about 10 s |
| `dispatch-develop-push.yaml` | push to `main` | dispatches `testkube_charts_push` to `testkube-deployment` | about 10 s |
| `chart-release.yaml` | manual | releases the old charts | |
| `update-charts-dispatch.yaml` | repository dispatch | bumps app versions in the old charts | |

`index-update.yaml` is the one live workflow; see section 3.

## 7. Skills and starting a component

This repository has no skills. The only thing to start is the demo: `testkube init demo` installs the Control Plane with `values.demo.v2.yaml` and a separate runner. Section 2 has the same two installs with Helm, for a profile on a branch.
