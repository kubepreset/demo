#!/bin/bash

force_exit() {
  local status=$1
  if [ "$status" != 0 ]; then
    exit $status
  fi
}
sudo cp ./assert.sh /usr/local/bin
curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.9.0/kind-linux-amd64
chmod +x ./kind
sudo cp ./kind /usr/local/bin
curl -LO "https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x ./kubectl
sudo cp ./kubectl /usr/local/bin
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3
chmod +x get_helm.sh
./get_helm.sh
kind create cluster
helm repo add kubepreset https://kubepreset.github.io/helm-charts
helm repo list
helm repo update
helm search repo kubepreset
helm install my-kubepreset kubepreset/kubepreset --version 0.1.0
kubectl get deployment -w --request-timeout=10s
cat backing-service-crd.yaml
kubectl apply -f backing-service-crd.yaml
cat secret.yaml
kubectl apply -f secret.yaml
cat backing-service-cr.yaml
kubectl apply -f backing-service-cr.yaml
cat app-deployment.yaml
kubectl apply -f app-deployment.yaml
cat service-binding-cr.yaml
kubectl apply -f service-binding-cr.yaml
kubectl get pod --selector=environment=test --field-selector=status.phase=Running --request-timeout=30s -w
POD=`kubectl get pod --selector=environment=test -o jsonpath='{.items[*].metadata.name}'`
source /usr/local/bin/assert.sh
password=`kubectl exec ${POD}  -- cat /bindings/password`
assert_eq "passwd" "${password}" "not equivalent!"
force_exit $?
username=`kubectl exec ${POD}  -- cat /bindings/username`
assert_eq "guest" "${username}" "not equivalent!"
force_exit $?
typeofsecret=`kubectl exec ${POD}  -- cat /bindings/type`
assert_eq "custom" "${typeofsecret}" "not equivalent!"
force_exit $?
provider=`kubectl exec ${POD}  -- cat /bindings/provider`
assert_eq "backingservice" "${provider}" "not equivalent!"
force_exit $?
