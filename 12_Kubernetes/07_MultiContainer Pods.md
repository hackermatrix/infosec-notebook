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


2. Sidecar/helper container
