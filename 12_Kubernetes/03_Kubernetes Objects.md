
## 1. What Are Kubernetes Objects?

- Kubernetes objects are persistent entities that represent the state of your cluster. [kubernetes](https://kubernetes.io/docs/concepts/overview/working-with-objects/) -
- Think of them as the building blocks you use to tell Kubernetes what your applications look like and how they should behave. 
	- Specifically, they describe three things: what containerized apps are running and where, what resources are available to them, and the policies governing their behavior (like restart rules and fault tolerance).

A key concept here is **"record of intent."** When you create an object, you're declaring a desired state. Kubernetes then continuously works to make **reality match that desire.** If something goes wrong (say a container crashes), Kubernetes notices the mismatch between your desired state and the actual state, and fixes it automatically.

---
## 2. Spec vs. Status

Every Kubernetes object has two important fields:

- **`spec`** — This is what _you_ set. It describes what you _want_ the object to look like (the desired state). For example, "I want 3 replicas of my app running."
- **`status`** — This is what _Kubernetes_ sets. It describes what's _actually_ happening right now (the current state). Kubernetes constantly updates this.

The control plane's job is to reconcile these two — making `status` match `spec` at all times. If a replica dies, the system detects the difference and spins up a replacement.

---
## 3. How You Describe Objects (Manifests)

- You define Kubernetes objects using **manifest files**, typically written in YAML. 
- A simple Deployment manifest might look like this: you specify the API version, the kind of object (e.g., `Deployment`), metadata like a name, and a `spec` section describing what you want (like 2 replicas of an nginx container).

- You then apply it with a command like `kubectl apply -f deployment.yaml`, and Kubernetes takes it from there.

## 4. Required Fields in Every Manifest

Every manifest needs four things:

- **`apiVersion`** — which API version you're targeting (e.g., `apps/v1`)
- **`kind`** — the type of object (e.g., `Deployment`, `Pod`, `Service`)
- **`metadata`** — identifying info like the object's name, UID, and optionally a namespace
- **`spec`** — the desired state, which varies depending on the object type