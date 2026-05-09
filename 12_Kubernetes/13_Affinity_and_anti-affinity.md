Resources : https://medium.com/@prasad.midde3/understanding-node-affinity-pod-affinity-node-selector-and-pod-anti-affinity-in-kubernetes-7899e218ac6d


## Key Differences Between Kubernetes Scheduling Mechanisms

![[Pasted image 20260505190457.png]]


### Types of Node Affinity/Properties

It is Applied to a pod, telling the scheduler, "Only place me on nodes with these labels"

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

## Example:  RequiredDuringSchedulingIgnoredDuringExecution:

https://kubernetes.io/docs/tasks/configure-pod-container/assign-pods-nodes-using-node-affinity/

### Step 1 Create the yaml file with the pod specification : 
![[Pasted image 20260509100929.png]]
![[Pasted image 20260509100949.png]]
Since it does not match the pod since it is not getting scheduled. 

![[Pasted image 20260509101128.png]]
![[Pasted image 20260509101311.png]]


![[Pasted image 20260509102222.png]]

### Step 2: Apply label to the nodes 

![[Pasted image 20260509102417.png]]

![[Pasted image 20260509102626.png]]

Once we have added the label the node is running. 

The pod is running now:
![[Pasted image 20260509102756.png]]
![[Pasted image 20260509102901.png]]

###  Let us check with operator Exists

it will just check that this label exists or not and it will use that node to schedule the pod. 

![[Pasted image 20260509105820.png]]

Relabel the node 
## Example:  PreferedDuringSchedulingIgnoredDuringExecution:


### Step 1: Change the YAML file 

![[Pasted image 20260509105040.png]]

![[Pasted image 20260509105013.png]]

#### Differene in the yaml file between the two properties.
- `requiredDuringSchedulingIgnoredDuringExecution` takes a **`nodeSelector`** object containing `nodeSelectorTerms` (a list).
- `preferredDuringSchedulingIgnoredDuringExecution` takes a **list** of weighted preference items, each with a `weight` (1–100) and a `preference` (which contains the `matchExpressions`). No `nodeSelectorTerms` key at all.


Now even though we do not have a node with any matching label the pod gets scheduled. 
