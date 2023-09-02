
# Hedera The Graph Chart

This is a Helm chart for deploying a Hedera The Graph node, which is a node that indexes data from the Hedera network and makes it available for querying via GraphQL.

## Prerequisites

- Kubernetes cluster (for example, [Minikube](https://minikube.sigs.k8s.io/docs/))
- Kubernetes CLI ([kubectl](https://kubernetes.io/docs/tasks/tools/))
- Helm 3 ([Helm](https://helm.sh/docs/intro/install/))

## Configuration

### Values for installing all components.

No need to change any values if want to install all components and auto-generate a password for the postgres database.

If wish to provide a custom password for the postgres database, set the following values:

```yaml
global:
  postgresql:    
    password: "" # Randomly generated if left blank, Requiered if external postgresql is used

```

### Values when using external ipfs server.

example to use `ipfs.infura.io` as external ipfs server.

```yaml
ipfs:
  enabled: true # Set to false if external ipfs is used
  host: "ipfs.infura.io" # Auto-generated from the ipfs sub-charts, Requiered if external ipfs is used
  port: 5001
```

### Values when using external postgres server.

example to use `postgresql://postgres:password@remotehost:5432/graph-node` as external postgres server.

```yaml
global:
    postgresql:
        enabled: false 
        host: "remotehost"
        username: "postgres"
        password: "password"
        database: "graph-node"
    ```
```

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
$ helm install my-release hedera-the-graph 
```

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```bash
$ helm uninstall my-release
```
