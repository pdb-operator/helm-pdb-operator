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

> Upgrading from 0.4.x or earlier? 0.5.0 changes how the PDBPolicy CRD is managed and needs a one-time step. See [UPGRADING.md](UPGRADING.md).

Create a PDBPolicy:

```yaml
apiVersion: availability.pdboperator.io/v1alpha1
kind: PDBPolicy
metadata:
  name: my-pdb-policy
spec:
  availabilityClass: standard
  workloadSelector:
    matchLabels:
      app: my-app
```

`availabilityClass` is one of `non-critical`, `standard`, `high-availability`, `mission-critical`, or `custom`. Both `availabilityClass` and `workloadSelector` are required.

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
| `networkPolicy.enabled` | Restrict metrics access via NetworkPolicy (webhook and probe ports stay reachable) | `false` |

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
| `crds.install` | Manage the PDBPolicy CRD as part of the release | `true` |
| `crdRoles.enabled` | Create admin/editor/viewer ClusterRoles | `true` |

For the full list of values, see [values.yaml](charts/pdb-operator/values.yaml).

## CRD Management

The PDBPolicy CRD is rendered as a normal template from `files/crd-pdbpolicy.yaml`, so Helm (and Flux) upgrade it on `helm upgrade` and remove it on `helm uninstall`. This is the default (`crds.install=true`).

The chart deliberately has no `crds/` directory. Helm auto-installs that directory on every `helm install` and never upgrades it, which both strands CRD schema changes and collides with the template. See [UPGRADING.md](UPGRADING.md) if you installed v0.3.0 or earlier.

To manage the CRD out of band instead (cluster admin, separate GitOps stage), set `crds.install=false` and apply it yourself:

```bash
kubectl apply -f charts/pdb-operator/files/crd-pdbpolicy.yaml
```

> `helm uninstall` deletes the CRD when `crds.install=true`, and deleting a CRD deletes every PDBPolicy in the cluster. Set `crds.install=false` if that is not what you want.

## Flux CD

Example GitOps configuration is available in [`charts/pdb-operator/ci/`](charts/pdb-operator/ci/):

- [`flux-gitrepository.yaml`](charts/pdb-operator/ci/flux-gitrepository.yaml)
- [`flux-helmrelease.yaml`](charts/pdb-operator/ci/flux-helmrelease.yaml)

## Documentation

Full documentation is available at [pdboperator.io](https://pdboperator.io):

- [Installation Guide](https://pdboperator.io/docs/getting-started/installation)

## Getting Help

- [GitHub Issues](https://github.com/pdb-operator/helm-pdb-operator/issues) for bug reports and feature requests

## Contributing

Contributions are welcome. Please read [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

## Security

To report a security vulnerability, please see [SECURITY.md](SECURITY.md).

## License

Copyright 2026 The PDB Operator Authors.

Licensed under the Apache License, Version 2.0. See [LICENSE](LICENSE) for details.
