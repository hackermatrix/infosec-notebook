
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

##  Deploying a metrics  server 

### What is metrics server 
It exposes metrics of the server

![[Pasted image 20260509120058.png]]
![[Pasted image 20260509120123.png]]

Since it is an add on it will be in the kube-system. Why is metric-server in the kube-system.

**Cluster-wide infrastructure add-ons — things that aren't application workloads but are part of the platform** — get grouped there so cluster operators have a predictable place to look. Examples that all live in `kube-system` by convention:

- CoreDNS (DNS resolution for the cluster)
- kube-proxy (networking on each node)
- CNI plugins (Calico, Flannel, Cilium often)
- metrics-server (resource metrics for `kubectl top`)
- cluster autoscaler


When i do kubectl top node i see the metrics.

![[Pasted image 20260509120434.png]]


## Creating namespace

![[Pasted image 20260509121003.png]]



## Understanding resource and limits in yaml file. 

![[Pasted image 20260509121104.png]]
This image is there to do stress testing on the cluster. It will put some pressure on the nodes based on the arguments that we have passed. 

https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/


Remember memory, cpu  are the resources of the container , so resources and limit in the yaml  will always be a child of the container.

```yaml
containers:
  - name: app
    image: images.my-company.example/app:v4
    resources:
      requests:
        memory: "64Mi"
        cpu: "250m"
      limits:
        memory: "128Mi"
        cpu: "500m"
```

There are two properties: 
1. Requests 
2. Limits

Mi here is not megabytes it is a different unit. but similar to MB 

![[Pasted image 20260509122105.png]]

100Mi of memory here means it will be allocated 100Mi to the pod at the very beginning. It can go upto 200 MB and after that the pod will be killed. 


![[Pasted image 20260509122325.png]]

if you dont specify the limits the pod will take whatever memory the node has. It can end up killing the node. Here 100 Mb is the lower bound and 200 MB is the upper bound. 


Now here with the help of command and argument we are over writing 
![[Pasted image 20260509122537.png]]

![[Pasted image 20260509122523.png]]

when you apply this yaml file though it says pod created it gives  OOMKilled error 

![[Pasted image 20260509123047.png]]

![[Pasted image 20260509124213.png]]