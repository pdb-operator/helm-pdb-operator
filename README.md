# Helm Chart for PDB Operator

<p align="center">
  <strong>
    <a href="#quick-start">Getting Started</a>
    &nbsp;&nbsp;&bull;&nbsp;&nbsp;
    <a href="#configuration">Configuration</a>
    &nbsp;&nbsp;&bull;&nbsp;&nbsp;
    <a href="CONTRIBUTING.md">Contributing</a>
  </strong>
</p>

<p align="center">
  <a href="https://github.com/pdb-operator/helm-pdb-operator/actions/workflows/lint-test.yml?query=branch%3Amain">
    <img alt="Lint & Test" src="https://img.shields.io/github/actions/workflow/status/pdb-operator/helm-pdb-operator/lint-test.yml?branch=main&style=for-the-badge&label=lint%20%26%20test">
  </a>
  <a href="https://github.com/pdb-operator/helm-pdb-operator/releases">
    <img alt="Chart Version" src="https://img.shields.io/github/v/release/pdb-operator/helm-pdb-operator?include_prereleases&style=for-the-badge&label=chart">
  </a>
  <a href="LICENSE">
    <img alt="License" src="https://img.shields.io/badge/License-Apache%202.0-blue.svg?style=for-the-badge">
  </a>
</p>

---

Helm chart for [PDB Operator](https://github.com/pdb-operator/pdb-operator), a Kubernetes operator that automatically creates and manages PodDisruptionBudgets based on PDBPolicy custom resources. For full documentation, visit [pdboperator.io](https://pdboperator.io).

## Prerequisites

- Kubernetes >= 1.26
- Helm >= 3.x
- [cert-manager](https://cert-manager.io/) (required when webhooks are enabled)

## Quick Start

```bash
# Install from OCI registry
helm install pdb-operator oci://ghcr.io/pdb-operator/charts/pdb-operator \
  --namespace pdb-operator-system \
  --create-namespace

# Verify the operator is running
kubectl get pods -n pdb-operator-system
```

Create a PDBPolicy:

```yaml
apiVersion: availability.pdboperator.io/v1alpha1
kind: PDBPolicy
metadata:
  name: my-pdb-policy
spec:
  targetReference:
    kind: Deployment
  pdbSpec:
    minAvailable: "50%"
  selector:
    matchLabels:
      app: my-app
```

## Configuration

### Core Settings

| Parameter | Description | Default |
|-----------|-------------|---------|
| `replicaCount` | Number of operator replicas | `2` |
| `image.repository` | Container image repository | `ghcr.io/pdb-operator/pdb-operator` |
| `image.tag` | Image tag (defaults to appVersion) | `""` |
| `image.pullPolicy` | Image pull policy | `IfNotPresent` |

### Controller

| Parameter | Description | Default |
|-----------|-------------|---------|
| `controller.maxConcurrentReconciles` | Max concurrent reconcile loops | `5` |
| `controller.watchNamespace` | Watch only this namespace (empty = all) | `""` |
| `controller.syncPeriod` | Sync period for re-reconciliation | `10h` |
| `controller.logLevel` | Log level: debug, info, warn, error | `info` |

### Cache

| Parameter | Description | Default |
|-----------|-------------|---------|
| `cache.policyCacheTTL` | Policy cache TTL | `5m` |
| `cache.policyCacheSize` | Policy cache max size | `100` |
| `cache.maintenanceWindowCacheTTL` | Maintenance window cache TTL | `1m` |

### Retry

| Parameter | Description | Default |
|-----------|-------------|---------|
| `retry.maxAttempts` | Max retry attempts | `5` |
| `retry.initialDelay` | Initial delay between retries | `100ms` |
| `retry.maxDelay` | Max delay between retries | `30s` |
| `retry.backoffFactor` | Backoff multiplier | `2.0` |

### Tracing

| Parameter | Description | Default |
|-----------|-------------|---------|
| `tracing.enabled` | Enable OpenTelemetry tracing | `true` |
| `tracing.endpoint` | OTLP collector endpoint | `""` |
| `tracing.sampleRate` | Trace sampling rate (0.0-1.0) | `""` |

### Webhooks

| Parameter | Description | Default |
|-----------|-------------|---------|
| `webhooks.enabled` | Enable admission webhooks | `true` |
| `webhooks.failurePolicy` | Failure policy: Fail or Ignore | `Fail` |
| `webhooks.timeoutSeconds` | Webhook timeout | `10` |
| `certManager.enabled` | Use cert-manager for TLS | `true` |
| `certManager.selfSigned` | Use self-signed issuer | `true` |

### Metrics & Monitoring

| Parameter | Description | Default |
|-----------|-------------|---------|
| `metrics.bindAddress` | Metrics bind address | `:8443` |
| `metrics.secure` | Serve metrics over HTTPS | `true` |
| `serviceMonitor.enabled` | Create ServiceMonitor | `false` |
| `prometheusRule.enabled` | Create PrometheusRule with alerts | `false` |
| `networkPolicy.enabled` | Create NetworkPolicy for metrics | `false` |

### High Availability

| Parameter | Description | Default |
|-----------|-------------|---------|
| `autoscaling.enabled` | Enable HPA | `true` |
| `autoscaling.minReplicas` | Minimum replicas | `2` |
| `autoscaling.maxReplicas` | Maximum replicas | `4` |
| `podDisruptionBudget.enabled` | Enable PDB for the operator | `true` |
| `podDisruptionBudget.minAvailable` | Min available pods | `1` |
| `leaderElection.enabled` | Enable leader election | `true` |
| `strategy.type` | Deployment strategy | `RollingUpdate` |

### CRDs

| Parameter | Description | Default |
|-----------|-------------|---------|
| `crds.install` | Manage CRDs as Helm templates | `false` |
| `crdRoles.enabled` | Create admin/editor/viewer ClusterRoles | `true` |

For the full list of values, see [values.yaml](charts/pdb-operator/values.yaml).

## CRD Management

By default, CRDs are placed in the `crds/` directory and installed only on first `helm install` (Helm does not upgrade CRDs automatically). To upgrade CRDs after a chart update:

```bash
kubectl apply -f charts/pdb-operator/crds/
```

Alternatively, set `crds.install=true` to manage CRDs as Helm templates. This allows Helm (and Flux) to upgrade and delete CRDs as part of the release lifecycle.

## Flux CD

Example GitOps configuration is available in [`charts/pdb-operator/ci/`](charts/pdb-operator/ci/):

- [`flux-gitrepository.yaml`](charts/pdb-operator/ci/flux-gitrepository.yaml)
- [`flux-helmrelease.yaml`](charts/pdb-operator/ci/flux-helmrelease.yaml)

## Documentation

Full documentation is available at [pdboperator.io](https://pdboperator.io):

- [Installation Guide](https://pdboperator.io/docs/getting-started/installation)
- [API Reference](https://pdboperator.io/docs/api-reference/pdbpolicy)
- [Design Document](https://pdboperator.io/docs/design)

## Getting Help

- [GitHub Issues](https://github.com/pdb-operator/helm-pdb-operator/issues) for bug reports and feature requests
- [GitHub Discussions](https://github.com/pdb-operator/helm-pdb-operator/discussions) for questions and general discussion

## Contributing

Contributions are welcome. Please read [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

## Security

To report a security vulnerability, please see [SECURITY.md](SECURITY.md).

## License

Copyright 2025 Nick Nikolakakis

Licensed under the Apache License, Version 2.0. See [LICENSE](LICENSE) for details.
