	# Kubernetes Basics

Kubernetes (K8s) is a system to manage **containers** at scale. Here are the basic terms and commands.

---

## 1. Cluster
A **cluster** is a group of machines (nodes) that run Kubernetes.  
- **Master Node**: Controls the cluster, schedules workloads.  
- **Worker Node**: Runs the applications (containers).

---

## 2. Node
A **node** is a machine in Kubernetes, either master or worker.

**Check nodes in cluster:**
```
kubectl get nodes
```

---

## 3. Pod
A **pod** is the smallest unit in Kubernetes.  
It can have one or more containers running together.

**Create a pod:**
```
kubectl run my-pod --image=nginx
```

**List pods:**
```
kubectl get pods
```

**Describe a pod (details):**
```
kubectl describe pod my-pod
```

---

## 4. Deployment
A **deployment** manages multiple replicas of a pod and updates them without downtime.

**Create a deployment:**
```
kubectl create deployment my-deploy --image=nginx
```

**Check deployments:**
```
kubectl get deployments
```

**Scale deployment:**
```
kubectl scale deployment my-deploy --replicas=3
```

**Update deployment image:**
```
kubectl set image deployment/my-deploy nginx=nginx:latest
```

---

## 5. Service
A **service** exposes pods to the network so other pods or users can access them.

**Create a service (ClusterIP by default):**
```
kubectl expose deployment my-deploy --port=80 --target-port=80
```

**List services:**
```
kubectl get services
```

---

## 6. Namespace
Namespaces divide cluster resources between multiple users or projects.

**List namespaces:**
```
kubectl get namespaces
```

**Create a namespace:**
```
kubectl create namespace my-namespace
```

---

## 7. ConfigMap
A **ConfigMap** stores configuration data (like environment variables) for pods.

**Create ConfigMap from file:**
```
kubectl create configmap my-config --from-file=config.txt
```

**Check ConfigMaps:**
```
kubectl get configmaps
```

---

## 8. Secret
A **Secret** stores sensitive data (passwords, keys) safely.

**Create a secret:**
```
kubectl create secret generic my-secret --from-literal=password=12345
```

**Check secrets:**
```
kubectl get secrets
```

---

## 9. Volume
A **volume** is storage attached to pods for persistent data.

**Example YAML for volume:**
```
apiVersion: v1
kind: Pod
metadata:
  name: pod-with-volume
spec:
  containers:
  - name: nginx
    image: nginx
    volumeMounts:
    - mountPath: "/data"
      name: my-storage
  volumes:
  - name: my-storage
    emptyDir: {}
```

---

## 10. Ingress
**Ingress** exposes HTTP and HTTPS routes to services from outside the cluster.

**Check ingress resources:**
```
kubectl get ingress
```

---

## 11. Label
**Labels** are key-value pairs to organize and select Kubernetes objects.

**Add a label to a pod:**
```
kubectl label pods my-pod app=web
```

**Select pods by label:**
```
kubectl get pods -l app=web
```

---

## 12. Annotation
**Annotations** store metadata about Kubernetes objects.  
They are not used for selection like labels.

**Add an annotation:**
```
kubectl annotate pod my-pod description="My first pod"
```

---

## 13. kubectl
`kubectl` is the command-line tool to interact with Kubernetes.

**Check cluster info:**
```
kubectl cluster-info
```

**Apply configuration from YAML file:**
```
kubectl apply -f myfile.yaml
```

**Delete resource:**
```
kubectl delete pod my-pod
```

---

## 14. YAML
Kubernetes uses **YAML files** to define objects like pods, deployments, services.

**Example YAML for a pod:**
```
apiVersion: v1
kind: Pod
metadata:
  name: my-pod
spec:
  containers:
  - name: nginx
    image: nginx
```

---

## 15. ReplicaSet
A **ReplicaSet** ensures a specified number of pod replicas are running at all times.  
Usually managed by Deployments.

**Check ReplicaSets:**
```
kubectl get replicasets
```

---

## 16. StatefulSet
**StatefulSet** is used for pods that need stable network IDs or storage, like databases.

---

## 17. DaemonSet
**DaemonSet** runs a copy of a pod on all nodes automatically. Useful for logging or monitoring.

---

## 18. Job
**Job** runs a pod to completion (batch tasks).

**Create a job:**
```
kubectl create job my-job --image=busybox -- echo "Hello Kubernetes"
```

---

## 19. CronJob
**CronJob** runs Jobs on a schedule, like cron in Linux.

**Create a cronjob:**
```
kubectl create cronjob my-cron --image=busybox --schedule="*/5 * * * *" -- echo "Hello"
```

---

## 20. Helm
**Helm** is a package manager for Kubernetes, used to install applications easily.

**Install Helm chart:**
```
helm install my-app bitnami/nginx
```

---


