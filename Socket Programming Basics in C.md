
## What are Sockets? 
Sockets are the low level endpoints used for processing information across a network.
A socket is the combination of an IP address, port number, and protocol (e.g., TCP), representing the active endpoint for a specific connection.
A socket is a two way endpoint where you can send and receive information. 
There is no thing such as just a client socker or a server socket. 
Socket is dependent on how you use it. 

![[Pasted image 20260508145531.png]]

![[Pasted image 20260508161901.png]]
## Client Socket Workflow

In C there is a socket function. 
You can store the result of the socket function in an integer. 
That;s basically a descriptor that is how we are going to make future calls. 
In the socket function you have to mention the particular socket eg. tcp 

Connect function ()
After the socket is created, we need to connect it to a remote address. Where we specify the IP and the port that we are trying to connect once we have a successful connection it will show a return value that i.e, a successful connection. 

Recieve function()
You can start sending and receivng data. If you are writing a HTTP client you might first make a request data back as a response. But this receive function allows us to get data from whatever the other side of the connection we can receive that data store it print it out write to the file. 

We can read that data back basically to string and then see whatever it looks like. 

Raw sockets which are sockets independent


