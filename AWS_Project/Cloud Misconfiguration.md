
![[Pasted image 20260707162613.png]]
![[Pasted image 20260707162656.png]]

![[Pasted image 20260707162832.png]]

![[Pasted image 20260707164858.png]]

![[Pasted image 20260707165341.png]]

![[Pasted image 20260707165623.png]]
![[Pasted image 20260707165655.png]]

![[Pasted image 20260707165805.png]]

![[Pasted image 20260707172205.png]]

![[Pasted image 20260707172228.png]]

![[Pasted image 20260707172247.png]]

![[Pasted image 20260707172336.png]]

![[Pasted image 20260707172405.png]]

![[Pasted image 20260707172516.png]]

![[Pasted image 20260707172546.png]]

![[Pasted image 20260707172609.png]]


# To Remediate

![[Pasted image 20260707183317.png]]


![[Pasted image 20260707183346.png]]

![[Pasted image 20260707183717.png]]

![[Pasted image 20260707183747.png]]

![[Pasted image 20260707183811.png]]

![[Pasted image 20260707183842.png]]

![[Pasted image 20260707183857.png]]

![[Pasted image 20260707183919.png]]

Should be enabled only for the region required. 

![[Pasted image 20260707184016.png]]

This subnet (`subnet-0280797f5d54edd5c`, in `us-east-2`) has an attribute called **"Auto-assign public IP"** turned **ON**. That means: any EC2 instance you launch into this subnet — _without you explicitly saying otherwise_ — automatically gets a public IP address, exposed directly to the internet.
![[Pasted image 20260707184829.png]]


![[Pasted image 20260707185228.png]]


IMDSv1 can be vulnerable to SSRF attacks 

![[Pasted image 20260707190149.png]]

![[Pasted image 20260707190330.png]]

![[Pasted image 20260707191339.png]]

![[Pasted image 20260707191435.png]]

![[Pasted image 20260707192248.png]]

![[Pasted image 20260707194705.png]]

![[Pasted image 20260707203636.png]]

![[Pasted image 20260707203756.png]]
![[Pasted image 20260707205357.png]]

![[Pasted image 20260707204558.png]]

![[Pasted image 20260707204614.png]]

![[Pasted image 20260707204754.png]]

![[Pasted image 20260707204815.png]]
# Debatable based on use case 

EC2 instance has detailed monitoring enabled
https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/manage-detailed-monitoring.html

![[Pasted image 20260707190953.png]]

TBD on this finding - debatable 


![[Pasted image 20260707190547.png]]


At least one AWS Backup vault exists
![[Pasted image 20260707191038.png]]

use case specific 


![[Pasted image 20260707194620.png]]


![[Pasted image 20260707205319.png]]

# Remediated

![[Pasted image 20260708144211.png]]