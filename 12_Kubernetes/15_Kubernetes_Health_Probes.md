![[Pasted image 20260509142532.png]]

Some system some process that is monitoring your system & taking some necessary actions. to either recover the health or to grab some status to ensure that everything is working fine. 

All the health probes make sure that your application is **healthy.** The application is self healing when it is failed it should be restarted automatically recovered from failure & your user should not be impacted. 


# Liveness probes: 

Monitors your application. Sometimes when the application is failed or crashed due to intermittent network error or some application error. Something that could be recovered easily by restarting the container so it monitors that and takes the necessary actions like it keeps on restarting the application after a while if it does not restart it will throw the error so you will have some time to fix the issue. 

# Readiness probes: 

It ensures that your application is ready before it starts serving traffic to the user. 


![[Pasted image 20260509144541.png]]

E.g there are three applications behind the load balancer in a deployment. Now let us consider that there is an application that takes 20 or 30 seconds to boot up to be started completely. 

So till that time your users will be getting five or two errors that your application is down. So to prevent that from happening. make sure your application is added to the loadbalancer or it should only be ready to **accept the traffic from the user once the readiness probes are passed and it will wait for certain time & it will not drop the application unless it is fully started.** 


# Startup probes 

Startup probes are for **slow or legacy container applications. Applications that take a lot of time to start up**. It will make sure that **your application will wait 5 minutes before it starts before serving the traffic and only then the rest of the props will be active.** 

First the **startup probe will be active it will make sure that it works and only then readiness and liveliness probes will be active.** 


We will use a combination of these probes in a production environment and mostly liveliness and readiness probe. 


# Types of Health Checks 

HTTP
TCP 
