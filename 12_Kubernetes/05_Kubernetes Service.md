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

### Checking if the nodeport is exposed on kubernetes 

![[Pasted image 20260430153345.png]]

Then you describe any pod using 

![[Pasted image 20260430153451.png]]

Check on the port it is running using curl

![[Pasted image 20260430153735.png]]



### How to do deploy nodeport using kind simulation

Remember node is a physical or virtual machine but in kind the node is a container when you deploy a container you need to do port mapping. Kind does not expose the cluster directly.

#### Step 1: Create cluster with port mapping 

![[Pasted image 20260430012034.png]]

Will have to recreate the cluster not just apply 

create builds the actual Kubernetes cluster itself. Think of it as constructing the building — setting up the nodes, the control plane, etcd, networking. Without this, there's no Kubernetes at all.

apply deploys resources (pods, services, deployments) onto an **already running** cluster. This is like furnishing the rooms inside the building.


![[Pasted image 20260430143142.png]]

By default it switches you to context3 but still i switched 

![[Pasted image 20260430143638.png]]

#### Step 2: Apply the replicaset 
![[Pasted image 20260430144816.png]]

![[Pasted image 20260430144840.png]]

![[Pasted image 20260430144906.png]]

#### Step 3: Apply the nodeport yaml file : check the nodeport yaml file 

![[Pasted image 20260430151343.png]]
![[Pasted image 20260430151424.png]]
```
kubectl apply -f nodeport.yaml
```
![[Pasted image 20260430151612.png]]

#### Step 4: Check if nodeport is working 

```

kubectl describe svc nodeport

```
![[Pasted image 20260430152116.png]]

![[Pasted image 20260430152231.png]]

Note nginx works on http
![[Pasted image 20260430152538.png]]

## **ClusterIP**:

Every pod has its own IP and it is not static . 

![[Pasted image 20260430160758.png]]



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


![[Pasted image 20260430162043.png]]

You can access the pods from backend to front using ip or service. 

ClusterIP works on port 443 , http, https ports 

### How to create ClusterIP

![[Pasted image 20260430164418.png]]

![[Pasted image 20260430164359.png]]

![[Pasted image 20260430170001.png]]

Endpoint is the ip of the pod on which the service is listening to. 
![[Pasted image 20260430170127.png]]

**ClusterIP (10.96.230.205)** — stays constant for the lifetime of the service. As long as this service exists, this IP never changes. Other pods can always reach it at `10.96.230.205:80`. This is why services exist — they give you a stable address.
## Loadbalancer 

![[Pasted image 20260430170733.png]]

### How to deploy Loadbalancer 

![[Pasted image 20260430171728.png]]

![[Pasted image 20260430171718.png]]
The reason external-ip has pending because we have not configured an external loadbalancer. 

https://kind.sigs.k8s.io/docs/user/loadbalancer/


## External Loadbalancer 
![[Pasted image 20260430172143.png]]


You create: Service with type: LoadBalancer
                ↓ Kubernetes tells the cloud provider
Cloud creates: An actual external load balancer (like AWS ELB)
                ↓ gets a public IP
Users reach:  public-ip:80 → Load Balancer → NodePort → Service → Pods

## Imperative way to deploy service 

![[Pasted image 20260430172437.png]]

