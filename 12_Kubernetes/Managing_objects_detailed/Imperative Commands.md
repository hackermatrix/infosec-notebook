
> **Source:** https://kubernetes.io/docs/tasks/manage-kubernetes-objects/imperative-command/
> 
> **What it is:** The quickest way to manage Kubernetes objects — you type a single command, and Kubernetes does it immediately. No YAML files needed.

---

## 1. Creating Objects

**Verb-driven commands** (beginner-friendly, you don't need to know object types):

| Command     | What it does                                          | Example                                              |
| ----------- | ----------------------------------------------------- | ---------------------------------------------------- |
| `run`       | Creates a Pod to run a container                      | `kubectl run my-nginx --image=nginx`                 |
| `expose`    | Creates a Service to load-balance traffic across Pods | `kubectl expose deployment/nginx --port=80`          |
| `autoscale` | Creates an Autoscaler to auto-scale a controller      | `kubectl autoscale deployment/nginx --min=2 --max=5` |

**Type-driven commands** (more explicit, supports more object types):

```
kubectl create <objecttype> [<subtype>] <instancename>
```

Example — create a NodePort Service:

```
kubectl create service nodeport my-svc
```

> **Tip:** Use `-h` to see available flags: `kubectl create service nodeport -h`

---

## 2. Updating Objects

**Verb-driven updates** (simple, no need to know field names):

|Command|What it does|Example|
|---|---|---|
|`scale`|Change replica count (horizontal scaling)|`kubectl scale deployment/nginx --replicas=5`|
|`annotate`|Add/remove annotations|`kubectl annotate pods my-pod description="my pod"`|
|`label`|Add/remove labels|`kubectl label pods my-pod env=prod`|

**Aspect-driven updates:**

|Command|What it does|Example|
|---|---|---|
|`set`|Set a specific aspect of an object|`kubectl set image deployment/nginx nginx=nginx:1.25`|

**Advanced updates** (need to understand object schema):

|Command|What it does|
|---|---|
|`edit`|Opens the live object config in your text editor to modify|
|`patch`|Modify specific fields using a JSON/YAML patch string|

---

## 3. Deleting Objects

```
kubectl delete <type>/<name>
```

Example:

```
kubectl delete deployment/nginx
```

---

## 4. Viewing Objects

|Command|What it shows|Example|
|---|---|---|
|`get`|Basic info (name, status, age, etc.)|`kubectl get pods`|
|`describe`|Detailed aggregated info (events, conditions)|`kubectl describe pod my-pod`|
|`logs`|stdout/stderr output from a container in a Pod|`kubectl logs my-pod`|

---

## 5. Advanced Tricks

### Pipe `create` + `set` to customize before creating

You can generate YAML without actually creating the object (dry run), modify it with `set`, then create it:

```bash
kubectl create service clusterip my-svc --clusterip="None" \
  -o yaml --dry-run=client \
  | kubectl set selector --local -f - 'environment=qa' -o yaml \
  | kubectl create -f -
```

**What's happening step by step:**

1. `create ... --dry-run=client` → generates YAML config (doesn't send to cluster)
2. `set selector` → modifies the selector field in that YAML
3. `create -f -` → actually creates the object from the modified YAML

### Use `--edit` to hand-edit before creating

```bash
kubectl create service clusterip my-svc --clusterip="None" \
  -o yaml --dry-run=client > /tmp/srv.yaml
kubectl create --edit -f /tmp/srv.yaml
```

This opens the file in your editor so you can tweak anything before it's created.

---

## 6. Trade-offs Summary

|✅ Pros|❌ Cons|
|---|---|
|Simple — one command, one action|No history / audit trail|
|Fastest way to get something running|Can't store in Git for version control|
|Great for learning and experimenting|No template to reuse for new objects|
|Single step to change the cluster|Doesn't integrate with review processes|

**Best for:** Development, learning, quick one-off tasks. **Not ideal for:** Production workflows where you need tracking and repeatability.