# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [0.2.2] - 2026-06-21

### Added

- ClusterRole now grants `apps/statefulsets/finalizers` (`get`, `patch`, `update`), completing the `blockOwnerDeletion` finalizers RBAC for StatefulSet-owned PDBs on clusters that enforce it (e.g. OpenShift). Complements the `deployments/finalizers` rule from 0.2.1.
- RBAC unit test asserting the finalizers rules.

### Changed

- Bumped chart `version` to `0.2.2`.

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

[Unreleased]: https://github.com/pdb-operator/helm-pdb-operator/compare/v0.2.2...HEAD
[0.2.2]: https://github.com/pdb-operator/helm-pdb-operator/compare/v0.2.1...v0.2.2
[0.2.1]: https://github.com/pdb-operator/helm-pdb-operator/compare/v0.2.0...v0.2.1
[0.2.0]: https://github.com/pdb-operator/helm-pdb-operator/compare/v0.1.0...v0.2.0
[0.1.0]: https://github.com/pdb-operator/helm-pdb-operator/releases/tag/v0.1.0
