-  In Kubernetes, a Service is a method for exposing a network application that is running as one or more [Pods](https://kubernetes.io/docs/concepts/workloads/pods/) in your cluster.


## Types of Service

1. **ClusterIP**:
- Think of it as an **internal phone line** inside your office. Only people inside the building (cluster) can call it.

```yaml
spec:
  type: ClusterIP
  selector:
    app: my-app
  ports:
  - port: 80
    targetPort: 80
```

- **When to use:** When one service inside your cluster needs to talk to another, like your backend talking to a database. No one outside the cluster needs access.