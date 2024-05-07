# Backup/Restore CR generator

A script to generate velero Backup and Restore CRs based on a provided resource list. 

- CRs Template: backup-restore-templates.yaml.j2
- Provided resources list in the backup: backup-resources-example.yaml

A example file: backup-restore-crs-example.yaml 

Run it:

```shell
# ./generator.sh
---
apiVersion: velero.io/v1
kind: Backup
metadata:
  annotations:
    lca.openshift.io/apply-label: "apiextensions.k8s.io/v1/customresourcedefinition/crd1,apiextensions.k8s.io/v1/customresourcedefinition/crd2,apiextensions.k8s.io/v1/customresourcedefinition/crd3,security.openshift.io/v1/securitycontextconstraints/vdu,rbac.authorization.k8s.io/v1/clusterroles/clusterrole1,rbac.authorization.k8s.io/v1/clusterroles/clusterrole2,rbac.authorization.k8s.io/v1/clusterrolebindings/clusterrolebinding1,rbac.authorization.k8s.io/v1/clusterrolebindings/clusterrolebinding2"
  name: backup-vdu-cluster-resources
  labels:
    velero.io/storage-location: default
  namespace: openshift-adp
spec:
  includedClusterScopedResources:
  - customresourcedefinitions
  - securitycontextconstraints
  - clusterrolebindings
  - clusterroles
  


---
apiVersion: velero.io/v1
kind: Backup
metadata:
  labels:
    velero.io/storage-location: default
  name: backup-vdu-namespaced-resources
  namespace: openshift-adp
spec:
  includedNamespaces:
  - vdu
  includedNamespaceScopedResources:
  - secrets
  - persistentvolumeclaims
  - deployments
  - statefulsets
  - configmaps
  - cronjobs
  - services
  - job
  - poddisruptionbudgets
  - roles
  - rolebindings
  excludedClusterScopedResources:
  - persistentVolumes
  


---
apiVersion: velero.io/v1
kind: Restore
metadata:
  name: restore-vdu-cluster-resources
  namespace: openshift-adp
  labels:
    velero.io/storage-location: default
  annotations:
    lca.openshift.io/apply-wave: "2"
spec:
  backupName:
    backup-vdu-cluster-resources


---
apiVersion: velero.io/v1
kind: Restore
metadata:
  name: restore-vdu-namespaced-resources
  namespace: openshift-adp
  labels:
    velero.io/storage-location: default
  annotations:
    lca.openshift.io/apply-wave: "3"
spec:
  backupName:
    backup-vdu-namespaced-resources

```