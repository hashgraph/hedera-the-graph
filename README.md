<div align="center">

# Hedera The Graph

</div>

Tools for hosting a graph node for the Hedera community.

## Prerequisites

- [`helm`](https://helm.sh/)
- [`kubectl`](https://kubernetes.io/docs/reference/kubectl/)

Also it is recommended to get familiar with `graphman` CLI to manipulate Graph Node instances.
See <https://thegraph.com/docs/en/operating-graph-node> for more information.

## `hedera-the-graph` Helm chart

This project contains an umbrella helm charts that can be used to deploy an Hedera optimized graph node to a Kubernetes cluster with all the necessary architecture and configuration.
For more information see the [Hedera-The-Graph Chart Documentation](https://github.com/hashgraph/hedera-the-graph/tree/main/charts/hedera-the-graph)

## Release

This repo follows a git feature branch flow off of main.
All features should see a feature branch created and a PR taking the changes from the feature branch and applying it to main or the appropriate relese branch.

Periodically, release branches e.g. `release/0.1` will be created.

## Helm Charts

This repo contains a `charts` directory that contains the various charts that are used to deploy the Hedera-The-Graph node to a Kubernetes cluster. To get started first install the helm repo:

```sh
helm repo add hedera-the-graph https://hashgraph.github.io/hedera-the-graph/charts
helm repo update
```

Then you can install the chart with the following command:

```sh
helm install [RELEASE_NAME] hedera-the-graph/[CHART_NAME] -f [VALUES_FILE]
```

**CHART_NAME** is the name of the chart you want to install.
The available charts are:

- **hedera-the-graph:** An umbrella chart that installs all the necessary components to run the Hedera-The-Graph node. More information [here](https://github.com/hashgraph/hedera-the-graph/tree/main/charts/hedera-the-graph)
- **hedera-the-graph-node:** An optimized graph node for the Hedera network.
- **hedera-the-graph-auth-layer:** An umbrella chart that installs both the `auth-layer-proxy` and the `auth-layer-server`. More information [here](https://github.com/hashgraph/hedera-the-graph/tree/main/charts/hedera-the-graph-auth-layer)
- **auth-layer-proxy:** An EnvoyProxy that acts as a reverse proxy that forwards requests to the configured index node, and also verifies the JWT token using the configured authentication server. More informoation: [here](https://github.com/hashgraph/hedera-the-graph/tree/main/charts/auth-layer-proxy)
- **auth-layer-server:** A KeyCloak server that is pre-configured to work with the `auth-layer-proxy` to generate and verify JWT tokens used for protecting the index node. More information [here](https://github.com/hashgraph/hedera-the-graph/tree/main/charts/auth-layer-server)

**VALUES_FILE** is the path to the values file that you want to use to configure the chart. The values file should be a yaml file that contains the configuration for the chart. The available configuration options for each chart can be found in the chart's README file of the respective chart, linked above.

## Support

If you have a question on how to use the product, please see our
[support guide](https://github.com/hashgraph/.github/blob/main/SUPPORT.md).

## Contributing

Contributions are welcome. Please see the
[contributing guide](https://github.com/hashgraph/.github/blob/main/CONTRIBUTING.md)
to see how you can get involved.

## Code of Conduct

This project is governed by the
[Contributor Covenant Code of Conduct](https://github.com/hashgraph/.github/blob/main/CODE_OF_CONDUCT.md). By
participating, you are expected to uphold this code of conduct. Please report unacceptable behavior
to [oss@hedera.com](mailto:oss@hedera.com).

## License

[Apache License 2.0](LICENSE)

## 🔐 Security

Please do not file a public ticket mentioning the vulnerability.
Refer to the security policy defined in the [SECURITY.md](https://github.com/hashgraph/hedera-sourcify/blob/main/SECURITY.md).
