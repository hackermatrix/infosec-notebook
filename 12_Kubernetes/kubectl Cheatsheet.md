# 1. kubectl Imperative Commands

---

## 🔍 CLUSTER INFO

```bash
kubectl cluster-info                  # Show cluster endpoint details
kubectl get nodes                     # List all nodes
kubectl get all                       # List all objects in current namespace
kubectl get all -A                    # List all objects in ALL namespaces
kubectl version                       # Show kubectl and server versions
```

---

## 🟢 CREATE

```bash
# --- Pods ---
kubectl run <name> --image=<image>                    # Create a Pod
kubectl run my-pod --image=nginx                      # Example

# --- Deployments ---
kubectl create deployment <name> --image=<image>                  # Basic
kubectl create deployment my-app --image=nginx --replicas=3       # With replicas

# --- Services ---
kubectl expose deployment/<name> --port=<port>                    # ClusterIP (default)
kubectl expose deployment/<name> --port=80 --type=NodePort        # NodePort
kubectl expose deployment/<name> --port=80 --type=LoadBalancer    # LoadBalancer
kubectl create service clusterip <name> --tcp=80:80               # Alternate syntax
kubectl create service nodeport <name> --tcp=80:80                # NodePort alternate

# --- Other Objects ---
kubectl create namespace <name>                       # Namespace
kubectl create configmap <name> --from-literal=key=val            # ConfigMap
kubectl create secret generic <name> --from-literal=key=val       # Secret
kubectl create job <name> --image=<image>             # Job
kubectl create cronjob <name> --image=<image> --schedule="*/5 * * * *"  # CronJob
kubectl create serviceaccount <name>                  # ServiceAccount

# --- Autoscaler ---
kubectl autoscale deployment/<name> --min=2 --max=10 --cpu-percent=80
```

---

## 🏷️ LABELS & SELECTORS

```bash
# --- Add / Update / Remove Labels ---
kubectl label <type> <name> key=value                 # Add or update a label
kubectl label pod my-pod env=prod                     # Example: label a pod
kubectl label pod my-pod env=staging --overwrite       # Overwrite existing label
kubectl label <type> <name> key-                      # Remove a label (note the "-")
kubectl label pod my-pod env-                         # Example: remove "env" label
kubectl label pods --all tier=backend                 # Label all pods in namespace

# --- View Labels ---
kubectl get pods --show-labels                        # Show all labels on pods
kubectl get pods -L env,tier                          # Show specific label columns

# --- Equality-Based Selectors ---
kubectl get pods -l env=prod                          # Label equals value
kubectl get pods -l env!=staging                      # Label does NOT equal value
kubectl get pods -l env=prod,tier=frontend            # Multiple selectors (AND logic)

# --- Set-Based Selectors ---
kubectl get pods -l 'env in (prod,staging)'           # Value in set
kubectl get pods -l 'env notin (dev,test)'            # Value NOT in set
kubectl get pods -l 'tier'                            # Label key exists
kubectl get pods -l '!tier'                           # Label key does NOT exist

# --- Selectors with Other Commands ---
kubectl delete pods -l env=test                       # Delete by label
kubectl logs -l app=my-app                            # Logs from all matching pods
kubectl exec -l app=my-app -- env                     # Exec across matching pods
kubectl scale deployment -l tier=backend --replicas=3 # Scale by label

# --- Node Selectors (schedule pods on specific nodes) ---
kubectl label node <node-name> disktype=ssd           # Label a node
kubectl label node <node-name> disktype-              # Remove node label
kubectl get nodes --show-labels                       # View node labels
kubectl get nodes -l disktype=ssd                     # Filter nodes by label
```

---

## ✏️ UPDATE

```bash
# --- Scale ---
kubectl scale deployment/<name> --replicas=<n>        # Change replica count

# --- Annotations ---
kubectl annotate <type> <name> key=value              # Add an annotation
kubectl annotate <type> <name> key-                   # Remove an annotation

# --- Set Image ---
kubectl set image deployment/<name> <container>=<image>:<tag>
kubectl set image deployment/my-app nginx=nginx:1.25  # Example

# --- Set Resources ---
kubectl set resources deployment/<name> --limits=cpu=200m,memory=256Mi
kubectl set resources deployment/<name> --requests=cpu=100m,memory=128Mi

# --- Set Service Account ---
kubectl set serviceaccount deployment/<name> <sa-name>

# --- Edit Live Object ---
kubectl edit <type> <name>                            # Opens in your editor
kubectl edit deployment my-app                        # Example

# --- Patch ---
kubectl patch <type> <name> -p '{"spec":{"replicas":5}}'
```

---

## 🗑️ DELETE

