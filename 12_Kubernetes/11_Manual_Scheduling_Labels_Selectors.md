## What is manual_scheduling 

There are two pods in the pending state. In one pod we have mentioned a field called nodeName. 

We have instructed that schedule the pod on worker node 1
Another pod where node name is not specified. 
![[Pasted image 20260501162335.png]]

this particular pod is the candidate for schedular. The schedular will go and scan all the pods in the pending state, 

![[Pasted image 20260501162520.png]]

It is looking for the pod which does not have selector field have no node name specified. 
.
![[Pasted image 20260501162549.png]]

## How to deploy manual scheduling

Changing a yaml file 

![[Pasted image 20260501175506.png]]
![[Pasted image 20260501180418.png]]

## Labels

Labels are attached as part of metadata. It is helpful in filtering that particular resource. It is not just for deployment it is for pods, daemonsets & for many kubernetes resources, objects 

So eg 

![[Pasted image 20260501184919.png]]. 

This label is specific to the deployment. 

![[Pasted image 20260501185023.png]]

env: demo written in the above image is for pod.

Label with the selector term: 

![[Pasted image 20260501185137.png]]

Here selector is matching the label of pod with the deployment it is saying that match the labels for where the environment equal to demo it will check and find the environment equal to demo is for this particular pod. 

Annotations is not labels it is similar but it will store additional details additional  additional information related to object itself lets say it will add one more additional information which will be easier for the controller to know how to roll back & how to make changes. 

![[Pasted image 20260501193226.png]]



eg. customer rating filter in Amazon is the labels. 