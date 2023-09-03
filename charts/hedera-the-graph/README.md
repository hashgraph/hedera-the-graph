
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
  enabled: false # Set to false if external ipfs is used
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


### Index and Query Nodes

Hedera The Graph node is composed of two components: an Index Node and a Query Node. The Index Node is responsible for indexing data from the Hedera network and storing it in a database. The Query Node is responsible for serving queries from the GraphQL API.

By default, both the Index Node and Query Node are enabled. If you wish to disable either of these components, set the following values:

```yaml
index-node:
  enabled: false

query-node:
  enabled: false
```

Also, is only possible to have a single replica of the Index Node. But is possible to have as many replicas of the Query Node as desired. To set the number of replicas for the Query Node, set the following value:

```yaml
query-node:
  replicas: 2
```

The default number of replicas for the Query Node is 1.

#### Values if you don't want dedicated query node.
Is possible to do queries using the index node, so for small testing environments is possible to disable the query node and use the index node for querys.

  ```yaml
  query-node:
    enabled: false
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
