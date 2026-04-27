
https://kind.sigs.k8s.io/

kind create cluster 
kind create cluster --name 
kubectl cluster-info --context kind-kind
kubectl get nodes 

Kind creates a **single-node cluster** where that one node acts as the **control plane** (the brain of the cluster). That's why you see it named `kind-control-plane` with the role `control-plane`

How to create **multi-node cluster** 
https://kind.sigs.k8s.io/docs/user/quick-start#creating-a-cluster

```
kind create cluster --config kind-example-config.yaml
```
