https://kubernetes.io/vi/docs/reference/kubectl/cheatsheet/
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
When you run kubectl get nodes it will give information about the recent cluster what about the previous cluster i.e, when you will use kubectl get context

kubectl config get-contexts

![[Pasted image 20260427223820.png]]

the * in the column CURRENT shows that any command you will run will give information on the cluster marked with star 

Eg. when I do kubectl get-nodes 
![[Pasted image 20260427224233.png]]

How to switch contexts 
kubectl config use-context my-cluster-name

Kubectl run pod-name --image image-name. 

When you do kubectl get-pods and see 1/1 that means it has one container & one is already running

Eg. if there are two containers running it would be 2/2 or something 

![[Pasted image 20260427232236.png]]  
