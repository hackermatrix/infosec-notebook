


**Overall Architecture:**

![[Pasted image 20260313174343.png]]


![[Pasted image 20260313162403.png]]

## Core Components[](https://kubernetes.io/docs/concepts/overview/components/#core-components)

A Kubernetes cluster consists of a control plane and one or more worker nodes. Here's a brief overview of the main components:

### A. Control Plane Components[](https://kubernetes.io/docs/concepts/overview/components/#control-plane-components)

Manage the overall state of the cluster:

1. [kube-apiserver](https://kubernetes.io/docs/concepts/architecture/#kube-apiserver)
- The core component server that exposes the Kubernetes HTTP API.

2. [etcd](https://kubernetes.io/docs/concepts/architecture/#etcd)
- Consistent and highly-available key value store for all API server data.

3. [kube-scheduler](https://kubernetes.io/docs/concepts/architecture/#kube-scheduler)
- Looks for Pods not yet bound to a node, and assigns each Pod to a suitable node.

4. [kube-controller-manager](https://kubernetes.io/docs/concepts/architecture/#kube-controller-manager)
- Runs [controllers](https://kubernetes.io/docs/concepts/architecture/controller/) to implement Kubernetes API behavior.

5. [cloud-controller-manager](https://kubernetes.io/docs/concepts/architecture/#cloud-controller-manager) (optional)
- Integrates with underlying cloud provider(s).

### B. Node Components[](https://kubernetes.io/docs/concepts/overview/components/#node-components)

Run on every node, maintaining running pods and providing the Kubernetes runtime environment:

1. [kubelet](https://kubernetes.io/docs/concepts/architecture/#kubelet)
- Ensures that Pods are running, including their containers.

2. [kube-proxy](https://kubernetes.io/docs/concepts/architecture/#kube-proxy) (optional)
- Maintains network rules on nodes to implement [Services](https://kubernetes.io/docs/concepts/services-networking/service/).

3. [Container runtime](https://kubernetes.io/docs/concepts/architecture/#container-runtime)
- Software responsible for running containers. Read [Container Runtimes](https://kubernetes.io/docs/setup/production-environment/container-runtimes/) to learn more.