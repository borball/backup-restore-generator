# Backup/Restore CR/ConfigMap generator

A script to generate OADP Backup and Restore ConfigMap based on a provided resource list. 

Prepare a file by following backup-resources.yaml, then run the script with command below:

```shell
./generator.sh backup-resources.yaml
```

An example:

```shell
./generator.sh backup-resources.yaml 
you can run oc apply -f auto-generated/oadp-backup-restore-cm.yaml on your target cluster, the name of the configmap will be oadp-backup-restore-cm.

```