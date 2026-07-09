Auditing My Own AWS Account: A Before/After Cloud Security Story

This blog is to check if my foundational understanding on how AWS Security works and how cloud security audit works end-to-end from initial audit to revalidation. I deployed some services whichever available on  the free tier account. The intent was to cover major domains like Identity & Access Management, Network, Compute, Storage, Logging & Monitoring Took a demo use case that a social media application is hosted on EC2 instance and the S3 bucket stores user images. Instead of creating my own tool or doing manual configuration checks. I chosed an open source open-source tools prowler for my demo environment.    

The blog highlights my understanding of cloud security audit. 
# Initial Deployment.

For initial Deployment and feasibility of the project I choose to deploy through AWS console. I understand for enterprise level environments an Infrastructure a Code tool is used. 

Firstly used my root user account for the deployments, which i was hoping to be flagged as per the security practise root user should not be used for frequently. I did not set up any form of multi-factor authentication on the root account. Then I created user tara and attached administrative IAM policy to it. Deployed EC2 instance with over-permissive NACL and security group. S3 bucket was configured with public access open, the security features such as object lock, versioning multi-factor authentication disabled. I also did not deploy the S3 bucket policy. Did not configure logging and monitoring. 

# Configuring Prowler

![[Screenshot 2026-07-07 162541.png]]

![[Pasted image 20260709144803.png]]

## Creating a user called audit with read permissions whose details I provided to prowler. 


![[Pasted image 20260709145111.png]]


![[Screenshot 2026-07-07 162828.png]]

![[Screenshot 2026-07-07 163035.png]]

![[Screenshot 2026-07-07 163101.png]]

## Started the scan 

![[Screenshot 2026-07-07 165619.png]]

![[Pasted image 20260709145420.png]]

![[Pasted image 20260709145514.png]]

![[Pasted image 20260709145620.png]]

Per the below image you can observe that same finding for security group has been iterated again the security concern can be communicated through the failed finding that the security groups does not have all ports open to the internet. Rest just seem repeated. 

![[Screenshot 2026-07-07 172224.png]]

![[Pasted image 20260709145938.png]]






