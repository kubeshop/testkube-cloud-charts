# testkube-cloud-charts

# Helm installation

[Helm](https://helm.sh) must be installed to use the charts.  Please refer to
Helm's [documentation](https://helm.sh/docs) to get started.

Once Helm has been set up correctly, add the repo as follows:
```sh
helm repo add testkubeenterprise https://kubeshop.github.io/testkube-cloud-charts
```

If you had already added this repo earlier, run `helm repo update` to retrieve
the latest versions of the packages.  You can then run `helm search repo
testkubeenterprise` to see the charts.

To install the kubetest chart:
```sh
helm install my-<chart-name> teskubeenterprise/testkube-enterprise
```
To uninstall the kubetest chart:
```sh
helm uninstall my-<chart-name>
```
> Please note that this Helm chart will install all the needed charts. Including CRDs. It's an umbrella chart.