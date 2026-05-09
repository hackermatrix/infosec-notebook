Resources : https://medium.com/@prasad.midde3/understanding-node-affinity-pod-affinity-node-selector-and-pod-anti-affinity-in-kubernetes-7899e218ac6d


## Key Differences Between Kubernetes Scheduling Mechanisms

![[Pasted image 20260505190457.png]]


### Types of Node Affinity/Properties

1. **RequiredDuringSchedulingIgnoredDuringExecution**:
    - Ensures pods are only scheduled on nodes that satisfy the specified rules.
    - If no nodes meet the criteria, the pods remain unscheduled.
    - **More Strict.**
    - It will make sure that the pod only gets scheduled when the operator matches with the label. 

-E.g  there is this pod 
![[Pasted image 20260509090022.png]]

It will be scheduled on node 1 and node 2, but it will make sure it does the scheduling. 
- **Node 1**: `disk=hdd` → `hdd` is in the set `{ssd, hdd}` → ✓ match, pod _can_ land here
- **Node 2**: `disk=ssd` → `ssd` is in the set `{ssd, hdd}` → ✓ match, pod _can_ land here
- **Node 3**: `disk=` (empty/no value, or the label is just absent) → empty string is _not_ in `{ssd, hdd}` → ✗ no match, pod is **excluded**
- 
2. **PreferredDuringSchedulingIgnoredDuringExecution**:
    - Specifies preferences that the scheduler attempts to fulfill but doesn’t enforce strictly.
    - **Less Strict.**
    - 
now Node 3 _would_ be eligible (because nothing is strict), it would just score lower than Nodes 1 and 2 and only get the pod if the others were unavailable. That's the "soft" version. The "Ignored During Execution" half of both names just means: once the pod is running, if you later change the node's label so it no longer matches, the pod doesn't get evicted  the rule is only enforced **at scheduling time.**

It will make sure it matches the label

![[Pasted image 20260509091528.png]]

Here it will not schedule the pod as it does not match any of the label. The pod will be stuck in the pending state & you will see an error messsage or warning message in the describe that no affinity matches. 
### Node Affinity Example 

As taints and tolerations do not provide gurantee to be scheduled on a particular pod. 

![[Pasted image 20260508173230.png]]

The pod with affinity disk!=ssd will be  

![[Pasted image 20260508174129.png]]