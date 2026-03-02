# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

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

[Unreleased]: https://github.com/pdb-operator/helm-pdb-operator/compare/v0.1.0...HEAD
[0.1.0]: https://github.com/pdb-operator/helm-pdb-operator/releases/tag/v0.1.0
