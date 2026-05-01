
## 1. DaemonSet:
![[Pasted image 20260430191706.png]]
- Similar to ReplicaSet but it creates a replica in each node.
- If a new node is added to the cluster, the daemonset detects that and adds a pod replica to it and also deletes the replica pod if the node is removed from the cluster.
- It is majorly used for creating things like monitoring agents, logging agent, kube-proxy uses it, etc
- So basically it is used when we need something that we need on every node.
- Example:
```yaml
apiVersion: apps/v1
kind: DaemonSet
metadata:
  name: maza-daemonset-chaan
spec:
  selector:
    matchLabels:
      name: noice
  template:
    metadata:
      labels:
        name: noice
    spec:
      containers:
      - name: vd-nix
        image: nginx
```


## 2. CronJobs

- CronJob is meant for performing regular scheduled actions such as backups, report generation, and so on. 
- One CronJob object is like one line of a _crontab_ (cron table) file on a Unix system. It runs a Job periodically on a given schedule, written in [Cron](https://en.wikipedia.org/wiki/Cron) format.

- Example :
```yaml 
apiVersion: batch/v1
kind: CronJob
metadata:
  name: hello
spec:
  schedule: "* * * * *"
  jobTemplate:
    spec:
      template:
        spec:
          containers:
          - name: hello
            image: busybox:1.28
            imagePullPolicy: IfNotPresent
            command:
            - /bin/sh
            - -c
            - date; echo Hello from the Kubernetes cluster
          restartPolicy: OnFailure

```


## 3. Jobs 

- Jobs represent one-off tasks that run to completion and then stop.
- A Job creates one or more Pods and will continue to retry execution of the Pods until a specified number of them successfully terminate. 
- As pods successfully complete, the Job tracks the successful completions. When a specified number of successful completions is reached, the task (ie, Job) is complete. 
- Deleting a Job will clean up the Pods it created. Suspending a Job will delete its active Pods until the Job is resumed again.
- **Simply put, It is a task that we want to be done and when it completes, the job exits.** 
- Example :
```yaml
# Here is an example Job config. It computes π to 2000 places and prints it out. It takes around 10s to complete.
  apiVersion: batch/v1
kind: Job
metadata:
  name: pi
spec:
  template:
    spec:
      containers:
      - name: pi
        image: perl:5.34.0
        command: ["perl",  "-Mbignum=bpi", "-wle", "print bpi(2000)"]
      restartPolicy: Never
  backoffLimit: 4

```
