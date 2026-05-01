_**Taints** and **tolerations** work together to ensure that pods are not scheduled onto inappropriate nodes._
## Taints
- These are applied to **Nodes**.
- They allow a node to repel a set of pods.
- We can schedule control plane components on control plane node any custom work load that you deploy from your side which is not control plane components. Hence, it will not be scheduled you cannot see it in kubectl get nodes. 

## Tolerations
- These are applied to **pods** .
- Tolerations allow the scheduler to schedule pods with matching taints

