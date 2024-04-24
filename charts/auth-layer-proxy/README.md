# HederaTheGraph (HTG) Authentication Layer Proxy Helm Chart

This chart deploys the HederaTheGraph (HTG) Authentication Layer Proxy to your Kubernetes cluster.
Is based on the project [auth-layer-proxy](link) and is a proxy that adds authentication to the requests made to the TheGraph Admin API.

## Prerequisites
- Minikube or a Kubernetes cluster [(more here)](https://minikube.sigs.k8s.io/docs/start/)
- Helm 3 [(install instructions here)](https://helm.sh/docs/intro/install/)
- kubectl [(install instructions here)](https://kubernetes.io/docs/tasks/tools/)
- HederaTheGraph Authentication Layer Server [(more here)](https://github.com/hashgraph/hedera-the-graph/tree/main/charts/auth-layer-server)
- HederaTheGraph [(more here)](https://github.com/hashgraph/hedera-the-graph/tree/main/charts/hedera-the-graph)

## Installation

To install the Authentication Layer Proxy, run the following commands:

```bash
helm install htg-auth-proxy . --set configSecrets.clientSecret="<your-client-secret>"
```


### Helm Chart Overrides
As part of the installation, you can override the default values of the chart.

Is recommended to use the `values.yaml` file to set the values you want to override.
The following table lists the configurable parameters of the chart and their default values.

| Parameter | Description | Default |
| --------- | ----------- | ------- |
| `image.repository` | The image repository to pull from | `hederahtg/auth-layer-proxy` |
| `image.tagPrefix` | The image prefix within the repo to pull | `auth-layer-proxy-` |
| `image.tag` | The image tag to pull | `main` |
| `image.pullPolicy` | The image pull policy | `IfNotPresent` |
| `service.type` | The service type | `ClusterIP` |
| `service.proxyPort` | Service port for the proxy endpoint | `10000` |
| `service.adminPort` | Service port for the envoy admin endpoint | `15000` |
| `configEnv` | Configuration environment variables | `[]` |
| `configEnv.SERVICE_TYPE` | EnvoyProxy Configuration downstream address type, can be `LOGICAL_DNS` for a FQDN or `STATIC` when using an IP address | `LOGICAL_DNS` |
| `configEnv.SERVICE_ADDRESS` | EnvoyProxy Configuration downstream address, can be either a FQDN or an IP | `host.docker.internal` |
| `configEnv.SERVICE_PORT` | EnvoyProxy Configuration downstream port, this would be the admin port on TheGraph indexer node | `8020` |
| `configEnv.ENVOY_ADMIN_PORT` | EnvoyProxy Configuration admin port | `15000` |
| `configEnv.PROXY_PORT` | EnvoyProxy Configuration proxy port | `10000` |
| `configEnv.CLIENT_ID` | OAuth Client ID, provided by the auth server | `htg-auth-layer` |
| `configEnv.TOKEN_INTROSPECTION_URL` | OAuth Token Introspection URL, provided by the auth server | `http://host.docker.internal:8080/realms/HederaTheGraph/protocol/openid-connect/token/introspect` |
| `configSecrets.clientSecret` | OAuth Client Secret, provided by the auth server | `` |
| `global.auth.clientSecret` | Global OAuth Client Secret, provided by the auth server, has precedence over `configSecrets.clientSecret` | `` |

*It is important to note that if the downstream service that we are protecting (in this case TheGraph) will be accessed by the proxy using a FQDN, the `SERVICE_TYPE` should be set to `LOGICAL_DNS` and the `SERVICE_ADDRESS` should be set to the FQDN of the service. Otherwise, if the downstream service is accessed by the proxy using an IP address, the `SERVICE_TYPE` should be set to `STATIC` and the `SERVICE_ADDRESS` should be set to the IP address of the service.*

### Client Secret Configuration
`auth-layer-proxy` needs a valid `clientSecret` to be able to authenticate with the auth server. This can be provided as a `configSecrets.clientSecret` or as a global `global.auth.clientSecret`.

`global.auth.clientSecret` has precedence over `configSecrets.clientSecret`.

#### Install with Client Secret
```bash
helm install htg-auth-proxy . --set configSecrets.clientSecret="<your-client-secret>"
```

#### Install with Global Client Secret
```bash
helm install htg-auth-proxy . --set global.auth.clientSecret="<your-client-secret>"
```
### None Provided
If none is provided, the installation will fail with the following error:
```
A valid client secret must be provided either via .Values.global.auth.clientSecret or .Values.configSecrets.clientSecret
```
#### Update Client Secret
*Once the chart is installed, the `clientSecret` can be updated using the following command:*
```bash
helm upgrade <releaseName> . --set configSecrets.clientSecret="<your-client-secret>"
```
