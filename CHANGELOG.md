# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [0.6.1] - 2026-10-04

### Changed

- Track operator `v0.5.1` (`appVersion`): security dependency bumps for GO-2026-6505 (OpenTelemetry) and GO-2026-6348 (gRPC), plus Kubernetes libraries v0.37.1 and controller-runtime v0.25.2. See the [operator changelog](https://github.com/pdb-operator/pdb-operator/blob/main/CHANGELOG.md) for details.

## [0.6.0] - 2026-08-29

### Changed

- Track operator `v0.5.0` (`appVersion`): gang-aware PDBs from the upstream Workload API (`scheduling.k8s.io/v1beta1`, Kubernetes 1.37 with the `GenericWorkload` gate) and distinct event reasons per Workload skip cause. See the [operator changelog](https://github.com/pdb-operator/pdb-operator/blob/main/CHANGELOG.md) for details.

### Added

- ClusterRole rules for the upstream Workload API needed by operator v0.5.0's gang-aware PDBs: read on core `pods` and `scheduling.k8s.io` `podgroups`, read/patch/update on `workloads`, and `workloads/finalizers` for `blockOwnerDeletion` (#24)

## [0.5.0] - 2026-08-15

### Changed

- Track operator `v0.4.1` (`appVersion`): managed-workload gauges fix. See the [operator changelog](https://github.com/pdb-operator/pdb-operator/blob/main/CHANGELOG.md) for details.
- **BREAKING:** `crds.install` now defaults to `true` and the PDBPolicy CRD moved from `crds/` to `files/crd-pdbpolicy.yaml`, so Helm upgrades the CRD schema on `helm upgrade`. Existing installs need a one-time ownership adoption, and `helm uninstall` now deletes the CRD (and with it every PDBPolicy). See [UPGRADING.md](UPGRADING.md)

### Fixed

- `crds.install=true` could never be used: the chart shipped the CRD in both `crds/` (which Helm auto-installs on every install) and `templates/`, so the release failed with `cannot be imported into the current release: invalid ownership metadata`
- `networkPolicy.enabled=true` denied the kube-apiserver access to the admission webhook port, so with the default `webhooks.failurePolicy: Fail` every PDBPolicy admission request failed. The policy now also admits the webhook and health probe ports
- Link check no longer fails the build on transient network errors: results are cached between runs and lychee is configured with explicit retries and `GET` (`lychee.toml`)

## [0.4.0] - 2026-08-15

### Added
- ClusterRole rules for `leaderworkerset.x-k8s.io` (`leaderworkersets` + `leaderworkersets/finalizers`), required by the operator's group-aware PDB support for LeaderWorkerSet ([pdb-operator#82](https://github.com/pdb-operator/pdb-operator/pull/82)) (#17)

### Changed
- Track operator `v0.4.0` (`appVersion`): group-aware PDBs for LeaderWorkerSet (multi-host inference) and the Go 1.26.6 security bump. See the [operator changelog](https://github.com/pdb-operator/pdb-operator/blob/main/CHANGELOG.md) for details.

## [0.3.0] - 2026-06-27

### Changed

- Track operator `v0.3.0` (`appVersion`): PDBPolicy maintenance windows are now evaluated (timezone, `daysOfWeek`, multiple and overnight windows), with proactive start-of-window requeue; plus the operator's `make deploy` webhook-enable fix, OpenTelemetry tracing fix, and state-tracker error propagation. See the [operator changelog](https://github.com/pdb-operator/pdb-operator/blob/main/CHANGELOG.md) for details.

## [0.2.3] - 2026-06-21

### Fixed

- Corrected the post-install `NOTES.txt` PDBPolicy example to use the real CRD fields (`availabilityClass` / `workloadSelector`) instead of the non-existent `targetReference` / `pdbSpec` / `selector`, so the printed snippet applies cleanly (#9)

## [0.2.2] - 2026-06-21

### Added

- ClusterRole now grants `apps/statefulsets/finalizers` (`get`, `patch`, `update`), completing the `blockOwnerDeletion` finalizers RBAC for StatefulSet-owned PDBs on clusters that enforce it (e.g. OpenShift). Complements the `deployments/finalizers` rule from 0.2.1.
- RBAC unit test asserting the finalizers rules.

### Changed

- Bumped chart `version` to `0.2.2` and `appVersion` to `v0.2.2` (operator finalizers RBAC release).

## [0.2.1] - 2026-06-21

### Added

- ClusterRole grants `apps/deployments/finalizers` (`get`, `patch`, `update`), required to set `blockOwnerDeletion` on Deployment-owned PDB references on clusters that enforce it (e.g. OpenShift) (#6, thanks @nenioscio)

### Changed

- Bumped `appVersion` to `v0.2.1` (operator image tag) and chart `version` to `0.2.1` to ship the operator's Deployment scale-down PDB cleanup fix

## [0.2.0] - 2026-06-20

### Added

- ClusterRole now grants `apps/statefulsets` (`get`, `list`, `watch`, `update`, `patch`) so the operator can manage PDBs for StatefulSets (pdb-operator v0.2.0 StatefulSet support)
- RBAC unit test asserting the StatefulSet rule

### Changed

- Bumped `appVersion` to `v0.2.0` (operator image tag) and chart `version` to `0.2.0`

## [0.1.0] - 2026-03-02

### Added

- Helm chart for PDB Operator with full template set
- Configurable values for all operator features (tracing, caching, retry, webhooks, metrics)
- cert-manager integration for automatic TLS certificate management
- PrometheusRule with default alert definitions
- ServiceMonitor for Prometheus scraping
- HPA, PDB, and NetworkPolicy support
- CRD user-facing roles (admin, editor, viewer)
- Helm unit tests
- Flux CD CI examples
- GitHub Actions workflows (lint-test, release, DCO, check-links, community)
- CNCF governance files

[Unreleased]: https://github.com/pdb-operator/helm-pdb-operator/compare/v0.6.1...HEAD
[0.6.1]: https://github.com/pdb-operator/helm-pdb-operator/compare/v0.6.0...v0.6.1
[0.6.0]: https://github.com/pdb-operator/helm-pdb-operator/compare/v0.5.0...v0.6.0
[0.5.0]: https://github.com/pdb-operator/helm-pdb-operator/compare/v0.4.0...v0.5.0
[0.4.0]: https://github.com/pdb-operator/helm-pdb-operator/compare/v0.3.0...v0.4.0
[0.3.0]: https://github.com/pdb-operator/helm-pdb-operator/compare/v0.2.3...v0.3.0
[0.2.3]: https://github.com/pdb-operator/helm-pdb-operator/compare/v0.2.2...v0.2.3
[0.2.2]: https://github.com/pdb-operator/helm-pdb-operator/compare/v0.2.1...v0.2.2
[0.2.1]: https://github.com/pdb-operator/helm-pdb-operator/compare/9742bda7c389fe4fb4c61f07a9c940f9bef58719...v0.2.1
[0.2.0]: https://github.com/pdb-operator/helm-pdb-operator/compare/v0.1.0...9742bda7c389fe4fb4c61f07a9c940f9bef58719
[0.1.0]: https://github.com/pdb-operator/helm-pdb-operator/releases/tag/v0.1.0
