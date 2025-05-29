
# Hedera The Graph Chart

This is a Helm chart for deploying a Hedera The Graph node, which is a node that indexes data from the Hedera network and makes it available for querying via GraphQL.

## Prerequisites

- Kubernetes cluster (for example, [Minikube](https://minikube.sigs.k8s.io/docs/))
- Kubernetes CLI ([kubectl](https://kubernetes.io/docs/tasks/tools/))
- Helm 3 ([Helm](https://helm.sh/docs/intro/install/))

## Configuration

> [!TIP]
> You can also override any value in the chart using the `--set*` flags when executing a [`helm install`](https://helm.sh/docs/helm/helm_install).

### Values for installing all components

No need to change any values if want to install all components and auto-generate a password for the Postgres database.

If wish to provide a custom password for the postgres database, set the following values:

```yaml
global:
  postgresql:    
    password: "" # Randomly generated if left blank, Requiered if external postgresql is used

```

Or alternatively,

```sh
helm install <RELEASE-NAME> . --set-string global.postgresql.password=1234
```

### Values when using external ipfs server

Example to use `ipfs.infura.io` as external ipfs server.

```yaml
ipfs:
  enabled: false # Set to false if external ipfs is used
  host: "ipfs.infura.io" # Auto-generated from the ipfs sub-charts, Requiered if external ipfs is used
  port: 5001
```

### Values when using internal IPFS server on a ARM64 host

By default, the IPFS node runs only on AMD64 hosts.
If you are running on an ARM64 architecture, such as Apple Silicon Macs,
you will need to change the arch selector.
You can do so by running the following

```sh
helm install <RELEASE-NAME> . -f values-overrides/arm-arch.yaml 
```

### Values when using external postgres server

Example to use `postgresql://postgres:password@remotehost:5432/graph-node` as external postgres server.

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

#### Values if you do not want dedicated query node

Is possible to do queries using the index node,
so for small testing environments is possible to disable the query node and use the index node for queries.

  ```yaml
  query-node:
    enabled: false
  ```

## RPC Provider Configuration Overview

This section details the override values specified for different network environments: previewnet, testnet, and mainnet. The configuration files are organized as follows

```plain
    /values-overrides
        /values-mainnet.yaml
        /values-previewnet.yaml
        /values-testnet.yaml
```

### Support for Archive Feature

The Hedera JSON RPC Relay now includes support for the archive feature, as outlined in [HIP-584](https://hips.hedera.com/hip/hip-584). By default, the configuration for all networks enables the `archive` feature for the RPC node. However, it is possible to disable this feature if needed.

#### Disabling Archive Feature

To disable the archive feature, adjust the configuration as demonstrated below for the `testnet` environment:

```yaml
index-node:
  config:
    chains:
      testnet:
        providers:
          - features: []
            label: hedera-testnet
            transport: rpc
            url: https://testnet.hashio.io/api
```

#### Additional Resources

More information on thegraph node documentation for [configuration toml - providers](https://github.com/graphprotocol/graph-node/blob/master/docs/config.md#configuring-ethereum-providers)

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
helm install my-release hedera-the-graph 
```

By default it will use testnet, to use mainnet set the following value file:

```bash
helm install sl-htg3 charts/hedera-the-graph -f charts/hedera-the-graph/values-overrides/values-mainnet.yaml  
```

same for previewnet:

```bash
helm install sl charts/hedera-the-graph -f charts/hedera-the-graph/values-overrides/values-previewnet.yaml  
```

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```bash
helm uninstall my-release
```

### Re-installing the Chart using a random password

If a random password was used when installing the chart,
you need to ensure Postgres can be started properly when re-installing it.

The issue comes from Helm not removing all the corresponding Persistent Volume Claims.
This leads to an error when `install`ing a chart after `uninstall`ing it.
The Postgres pod is not able to start triggering the following error

```console
$ kubectl logs <postgres-pod-name>
[...]
postgresql-repmgr 19:12:42.47 INFO  ==> ** Starting repmgrd **
[2025-05-28 19:12:42] [NOTICE] repmgrd (repmgrd 5.3.3) starting up
[2025-05-28 19:12:42] [ERROR] connection to database failed
[2025-05-28 19:12:42] [DETAIL] 
2025-05-28 19:12:42.478 GMT [155] FATAL:  password authentication failed for user "repmgr"
2025-05-28 19:12:42.478 GMT [155] DETAIL:  Connection matched pg_hba.conf line 1: "host     all            repmgr    0.0.0.0/0    md5"
connection to server at "thegraph-29-postgres-postgresql-0.thegraph-29-postgres-postgresql-headless.default.svc.cluster.local" (10.244.0.11), port 5432 failed: FATAL:  password authentication failed for user "repmgr"
[...]
```

After re-installing, a new password is generated but the stored password in the PVC is the older **random** one.

You should ensure both PVs and PVCs are properly removed after uninstalling the chart.

> [!TIP]
> You can delete the PVC manually after uninstalling the chart `<RELEASE-NAME>` using the following command
>
> ```sh
> kubectl delete pvc data-<RELEASE-NAME>-postgres-postgresql-0
> ```
>
> You can get the list of all PVCs using
>
> ```sh
> kubectl get pvc
> ```
>
> Alternatively, if you want to be completely sure no data from previous deployments are left, you can recreate Minikube. To do so, run
>
> ```sh
> minikube delete
> minikube start
> ```

See [_&sect; Values for installing all components_](#values-for-installing-all-components) to set a non-random password that can be reused across chart installations.

## Port Forwarding

If you want to deploy subgraphs on your local instance, you may want to forward the following ports

```sh
kubectl port-forward $QUERY_POD 8000 8020
kubectl port-forward $IPFS_POD 5001
```

This will enable connections to

- the GraphQL HTTP server at port `:8000`, used to query subgraphs, and
- the JSON-RPC admin server at port `:8020`, used to create and deploy subgraphs.

Moreover, if you want to access the Postgres database, you will need to forward the following port

```sh
kubectl port-forward $PG_POD 5432
```
