
## Difference between virtual machine & containers: 

![[Pasted image 20260420151027.png]]![[Pasted image 20260420151153.png]]

## Docker Workflow 

#### Dockerfile:
![[Pasted image 20260420151723.png]]

A Dockerfile is a text file containing instructions for building your source code. The Dockerfile instruction syntax is defined by the specification reference in the [Dockerfile reference](https://docs.docker.com/reference/dockerfile/).

You can change the name Dockerfile but the best practise is not to change it. 

There is one dockerfile per application
### Docker build

Docker build command is issued to docker daemon such as dockerd. 

The image is then stored locally. 

### Docker Push 

docker push command will move the image from local registry to image registry. 


An image registry is a general term for a centralized server that stores container images, while a local registry is a specific instance of that server running within your immediate network or on your own machine

These image registry could be your artifact registry, Dockerhub. 

### Docker Pull

Docker pull command will be run on that environment Eg. dev environment will pull that image. It will interact with the docker daemon. 

Docker daemon will then pull the image from the registry to the environment, 

## Docker run 

Docker daemon will instruct the container runtime. Will spin the container based on the instructions, image and 

