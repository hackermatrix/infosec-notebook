Resources : https://medium.com/@prasad.midde3/understanding-node-affinity-pod-affinity-node-selector-and-pod-anti-affinity-in-kubernetes-7899e218ac6d


## Key Differences Between Kubernetes Scheduling Mechanisms

![[Pasted image 20260505190457.png]]


### Types of Node Affinity

1. **RequiredDuringSchedulingIgnoredDuringExecution**:
    - Ensures pods are only scheduled on nodes that satisfy the specified rules.
    - If no nodes meet the criteria, the pods remain unscheduled.
    - **More Strict.**
2. **PreferredDuringSchedulingIgnoredDuringExecution**:
    - Specifies preferences that the scheduler attempts to fulfill but doesn’t enforce strictly.
    - **Less Strict.**