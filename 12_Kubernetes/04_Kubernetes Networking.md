**Resources** :
- https://aleqxan.medium.com/overview-of-kubernetes-networking-and-service-mesh-eb7d3cb0a14b
- https://medium.com/@h.stoychev87/kubernetes-networking-a-deep-dive-6081d794e97c

### # Types of Networking 
- Pod Networking
- Service Networking
- Network Policies
- Ingress and Ingress Controllers
- Service Mesh


### **Pod networking**
- Kubernetes works by using a Container Network Interface (CNI) plugin to configure the network interfaces of containers in a pod. When a pod is created, the CNI plugin creates a network namespace for the pod, along with a virtual Ethernet interface and an IP address for the container.
- ![[Pasted image 20260313181058.png]]



### Service Networking 
- In Kubernetes, a service is an abstraction layer that provides a stable IP address and DNS name for a set of pods.

- Services enable communication between pods, both within the **same cluster and across different clusters.** Services in Kubernetes work by creating a virtual IP address and DNS name that load-balances traffic between a set of pods.

- When a service is created, Kubernetes assigns it a unique IP address from the cluster’s Service IP address range. The service’s IP address is virtual and does not correspond to a physical network interface on any node in the cluster. Instead, the IP address is managed by the kube-proxy component, which runs on each node in the cluster and routes traffic to the appropriate pod.
	
#### It provides the following benefits;

- **Load balancing**: Services can distribute traffic across multiple pods, providing high availability and scalability.
- **Service discovery**: Services provide a stable IP address and DNS name, making it easy for other services to discover and communicate with them.
- **Cross-cluster communication**: Services can be exposed to the internet or other Kubernetes clusters, making it easy to communicate between services in different environments.


### **Network Policies**
- **NetworkPolicy** controls **Pod-to-Pod traffic**.
- A Network Policy is a specification that **defines rules for traffic ingress and egress** for a set of pods.
- **Network Policy** acts as an internal firewall regulating traffic _between_ pods (security).
#### **A Network Policy specifies the following:**
	- The namespaces to which it applies.
	- The pods to which it applies.
	- The traffic flow that it allows or blocks

- Network Policies **are enforced by the kube-proxy** component running on each node in the cluster.


### **Ingress and Ingress controller**
![ingress-diagram](https://kubernetes.io/docs/images/ingress.svg)

1. **Ingress :**
	- This sits above Services.
	- Works on Layer 7
	- It is a **set of rules** for routing traffic from the internet to your Services.
	- It is like writing reverse proxy rules.
	- An Ingress does not expose arbitrary ports or protocols. Exposing services other than HTTP and HTTPS to the internet typically uses a service of type [Service.Type=NodePort](https://kubernetes.io/docs/concepts/services-networking/service/#type-nodeport) or [Service.Type=LoadBalancer](https://kubernetes.io/docs/concepts/services-networking/service/#loadbalancer). **( From Kubernetes Docs )**.
	
2. **Ingress Controller :**
	- You need something that **reads those rules and actually handles traffic** 
	-                             **That is Ingress Controller**.
	- example : Nginx, etc



### **Service Mesh**
- A Service Mesh is a dedicated infrastructure layer for managing service-to-service communication within a microservices architecture.
- 