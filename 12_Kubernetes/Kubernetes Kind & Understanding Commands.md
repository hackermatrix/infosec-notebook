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
## How to switch contexts

When you run kubectl get nodes it will give information about the recent cluster what about the previous cluster i.e, when you will use kubectl get context

kubectl config get-contexts

![[Pasted image 20260427223820.png]]

the * in the column CURRENT shows that any command you will run will give information on the cluster marked with star 

Eg. when I do kubectl get-nodes 
![[Pasted image 20260427224233.png]]
 
kubectl config use-context my-cluster-name

Kubectl run pod-name --image image-name. 

When you do kubectl get-pods and see 1/1 that means it has one container & one is already running

Eg. if there are two containers running it would be 2/2 or something 

![[Pasted image 20260427232236.png]]  

## Explain command 
kubectl explain pod 

It's a **documentation tool**. It shows you the structure/schema of a Kubernetes resource type.
Note: it is not the pod name jus the pod

At the top you can see the kind and version these versions are the one that are supported. 

![[Pasted image 20260428105450.png]]
![[Pasted image 20260428105505.png]]

It can be further delved into this 
![[Pasted image 20260428105903.png]]

rc is replicationccontroller when you are making a yaml file for replicationcontroller 

![[Pasted image 20260428154010.png]]

## Editing a pod 

### Method 1 

One method is through your yaml file other method is through. 

kubectl edit pod pod-name

Remeber the changes are to the running pod 

![[Pasted image 20260428111523.png]]


Edits the **live object** in the Kubernetes cluster directly. When you save and quit, Kubernetes immediately tries to apply those changes to the running pod. However, pods are very limited in what you can edit live, basically only the image, some tolerations, and a few other fields. Most changes will be rejected. Also, this doesn't update your original YAML file on disk, so your `practise.yaml` and the live pod can drift apart.

![[Pasted image 20260428112242.png]]

When you run `kubectl edit pod nginx-pod`, here's what actually happens behind the scenes:

1. kubectl fetches the full live YAML from the Kubernetes API server
2. Dumps it into a **temporary file** in `/tmp`
3. Opens that temp file in your default editor (vi/vim/nano)
4. You make your edits and save/quit
5. kubectl reads the modified temp file and sends the changes back to the API server
6. The temp file gets deleted

So you're never editing the actual cluster state directly — you're editing a throwaway copy. kubectl uses it as a middleman to figure out what you changed, then applies the diff to the cluster.

That's also why `kubectl edit` doesn't touch your original `practise.yaml` — it has no idea that file exists. It's working entirely through the API server and temp files.
### Method 2 

nano filename.yaml 
kubectl apply -f filename.yaml

This edits your **source file** on disk, then you manually re-apply it. This keeps your file as the single source of truth. But here's the catch for pods specifically, most changes require you to delete and recreate the pod.


## How to get inside the pod 

kubectl exec -it podname -- sh
![[Pasted image 20260428113050.png]]


## How to dry run pods without actual running it 

![[Pasted image 20260428114846.png]]

kubectl run pod-name --image=image-name> --dry-run=client -o yaml
- `kubectl run pod-name` — create a pod with this name
- `--image=image-name` — using this container image
- `--dry-run=client` — don't actually create anything, just simulate it
- `-o yaml` — output the generated YAML>



![[Pasted image 20260428121600.png]]

So instead of creating a manual yaml file it creates one and then you can make changes to the yaml file accordingly. 

You can also redirect it to a new yaml file 

kubectl run pod-name --image=image-name> --dry-run=client -o yaml > newfilename.yaml 
![[Pasted image 20260428121905.png]]
![[Pasted image 20260428121936.png]]

Similarly you can do a .json file 
![[Pasted image 20260428122220.png]]


## How to get information about a particular pod 

kubectl describe pod pod-name 

![[Pasted image 20260428122628.png]]
![[Pasted image 20260428122644.png]]

## How to get information about labels 

kubectl get pods pod-name --show-labels

![[Pasted image 20260428123103.png]]

-o wide will show that all the information like extended information about the get pods command 

kubectl get pods -o wide 

![[Pasted image 20260428123303.png]]

**Readiness Gates**
These are custom conditions that must be true before Kubernetes considers the pod "Ready." By default, Kubernetes marks a pod ready when its containers are running and passing health checks. But sometimes external systems (like a load balancer or service mesh) need to confirm the pod is actually ready to receive traffic. Readiness gates let you add those extra checks. `<none>` means no custom readiness conditions are configured — Kubernetes is using its default readiness logic.


![[Pasted image 20260428123623.png]]

## How to get information about individual pods 

kubectl get po 

kubectl describe po 
![[Pasted image 20260429150603.png]]

![[Pasted image 20260429150944.png]]


## How to check the rollout history 

kubectl rollout history deploy/nginx-deploy
![[Pasted image 20260429170214.png]]


## How to dry run deploy 
