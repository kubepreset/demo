# Demo


```
kind delete cluster;kind create cluster
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
kubectl get pod -w --request-timeout=20s
export POD=`kubectl get pod --selector=environment=test -o jsonpath='{.items[*].metadata.name}'`
kubectl exec -it ${POD}  -- cat /bindings/sb/password
kubectl exec -it ${POD}  -- cat /bindings/sb/username
kubectl exec -it ${POD}  -- cat /bindings/sb/type
kubectl exec -it ${POD}  -- cat /bindings/sb/provider
```
