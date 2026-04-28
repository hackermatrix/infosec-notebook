
YAML file extensions can be .yaml or yml 

YAML supports different data types list, integer & a lot more. 

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

Note in other fields you have to mentioned the exact specification but in the label you can have any key value.

![[Pasted image 20260428002154.png]]

![[Pasted image 20260428002339.png]]
![[Pasted image 20260428002420.png]]

*Rembember the labels should not be the same level as metadata*