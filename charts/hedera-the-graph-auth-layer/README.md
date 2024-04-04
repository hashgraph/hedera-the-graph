# Hedera TheGraph Auth Layer
This chart deploys the Hedera TheGraph Auth Layer. It is comprised of two components: `auth-layer-proxy` and `auth-layer-server`. 
Together they provide a way to authenticate users and protect the Hedera TheGraph Admin API.

For a high level overview of the Hedera TheGraph Auth Layer, please refer to the [Hedera TheGraph Auth Layer documentation](https://github.com/hashgraph/hedera-the-graph/blob/main/docs/design/auth-layer.md)
For more information on the individual components, please refer to the [auth-layer-proxy](https://github.com/hashgraph/hedera-the-graph/blob/main/auth-layer-proxy/README.md) and [auth-layer-server](https://github.com/hashgraph/hedera-the-graph/blob/main/charts/auth-layer-server/README.md) documentation.

## Prerequisites
- Minikube or a Kubernetes cluster [(Install Minikube)](https://minikube.sigs.k8s.io/docs/start/)
- Kubectl [Install Kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
- Helm  [Install Helm](https://helm.sh/docs/intro/install/)
- A Hedera TheGraph Index Node Instance [Deploy Hedera-The-Graph nodes](https://github.com/hashgraph/hedera-the-graph/blob/main/charts/hedera-the-graph/README.md)

## Installing the Chart

Is recommended to use the `values.yaml` file to set the values you want to override. The following table lists the configurable parameters that most likely will need to be overridden.

| Parameter | Description | Default |
| --------- | ----------- | ------- |
| `auth-proxy.configEnv.SERVICE_TYPE` | The Type address of the downstream service, set as `DNS_LOGICAL` for a FQDN name, or `STATIC` for an IP address |
| `auth-proxy.configEnv.SERVICE_ADDRESS` | The downstream IP or DNS address of your Hedera-The-Graph `index-node` |
| `auth-proxy.configEnv.TOKEN_INTROSPECTION_URL` | The instrospect endpoint using the public DNS name of your Auth server, this is needed for verifying the token validity and claims |

To install the chart with the release name `my-release` and a random 32 length client secret, run the following command:

```bash
sh scripts/install.sh my-release
```

The above script will generate a random 32 length client secret and install the chart with the generated secret that will be shared between the `auth-layer-proxy` and `auth-layer-server` subcharts using the `global.auth.clientSecret` value.

Is also possible to use the script `scripts/install.sh` to install the chart with a values file and other overrides as needed, similar to the `helm install` command.

```bash
sh scripts/install.sh my-release -f values.yaml --set auth-server.keycloak.auth.adminPassword="<admin-password>"
```

Alternatively, you can specify the client secret by passing the `--set global.auth.clientSecret=<client-secret>` argument to the `helm install` command.
```bash
helm install my-release . --set global.auth.clientSecret="<client-secret>"
```
or using a override values file

```bash
helm install my-release . -f values.yaml
```

# Post Installation Configuration

Due to how the Keycloak server works is necessary that the `auth-layer-proxy` configuration is updated with the public DNS instrospect endpoint of the Keycloak server, this is done by exposing your `<release-name>-keycloak` service to a public DNS and updating the `auth-layer-proxy` configuration with the public DNS.

Assuming your keycloak service is exposed on the public DNS `https://keycloak.example.com`, you can update the `auth-layer-proxy` configuration with the following command:

```bash
helm upgrade <releaseName> . --set auth-proxy.configEnv.TOKEN_INTROSPECTION_URL="https://keycloak.example.com/realms/HederaTheGraph/protocol/openid-connect/token/introspect"
```

## Uninstalling the Chart
To uninstall the `my-release` deployment:

```bash
helm uninstall my-release
```
