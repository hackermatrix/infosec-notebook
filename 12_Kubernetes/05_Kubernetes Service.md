-  In Kubernetes, a Service is a method for exposing a network application that is running as one or more [Pods](https://kubernetes.io/docs/concepts/workloads/pods/) in your cluster.

## Why are services needed

To make our  application accessible to users, how do we ensure that our frontend pods are able to communicate with the backend pods, our backend pods should be able to communicate with external database. This is done with the help of our services. 

![[Pasted image 20260429202320.png]]

Users will access the service, the service will access the frontend pod on which the service is exposed & give response back to the user. 


Service will make the application loosely coupled & accessible to only what is specified. 
![[Pasted image 20260429202541.png]]

![[Pasted image 20260429212704.png]]

## How to get information about services

kubectl get svc 

![[Pasted image 20260430003456.png]]

## Types of Service

1. ClusterIP
2. Nodeport 
3. ExternalName 
4. Loadbalancer 


## NodePort 

![[Pasted image 20260429202702.png]]

Service on which the application will be exposed on a particular port and that port is called nodeport. 

Let us assume we expose the application on port 30001. The range for node port exposed is 30001 to 32767.

We have to specify a static port between that range. Our application will be listening on port 30001. Our service will be exposed internally within the cluster. All the service that our internal to the cluster. will be accessing this on  port 80. 

![[Pasted image 20260429203135.png]]

Target pod is the port on which our application pod is listening. Targerport is something that is not exposed externally (port 80)

**nodePort: 30001** — The port on the **node (machine)** itself. This is what external users hit. They type `http://<node-ip>:30001` in their browser. Must be in range 30000-32767.  Node port is exposed externally (30001). Nodeport redirect the traffic from 30001 to target port 80. 

**port: 80** — The port on the **Service**. This is the service's own port inside the cluster. Other pods within the cluster can reach nginx at `http://<service-name>:80`.

**targetPort: 80** — The port on the **Pod/container**. This is where nginx is actually listening. The service forwards traffic here.

![[Pasted image 20260429210844.png]]


![[Pasted image 20260429211004.png]]

The port 80 pointed towards service will be used for other services or other applications that our running in the cluster. 

### Nodeport yaml file 

![[Pasted image 20260429214136.png]]

![[Pasted image 20260429214156.png]]

https://kubernetes.io/docs/concepts/services-networking/service/#type-nodeport

selector is used to mention which pod or deployment served as a service. Now remebmer selector has label field. To check the label field 
![[Pasted image 20260429215636.png]]

So now I am labelling it as env
![[Pasted image 20260430003334.png]]

![[Pasted image 20260430003250.png]]


### Nodeport port mapping in kind

Remember node is a physical or virtual machine but in kind the node is a container when you deploy a container you need to do port mapping. 
![[Pasted image 20260430012034.png]]




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