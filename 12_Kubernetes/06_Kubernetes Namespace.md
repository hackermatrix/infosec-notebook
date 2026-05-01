
![[Pasted image 20260313174621.png]]

![[Pasted image 20260313174856.png]]


### Understanding the Relationship Between Namespaces and Clusters

- In Kubernetes, a cluster is the complete set of resources and components that are necessary to run your applications. Within this cluster, namespaces come into play as a way to divide or segment these resources.


### Applications of Kubernetes Namespaces

1. **Resource Segregation:** 
	- Kubernetes namespaces play a pivotal role in resource management by providing a mechanism for resource categorization. 
	- For example, you can allocate varying amounts of CPU and memory resources to different namespaces, tailoring resource allocation to the specific needs of the applications within them. This granular control over resource distribution allows for efficient utilization of cluster resources, ensuring that each application has access to the resources it needs to perform optimally.

2. **Access Management:** 
	- Namespaces also serve as a powerful tool for access management within a Kubernetes cluster. 
	- They enable fine-grained access control by allowing specific users or groups access to particular namespaces. 
	- This capability is especially beneficial in multi-tenant environments where multiple teams or projects share the same Kubernetes cluster. 
	- By assigning each team to a specific namespace, you can ensure that team members have access to the resources they need while preventing unauthorized access to other teams’ resources.

3. **Isolation:** 
	- Namespaces offer a degree of isolation. If a process in one namespace fails, it doesn’t impact processes in other namespaces, thereby enhancing the system’s overall stability and reliability.



![[Pasted image 20260430190331.png]]


Nginx and redis hostname in namespace prod if want to interact to with namespace test. 

![[Pasted image 20260430153207.png]]

They have to use something called as an fully qualified doman name, 

- **FQDN** : Fully Qualified Domain Name (example : www.google.com.)
	- This is an FQDN because it includes:
		- **Host** → `www`
		- **Domain** → `google`
		- **Top-Level Domain (TLD)** → `com`
		- **Root (optional dot)** → `.` (often omitted in practice)
		
- **default** and **demo** are the two namespaces.
-  **svc-test** and **svc-demo** are the services that are deployed.

#### Types of communication:
1. **pod to pod** : pod can communicate using IP addresses **"Across namespaces"** . 
2. **pod and service ( different namespace )** : If a pod in a different namespace wants to communicate with a service in a different namespace, they need to use a FQDN.
3. **pod and service ( same namespace )** : If a pod in a same namespace wants to communicate with a service in a same namespace, they can use the service name (eg. **svc-test or svc-demo**).

### Default Namespace 

![[Pasted image 20260430190912.png]]

When you dont specify the namespace name it goes in the default namespace. 


### kube-system 

All the control plane components are included in the kube-system. 

```
kubectl get all --namespace=kube-system
```
![[Pasted image 20260430192004.png]]

```
kubectl get all --n=namespace-name
```
![[Pasted image 20260430192440.png]]


## How to deploy namespace 

### Declarative way 
https://kubernetes.io/docs/tasks/administer-cluster/namespaces/#creating-a-new-namespace

![[Pasted image 20260430194044.png]]
![[Pasted image 20260430194103.png]]


### Deploy namespace with deployment


kubectl create deployment cattle --image=registry.k8s.io/serve_hostname -n=production

### Communication between two pods in different namespace. 

#### 1st Namespace 

![[Pasted image 20260430195323.png]]
`nginx-demo` is the **deployment name**

```
 kubectl get pods -n namespace name

```

![[Pasted image 20260430200724.png]]
![[Pasted image 20260430202536.png]]

Will try to curl IP 10.244.2.2

![[Pasted image 20260430202859.png]]

![[Pasted image 20260430203840.png]]

Now since we are creating  we will expose the replicaset

https://kubernetes.io/docs/tutorials/kubernetes-basics/expose/expose-intro/


#### 2nd Namespace 

![[Pasted image 20260430201825.png]]

![[Pasted image 20260430201916.png]]
![[Pasted image 20260430202253.png]]The vice versa the curl works 

![[Pasted image 20260430203044.png]]

Now we will scale 
![[Pasted image 20260430203824.png]]
