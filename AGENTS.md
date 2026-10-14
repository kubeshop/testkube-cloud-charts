# Working with testkube-cloud-charts

## This repository is legacy

The Control Plane charts moved to [`testkube-cloud-api`](https://github.com/kubeshop/testkube-cloud-api)
under `helm/` (`testkube-enterprise` and its components, `hosted-runners-service`,
`testkube-backoffice`, `testkube-usage-export`). That is where chart changes, their tests and
their lint belong; see `helm/README.md` there. The charts under `charts/` here stopped being
released in October 2025 (`testkube-enterprise` 2.319.44), and nothing deploys from them.

Do not change a chart under `charts/` to fix or add Control Plane behaviour: it will never ship.
Make the change in `testkube-cloud-api` instead.

## What is still live

Two things here are still used, and changing either affects users directly:

- **`charts/testkube-enterprise/profiles/values.demo.v2.yaml`** is the values file for
  `testkube init demo`. The CLI downloads it from this repo's `main` branch at install time
  (`demoValuesUrl` in `testkube/cmd/kubectl-testkube/commands/init.go`), so a merge to `main`
  changes every new demo install immediately, with no release.
  - It is applied to the **latest `testkube-enterprise` chart published from
    `testkube-cloud-api`**, not to the chart in this repo. Check every key against
    `helm/testkube-enterprise/values.yaml` in `testkube-cloud-api`. A key the current chart no
    longer reads is silently ignored.
  - The runner declared under `bootstrapConfig` must match `demoRunnerID`/`OrgID`/`EnvID` in
    the CLI (`testkube` repo, see "On-prem demo install" in its `AGENTS.md`).
  - `values.demo.yaml` is the deprecated profile for older CLIs (bundled agent, MongoDB). Leave
    it alone unless an old CLI is broken by it.
- **The `gh-pages` branch** serves the legacy Helm repository
  `https://kubeshop.github.io/testkube-cloud-charts` (repo name `testkubeenterprise`), which the
  CLI and existing installs still use. Its `index.yaml` points at the OCI charts in Google
  Artifact Registry. `testkube-cloud-api`'s release workflow (`new-build.yaml`) dispatches
  `.github/workflows/index-update.yaml` here after every chart publish. Do not edit `gh-pages`
  by hand.

## Verifying a change to the demo profile

There is no automated check for it. Render it against the current chart:

```bash
helm repo add testkubeenterprise https://kubeshop.github.io/testkube-cloud-charts
helm repo update
helm template testkube testkubeenterprise/testkube-enterprise \
  -f charts/testkube-enterprise/profiles/values.demo.v2.yaml > /dev/null
```

The CLI always reads the file from `main` and has no flag for another URL, so a branch can only
be installed with Helm directly: `helm install` the same chart with `-f` pointing at your copy,
on a local cluster. After the merge, the `enterprise-installation-test` TestWorkflow in the
`testkube` repo (`test/testkube/installation-tests/crd-workflow/enterprise-installation.yaml`)
runs `testkube init demo` end to end.

## Workflows that no longer do anything useful

These still run but serve the old charts: `lint.yaml` (chart-testing on `charts/`),
`lint-images.yaml`, `test.yaml` (the `update.sh` test), `chart-release.yaml`,
`update-charts-dispatch.yaml`, and the `sandbox/**` dispatches (sandboxes are created in
`testkube-deployment` with its `env-create.yaml` workflow). Ignore their results for a
demo-profile change. `scripts/sync.sh` also writes to `charts/testkube-enterprise/local-values.yaml`,
which no longer exists.

## PR title format

Conventional Commits, with the chart as the scope, for example
`fix(testkube-enterprise): make the demo v2 profile start on Postgres only`. `lint-pr.yaml`
checks the type; the scope is convention.
