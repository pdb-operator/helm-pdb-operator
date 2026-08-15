# Upgrading

## 0.3.x -> 0.4.0

### The PDBPolicy CRD is now managed by the release

`crds.install` now defaults to `true`, and the CRD moved from `charts/pdb-operator/crds/` to `charts/pdb-operator/files/crd-pdbpolicy.yaml`.

Before 0.4.0 the chart shipped the CRD in both places at once. Helm installs everything in `crds/` automatically on every `helm install` and does not add release ownership metadata to it, so setting `crds.install=true` made the template collide with the copy Helm had just installed:

```
Error: rendered manifests contain a resource that already exists.
Unable to continue with install: CustomResourceDefinition
"pdbpolicies.availability.pdboperator.io" ... cannot be imported into the
current release: invalid ownership metadata
```

There is now a single source for the CRD, so the toggle works in both directions.

#### If you installed 0.3.x or earlier, do this first

Your CRD was created by Helm's `crds/` auto-install and carries no release ownership metadata. `helm upgrade` will refuse to adopt it with the error above. Hand it to Helm once, substituting your release name and namespace:

```bash
kubectl annotate crd pdbpolicies.availability.pdboperator.io \
  meta.helm.sh/release-name=<release> \
  meta.helm.sh/release-namespace=<namespace> --overwrite

kubectl label crd pdbpolicies.availability.pdboperator.io \
  app.kubernetes.io/managed-by=Helm --overwrite
```

Then upgrade as usual. This is metadata-only: it does not touch the CRD schema and does not disturb existing PDBPolicy objects.

To skip adoption entirely, set `crds.install=false` and keep managing the CRD yourself.

#### Uninstall behaviour changed

With `crds.install=true`, `helm uninstall` now deletes the CRD, and deleting a CRD deletes every PDBPolicy in the cluster. Previously the CRD survived uninstall. Set `crds.install=false` if you want the old behaviour.

#### Flux users

`skipCRDs: true` is no longer needed in your `HelmRelease` (the chart has no `crds/` directory for Helm to auto-install). Leaving it set is harmless.

### NetworkPolicy now allows webhook and probe traffic

Only relevant if you set `networkPolicy.enabled=true`.

The generated policy previously allowed ingress on the metrics port only. Because it selects the operator pods and sets `policyTypes: [Ingress]`, everything else was denied, including the kube-apiserver reaching the admission webhook on `webhooks.targetPort` (9443). With the default `webhooks.failurePolicy: Fail`, every PDBPolicy admission request failed.

The policy now also admits the webhook port (when `webhooks.enabled=true`) and the health probe port. Both rules omit a `from` selector, because the apiserver and the kubelet are not pods and cannot be matched by a pod or namespace selector.
