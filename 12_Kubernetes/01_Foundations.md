Resource:
https://medium.com/@h.stoychev87/kubernetes-the-basics-ccadefb48037

![[Pasted image 20260218154310.png]]


![[Pasted image 20260420141735.png]]

## Node 

A node may be a virtual or physical machine, depending on the cluster. Each node is managed by the [control plane](https://kubernetes.io/docs/reference/glossary/?all=true#term-control-plane) and contains the services necessary to run [Pods](https://kubernetes.io/docs/concepts/workloads/pods/).

The hosted application is in the worker node. 

## Master node/control plane & its components 
Control plane/master node is a virtual machine that hosts administrative components which help run the cluster(will see below) smoothly. 

In a high availability there is more than one nodes/virtual machine for the control plane. 

![[Pasted image 20260420195208.png]]

### Kube API Server:

API server is the **center of the control plane**. Any **incoming request from the client** will **first reach to the API server.** Then API server will interact with other components. 
Any request from outside will first go to the API server. It's a main entry point inside the kubernetes cluster. 

### Schedular 
Receive the request from the API server:
Eg. Request to schedule a pod. 
Request is received first by the API server, **API server forward that request to the scheduler to find a suitable node for that pod.** 
It catches newly created pods that are yet to be assigned to a node means writing nodes name in the pod metadata

### Controller manager 

Control manager is the combination of many different components. 
1. **Node Controller :** responsible for **managing the nodes.** 
2. **Namespace** 
3. **Deployment Controller** 
4. **Cloud controller**: communication between a **kubernetes cluster & a cloud provider.** 
**Monitor the workload, monitor the kubernetes object & make sure it is up & healthy.** 

### ETCD

Etcd is a **key value data store**
eg. name (key): Tanishka (value).  
**Etcd is a schema less database.** 
Etcd is a **NoSQL databases where you store your values as per documents. The document here is a JSON file**. 
Every s**ingle information about the cluster is stored here, whenever you make changes in the cluster that information is included.** 
**Only API server interacts** with the etcd database.
**Only API server has the authority** to apply changes to the etcd.
If we want to retrieve information from the etcd. Eg. we want to know how many pods are running in the cluster. So that information will also be retrieved by the API server from the etcd database.


## Worker node components

Every worker node will have **kubelet** and **kube-proxy** running. 
### Kubelet

![[Pasted image 20260420203914.png]]


API server will send instructions to the **kubelet to make some changes in the worker node.** 

Eg. if it receives instruction to delete a pod. 
![[Pasted image 20260420204702.png]]

API server will reflect the changes in etcd. 
It is a node based agent and receive the request from the API server and enables communication 
It nenables communication between **worker node & control plane node**. 

**Detail about Kubelet:** 
https://addozhang.medium.com/source-code-analysis-a-comprehensive-understanding-of-kubelet-7a9083514ff0

### Kube-proxy
![[Pasted image 20260427153254.png]]

**Kube-proxy** enables networking within the node. 
It creates **IP tables rule**s  & enables **pod-to-pod networking**.
**Pods and services can communicate with each other** with the help of kube-proxy.

receives instructions from the control plane node. 

## End-to-end flow nodes. 

![[Pasted image 20260427153840.png]]

E.g. A user(eg. administrator/devops team) 

### **Part 1:** 
That user uses a client utility called kubectl (helps you interact with the cluster)
Suppose the request was to create the pod. eg. kubetcl create pod. 

This  request goes to the api server when the api server receives the request.
Kube-api server will authenticate the request, whether it is a valid request, whether the user has permissions. 
![[Pasted image 20260427154333.png]]

### Part 2: 

**API Server** will send the request to **ETCD database**.
![[Pasted image 20260427154623.png]]

Since ETCD is a database it will not create the pod, but it will create an entry in the database. 
![[Pasted image 20260427154935.png]]

ETCD will send a response back to the API server that pod has been created. 

### Part 3: 

Scheduler runs all the time, is monitoring the control plane. 
Scheduler finds that **there is a pod that needs to be scheduled on a node.** 
Scheduler will **find a node available for the pod.** 
Scheduler sends instructions to the **apiserver.**

Note: Every component sends instructions/metadata to the api server 

![[Pasted image 20260427155317.png]]
![[Pasted image 20260427155542.png]]

### Part 4

API server interacts with the kubelet of the particular node that I have a job for schedule this pod on your node. 
Receiving that request kubelet will schedule the pod. It will send the details back to the api server that pod has been created. 

![[Pasted image 20260427160054.png]]

### Part 5

![[Pasted image 20260427160541.png]]

API server will add the entry to the ETCD database. That the pod has been created. 
Then the api server will send the details to the user that your request has been created. 

![[Pasted image 20260427160717.png]]

### # Pods:
![[Pasted image 20260420171937.png]]


- **Definition:** The **smallest deployable unit** in Kubernetes. **is a group of one or more [containers](https://kubernetes.io/docs/concepts/containers/)**, with shared storage and network resources, and a specification for how to run the containers. **Think of it as a wrapper around one or more containers that share the same network namespace and storage**. Pod helps you run the containers. 
- **Key Features:**
    - Each Pod gets its **own IP address**.
    - 


Containers inside a Pod can communicate over `localhost`.
    - Pods are **ephemeral**: they can die and be recreated, so you usually don’t interact with them directly in production.
        
- **Analogy:** A Pod is like a **single apartment** inside a building (the apartment can have multiple rooms → containers).

### # Deployment:

- **Definition:** A **higher-level abstraction** that manages Pods.
- **Purpose:** Ensures that a specified number of Pods are running at all times, handles **rolling updates**, and can **rollback** if something goes wrong.
- **Key Features:**
    - Declarative: You define **desired state**, and Kubernetes works to maintain it.
    - Handles **replicas**, **scaling**, and **upgrades** automatically.
- **Analogy:** Deployment is like a **property manager** who ensures the building always has the right number of apartments occupied.

### # Service:

- **Definition:** Provides a **stable network endpoint** to access a set of Pods.
- **Purpose:** Pods can come and go, but a Service gives you a **fixed IP and DNS name** to reach them.
- **Types of Services:**
    - **ClusterIP (default):** Internal access within the cluster.
    - **NodePort:** Exposes Service on a port on all nodes.
    - **LoadBalancer:** External access via cloud provider load balancer.
    - **Headless:** Direct Pod access without a stable IP.
- **Analogy:** A Service is like the **reception desk** of a building. Even if tenants (Pods) move in and out, the reception always knows where to direct visitors.

#### **# Replicaset**:
A **ReplicaSet** is like a **helper that makes sure your app is always running**.

- You tell it, “I want **3 copies** of this app running.”
- If one copy (pod) dies or is deleted, ReplicaSet **automatically creates a new one**.
- If you want more copies, it can **add them**. If you want fewer, it can **remove some**.

Think of it like **a babysitter for your pods**: it keeps the number of pods exactly how you want.
### **How They Work Together**

1. You create a **Deployment** → it creates and manages multiple **Pods**.
2. Pods are ephemeral → their IPs can change.
3. You create a **Service** → it provides a stable endpoint to reach those Pods.
4. The Service uses **selectors** to route traffic to the Pods created by the Deployment.

```
Deployment --> Pods --> Service routes traffic to Pods
```



