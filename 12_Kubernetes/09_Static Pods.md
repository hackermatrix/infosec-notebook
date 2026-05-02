
> [! note]
> - The **Control Plane** also runs on a node which implies that even the control plan has a **kublet** instance running on it.
> - The "etcd", "api-server", "schedular" all of these also are present 

![[Pasted image 20260501161735.png]]
## What is Static pods

 - Schedular is also running on a pod. This creates a chicken and an egg problem (as schedular, apiserver, etcd, controller manager) should be managing the pod but they are hosted a pod. Even though control plane components are running in a pod they are called static pods. 
 - Static pods are in one single directory 


Kubelet is responsible for scheduling static pods. Kubelet is running on the master node. 
Kubelet is responsble for checking the manifest of the static pods. 

![[Pasted image 20260501153205.png]]

If we were using a kubernetes cluster on any cloud or VMware or bare metal. Then this particular node would be a virtual machine. 

As Kind creates multiple containers. Treats those nodes as containers we will execute inside these containers. 
![[Pasted image 20260501155622.png]]

![[Pasted image 20260501155951.png]]


### Why are we checking the namespace kube-system 

Because `kube-system` is the dedicated namespace for Kubernetes' own internal components. The scheduler, API server, controller-manager, etcd, CoreDNS, they all live there.

### manifests

Manifests is where all the yaml files are stored. 

cd /etc/kubernetes/manifests/

![[Pasted image 20260501160613.png]]

If any of the yaml files are moved from here it affects the normal functioning of the kubernetes. 
