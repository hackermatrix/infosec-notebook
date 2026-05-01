- When architecting multi-container Pods, the two most powerful patterns are **Init Containers** and **Sidecar Containers**. The distinction between them comes down entirely to their **lifecycle** and **purpose**.

![[Pasted image 20260501045220.png]]


1. **Init Containers** :
	- Starts before the main app container starts. So when kubelet sends a request to the pod for the initialization like let's start the pod it will first start the init container. 
	- Setups things before the starting the man container.
	- Sometimes it is something that runs, does its thing and exits ( e.g busybox )
	- It shares the resources of the pod. lets say we have allocated some memory, some cpu, some storage to the pod. All those resources will be shared among all the container inside that pod. 
	- **Example**: Checking weather a service on which our main application depends has started or not using nslookup.  

- **Example**: 
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: myapp-pod
  labels:
    app.kubernetes.io/name: MyApp
spec:
  containers:
  - name: myapp-container
    image: busybox:1.28
    command: ['sh', '-c', 'echo The app is running! && sleep 3600']
  initContainers:
  - name: init-myservice
    image: busybox:1.28
    command: ['sh', '-c', "until nslookup myservice.$(cat /var/run/secrets/kubernetes.io/serviceaccount/namespace).svc.cluster.local; do echo waiting for myservice; sleep 2; done"]
  - name: init-mydb
    image: busybox:1.28
    command: ['sh', '-c', "until nslookup mydb.$(cat /var/run/secrets/kubernetes.io/serviceaccount/namespace).svc.cluster.local; do echo waiting for mydb; sleep 2; done"]
```

https://kubernetes.io/docs/concepts/workloads/pods/init-containers/

After you have created your yaml file & it is deployed it will show pending/waiting initialization. 
![[Pasted image 20260501082629.png]]
![[Pasted image 20260501082655.png]]

## Example 

└──╼ $cat init.yaml
apiVersion: v1
kind: Pod
metadata:
  name: myapp-pod
  labels:
    app.kubernetes.io/name: MyApp
spec:
  containers:
  - name: myapp-container
    image: busybox:1.28
    command: ['sh', '-c', 'echo The app is running! && sleep 3600']
  initContainers:
  - name: init-myservice
    image: busybox:1.28
    command: ['sh', '-c', "until nslookup myservice.$(cat /var/run/secrets/kubernetes.io/serviceaccount/namespace).svc.cluster.local; do echo waiting for myservice; sleep 2; done"]

Let us check if my deployment is working fine.

kubectl apply -f init.yaml
pod/myapp-pod created
┌─[tara@parrot]─[~/kubernetes]
└──╼ $kubectl logs myapp-pod
Defaulted container "myapp-container" out of: myapp-container, init-myservice (init)
Error from server (BadRequest): container "myapp-container" in pod "myapp-pod" is waiting to start: PodInitializing

It's running an infinite loop waiting for a **Service called `myservice`**

 
https://kubernetes.io/docs/concepts/services-networking/service/
https://kubernetes.io/docs/tasks/manage-kubernetes-objects/imperative-command/

Imperative way 

```
kubectl create service clusterip myservice --tcp=80:80
```

Declarative way 

```yaml

apiVersion: v1

kind: Service

metadata:

  name: myservice

spec:

  ports:

  - protocol: TCP

    port: 80

    targetPort: 9376

---

apiVersion: v1

kind: Service

metadata:

  name: mydb

spec:

  ports:

  - protocol: TCP

    port: 80

    targetPort: 9377
    
```

┌─[✗]─[tara@parrot]─[~/kubernetes]
└──╼ $kubectl apply -f service.yaml
Warning: resource services/myservice is missing the kubectl.kubernetes.io/last-applied-configuration annotation which is required by kubectl apply. kubectl apply should only be used on resources created declaratively by either kubectl create --save-config or kubectl apply. The missing annotation will be patched automatically.
service/myservice configured
service/mydb created
┌─[tara@parrot]─[~/kubernetes]
└──╼ $kubectl logs myapp-pod
Defaulted container "myapp-container" out of: myapp-container, init-myservice (init)
The app is running!
2. Sidecar/helper container
