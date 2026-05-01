There are two pods in the pending state. In one pod we have mentioned a field called nodeName. 

We have instructed that schedule the pod on worker node 1
Another pod where node name is not specified. 
![[Pasted image 20260501162335.png]]

this particular pod is the candidate for schedular. The schedular will go and scan all the pods in the pending state, 

![[Pasted image 20260501162520.png]]

It is looking for the pod which does not have selector field have no node name specified. 
.
![[Pasted image 20260501162549.png]]

