
YAML file extensions can be .yaml or yml 

YAML supports different data types list, integer & a lot more. 

Important YAML does not support tab only spaces. 

apiVersion: v1          ← 0 spaces (top level)
kind: Pod               ← 0 spaces
metadata:               ← 0 spaces
  name: demo-pod        ← 2 spaces (under metadata)
  labels:               ← 2 spaces (under metadata)
    env: demo           ← 4 spaces (under labels)
    type: frontend      ← 4 spaces (under labels)
spec:                   ← 0 spaces (top level)
  containers:           ← 2 spaces (under spec)
  - name: nginx-container  ← 2 spaces (list item under containers)
    image: nginx           ← 4 spaces (under the container)
    ports:                 ← 4 spaces (under the container)
    - containerPort: 80    ← 4 spaces (list item under ports)
## Syntax 

Identation in yaml should be taken care of:
![[Pasted image 20260427235431.png]]

this will not work 
![[Pasted image 20260428000527.png]]

There are 4 fields in yaml:
It should be small letters.
![[Pasted image 20260428001019.png]]

Run kubectl explain pod, will tell you what all versions are available.

![[Pasted image 20260428001240.png]]


In metadata there are different fields such as name, labels 

labels are helpful to group your resources together. 

Note in other fields you have to mentioned the exact specification but in the label you can have any key value.

![[Pasted image 20260428002154.png]]

![[Pasted image 20260428002339.png]]
![[Pasted image 20260428002420.png]]

Note the containerPort:80 is not port mapping. it just declares that the container listens on port 80 inside the pod. It doesn't expose anything to the outside.

**Host-to-container mapping**
hostPort: 8080

*Rembember the labels should not be the same level as metadata

Suppose you mispronoune a name
![[Pasted image 20260428010921.png]]

Though it gives a warning it does get configured.
![[Pasted image 20260428011022.png]]

Here you see it does not show ready 
![[Pasted image 20260428011058.png]]

**CrashLoopBackOff** means Kubernetes **successfully pulled the image and started the container, but it keeps crashing**. The container starts, dies, Kubernetes restarts it, it dies again — and after several tries it backs off.