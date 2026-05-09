
# Understanding the concept with example 

## Example 1

![[Pasted image 20260509113804.png]]


![[Pasted image 20260509113742.png]]

Now both the nodes are running at full capacity. Any next pod that will be run will face an error (refer the image) and will not be scheduled. 

![[Pasted image 20260509113931.png]]

## Example 2 


![[Pasted image 20260509114241.png]]

Now in the above image I have not mentioned the specifications of the pod it requires cpu=1 and memory=1 but not clearly mentioned in the pod. 

How much it should request and what is the limit. We are not bounding it to a resource capacity. it started with cpu=1 and memory=1 as the load increases it takes the entire node memory. 

![[Pasted image 20260509114547.png]]

When it tries to take more the node crashes. Node will throw an error

![[Pasted image 20260509114633.png]]


That is why we define the resource and limits in the pod in the container so whenever the pod tries to request more memory the pod will crash not the node. 

# Deploying Rate and Limits

## What is metrics 

It exposes metrics of the server