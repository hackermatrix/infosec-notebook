_**Taints** and **tolerations** work together to ensure that pods are not scheduled onto inappropriate nodes._
## Taints
- These are applied to **Nodes**.
- They allow a node to repel a set of pods.
- We can schedule control plane components on control plane node any custom work load that you deploy from your side which is not control plane components. Hence, it will not be scheduled you cannot see it in kubectl get nodes. 
-  Example :
```bash
kubectl taint nodes node1 key1=value1:NoSchedule
```


## Tolerations
- These are applied to **pods** .
- Tolerations allow the scheduler to schedule pods with matching taints.
- You specify a toleration for a pod in the PodSpec.
```yaml
tolerations:
- key: "key1"
  operator: "Equal"
  value: "value1"
  effect: "NoSchedule"
```


> [! important]
> The default Kubernetes scheduler takes taints and tolerations into account when selecting a node to run a particular Pod. However, if you manually specify the `.spec.nodeName` for a Pod, that action bypasses the scheduler; the Pod is then bound onto the node where you assigned it, even if there are `NoSchedule` taints on that node that you selected. If this happens and the node also has a `NoExecute` taint set, the kubelet will eject the Pod unless there is an appropriate tolerance set.
## What are operator and effects ?

1. **Operator** :
	- Two values are possible "Exists" and "Equal".
	- **Equal** : The toleration should exactly match the key and well as the value of the taint.
	- **Exists** : The toleration in this case only needs to match the key of the taint.
	- The default value of operator is Equal.
2. **Effect** :
	- Effect is the scheduling type. 
	- Effect is mentioned in the toleration and taint. But precednece is more on the taint than toleration.
	- It can have three possible values : **NoExecute**, **NoSchedule**, **PreferNoSchedule**.
	1. **NoExecute:** 
		- NoExecute works on the already existing pods. 
		- Affects already running pods .
		- If we check this effect on toleration it will check if there is any existing pod as well as running. 
		- Pods that do not tolerate the taint are removed immediately.
		- For the eviction to work, "**tolerationSeconds**" needs to be specified in the pod spec or else the pod is not removed.
		
	2. **NoSchedule:**
		- NoSchedule works on the newer pods. 
		- No new Pods will be scheduled on the tainted node unless they have a matching toleration.
		- Running pods are not removed.
		
	3. **PreferNoSchedule :**
		- PereferNoSchedule tries to apply that but does not gurantee pod scheduling for that particular taints and tolerations.
		- A soft version of NoSchedule.
		- The control plane will _try_ to avoid placing a Pod that does not tolerate the taint on the node, but it is not guaranteed.

## Multiple Taints and Torelations 
- You can put multiple taints on the same node and multiple tolerations on the same pod.
- Kubernetes does the following:
	1. Look at all taints on the node
	2. Remove the ones the pod can tolerate
	3. Whatever is left (“un-ignored taints”) decides what happens


## Assigning Pods to Nodes

#### Node labels



- We can also add labels to Nodes similar to any object in kubernetes.
- Assigning label to a node:
```bash
kubectl label nodes <node-name> <key>=<value>
```
- verifying a label:
```
kubectl get nodes --show-labels
```

#### nodeSelector
- We You can add the `nodeSelector` field to your Pod specification and specify the node labels you want the target node to have. 
- ![[Pasted image 20260501181401.png]]
- nodeSelectors does not support any logical operators like : "AND","OR",etc. For that we use the concept of [Affinity and anti-affinity](13_Affinity_and_anti-affinity)


## Taints flow

![[Pasted image 20260501201141.png]]

Let us assume Node 1 is specialized to run AI workloads, we will tain this node with gpu value = true. 

Now let us assume the pod is scheduled to run on particular node it will first go and check the scheduler who is responsible.

![[Pasted image 20260501201308.png]]

The scheduler will try to schedule rhe pod on the node1, but the node has a taint which says that gpu=true. So this won't be schedule here. 

![[Pasted image 20260501201505.png]]![[Pasted image 20260501202633.png]]

![[Pasted image 20260501202928.png]]

We have to make sure that toleration that we are scheduling is scheduled successfully on node 1. 

In this pod we will add something such as toleration. Toleration is something that will enable the pod to be scheduled on the node in which there is toleration.  

Let us say we have the toleration as gpu = true , then the node 

![[Pasted image 20260501205019.png]]

Here we are instructing the node to accept only certain pods. So this particular node will only accept the pod that has toleration of GPU = true. 

Let us this node is a bigger node. It has GPU's running. It has extensive memory & other resources & we want this node to be specialized for AI workload. Any other pods that are running non AI-ML workloads can go to other nodes available. 

Toleration has a key value pair which suggests what type of toleration or what type of taints to tolerate. 

![[Pasted image 20260501205934.png]]

Remember taint is on node and toleration is on pod. 

