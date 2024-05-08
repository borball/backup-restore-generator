#!/bin/bash


usage(){
  echo "Usage: $0 [resource.yaml]"
  echo "Example: $0 backup-resources.yaml"
}

if [ $# -lt 1 ]
then
  usage
  exit
fi

if [[ ( $@ == "--help") ||  $@ == "-h" ]]
then
  usage
  exit
fi

provided_resource=$1

generate(){
  rm -rf auto-generated
  mkdir -p auto-generated

  jinja2 templates/backup-cluster.yaml.j2 "$provided_resource" > auto-generated/backup-cluster.yaml
  jinja2 templates/backup-namespaced.yaml.j2 "$provided_resource" > auto-generated/backup-namespaced.yaml
  jinja2 templates/restore-cluster.yaml.j2 "$provided_resource" > auto-generated/restore-cluster.yaml
  jinja2 templates/restore-namespaced.yaml.j2 "$provided_resource" > auto-generated/restore-namespaced.yaml

  sed -i -E 's/[[:space:]]+$//g' auto-generated/backup-cluster.yaml
  sed -i -E 's/[[:space:]]+$//g' auto-generated/backup-namespaced.yaml
  sed -i -E 's/[[:space:]]+$//g' auto-generated/restore-cluster.yaml
  sed -i -E 's/[[:space:]]+$//g' auto-generated/restore-namespaced.yaml

  cp templates/acm-backup.yaml auto-generated/acm-backup.yaml
  cp templates/acm-restore.yaml auto-generated/acm-restore.yaml

  cp templates/kustomization.yaml auto-generated/kustomization.yaml

  kustomize build auto-generated/ -o auto-generated/oadp-backup-restore-cm.yaml

  echo "you can run oc apply -f auto-generated/oadp-backup-restore-cm.yaml on your target cluster, the name of the configmap will be oadp-backup-restore-cm."
}

if [[ -f ${provided_resource} ]]; then
  generate
else
  echo "File $provided_resource not exist, please check."
fi
