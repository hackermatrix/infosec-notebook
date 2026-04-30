-  In Kubernetes, a Service is a method for exposing a network application that is running as one or more [Pods](https://kubernetes.io/docs/concepts/workloads/pods/) in your cluster.

## Why are services needed

To make our  application accessible to users, how do we ensure that our frontend pods are able to communicate with the backend pods, our backend pods should be able to communicate with external database. This is done with the help of our services. 

![[Pasted image 20260429202320.png]]

Users will access the service, the service will access the frontend pod on which the service is exposed & give response back to the user. 


Service will make the application loosely coupled & accessible to only what is specified. 
![[Pasted image 20260429202541.png]]

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