```bash
kubectl delete <type> <name>                          # Delete by name
kubectl delete <type>/<name>                          # Alternate syntax
kubectl delete pod my-pod                             # Example
kubectl delete deployment my-app                      # Deletes deployment + its pods
kubectl delete service my-svc                         # Delete a service

# --- Bulk Delete ---
kubectl delete pods --all                             # All pods in namespace
kubectl delete all --all                              # All objects in namespace
kubectl delete pods -l app=test                       # By label selector
```

---

## 👀 VIEW / INSPECT

```bash
# --- List Objects ---
kubectl get pods                                      # All pods
kubectl get pods -o wide                              # With extra info (IP, node)
kubectl get pods -o yaml                              # Full YAML output
kubectl get pods -o json                              # Full JSON output
kubectl get pods -w                                   # Watch (live updates)
kubectl get pods --show-labels                        # Show all labels
kubectl get pods -l key=value                         # Filter by label
kubectl get pods --sort-by=.metadata.creationTimestamp # Sort by creation time

# --- Details ---
kubectl describe <type> <name>                        # Full details + events

# --- Logs ---
kubectl logs <pod-name>                               # Container stdout/stderr
kubectl logs <pod-name> -f                            # Follow (stream live)
kubectl logs <pod-name> --tail=50                     # Last 50 lines
kubectl logs <pod-name> -c <container>                # Specific container in pod
kubectl logs <pod-name> --previous                    # Logs from crashed container
```

---

## 🔧 ROLLOUTS (Deployment Updates)

```bash
kubectl rollout status deployment/<name>              # Watch rollout progress
kubectl rollout history deployment/<name>             # View rollout history
kubectl rollout undo deployment/<name>                # Rollback to previous version
kubectl rollout undo deployment/<name> --to-revision=2  # Rollback to specific version
kubectl rollout restart deployment/<name>             # Restart all pods
kubectl rollout pause deployment/<name>               # Pause a rollout
kubectl rollout resume deployment/<name>              # Resume a paused rollout
```

---

## 🧪 DRY RUN & YAML GENERATION

```bash
# Generate YAML without creating anything (great for templates)
kubectl run my-pod --image=nginx --dry-run=client -o yaml
kubectl create deployment my-app --image=nginx --dry-run=client -o yaml

# Save generated YAML to a file
kubectl run my-pod --image=nginx --dry-run=client -o yaml > pod.yaml

# Pipeline: generate → modify → create
kubectl create service clusterip my-svc --tcp=80:80 \
  -o yaml --dry-run=client \
  | kubectl set selector --local -f - 'app=my-app' -o yaml \
  | kubectl create -f -

# Edit before creating
kubectl create deployment my-app --image=nginx \
  --dry-run=client -o yaml > /tmp/deploy.yaml
kubectl create --edit -f /tmp/deploy.yaml
```

---

## 🐛 DEBUGGING

```bash
kubectl exec -it <pod-name> -- /bin/sh               # Shell into a container
kubectl exec <pod-name> -- <command>                  # Run a command in a pod
kubectl exec my-pod -- env                            # Example: list env vars
kubectl port-forward <pod-name> <local>:<pod-port>    # Forward port to localhost
kubectl port-forward my-pod 8080:80                   # Example: localhost:8080 → pod:80
kubectl top pods                                      # CPU/memory usage (needs metrics-server)
kubectl top nodes                                     # Node resource usage
kubectl get events --sort-by=.lastTimestamp            # Recent cluster events
```

---

## 📌 USEFUL FLAGS (Work with most commands)

```bash
-n <namespace>          # Target a specific namespace
-A / --all-namespaces   # All namespaces
-o wide                 # Extra columns
-o yaml                 # Full YAML output
-o json                 # Full JSON output
-o name                 # Just resource names
-l key=value            # Filter by label
--dry-run=client        # Simulate — don't actually do it
-w / --watch            # Live updates
-h / --help             # Help for any command
--v=6                   # Verbose output (debug API calls)
```

---

## 🧠 QUICK REFERENCE PATTERNS

```text
Create a pod:       kubectl run <name> --image=<img>
Create a deploy:    kubectl create deployment <name> --image=<img>
Expose it:          kubectl expose deployment/<name> --port=<port>
Scale it:           kubectl scale deployment/<name> --replicas=<n>
Update image:       kubectl set image deployment/<name> <ctr>=<img>:<tag>
Check status:       kubectl get pods / deployments / services
Details:            kubectl describe <type> <name>
Logs:               kubectl logs <pod>
Delete:             kubectl delete <type> <name>
Generate YAML:      kubectl ... --dry-run=client -o yaml
Label it:           kubectl label <type> <name> key=value
Filter by label:    kubectl get <type> -l key=value
```

## Logs

```
kubectl logs nginx --all-containers=true
```
https://kubernetes.io/docs/reference/kubectl/generated/kubectl_logs/
