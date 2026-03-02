# Contributing to helm-pdb-operator

Thank you for your interest in contributing to the PDB Operator Helm chart.

## Prerequisites

- [Helm](https://helm.sh/) 3.x
- [helm-unittest](https://github.com/helm-unittest/helm-unittest) plugin
- [ct](https://github.com/helm/chart-testing) (chart-testing)

## Development

```bash
helm lint charts/pdb-operator                    # Lint the chart
helm unittest charts/pdb-operator                # Run unit tests
helm template test charts/pdb-operator           # Render templates locally
```

## Making Changes

1. Fork the repository
2. Create a feature branch from `main`
3. Make your changes
4. Verify linting and tests pass
5. Open a PR against `main`

## Commit Messages

Follow [Conventional Commits](https://www.conventionalcommits.org/):

- `feat:` new feature or value
- `fix:` bug fix
- `docs:` documentation changes
- `ci:` CI/CD changes
- `chore:` maintenance tasks

## Developer Certificate of Origin (DCO)

All commits must include a `Signed-off-by` line:

```bash
git commit -s -m "feat: add support for custom tolerations"
```

## Code of Conduct

This project follows the [Contributor Covenant Code of Conduct](https://github.com/pdb-operator/helm-pdb-operator/blob/main/CODE_OF_CONDUCT.md).
