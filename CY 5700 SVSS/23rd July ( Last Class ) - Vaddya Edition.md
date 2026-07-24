


# Threat Modelling (Potential Project )

#### What are you worried about ?

- This is done even before you have the System architecture.



#### Steps to do this :
1. What are you building ? - Model
2. What could possible go wrong ? - Analyze
3. What do you do about it ? - Manage 


**Modelling** - Drawing the pictures ( Done by dev in most cases )
- Security People Guide this picture to focus on more important part.
- THis diagram is also called DFD (**Data Flow Diagram**)


### DFD  components :
1. External Entity : External sources that may provide inputs to ur system.
2. Process 
3. Data Source 
4. Data Flow 
5. Trust Boundry : The Dotted Lines in the diagram in the slides (6:33PM)
	- Also called as seperators between two trustzones

>[! Interesting]
>- The Arrows between two trust boundries shows flow of data .
>- **The arrow flowing from Internet to the frontend shows that untrusted data is flowing inside (making that an interesting place to look at )**



## Analyze
- STRIDE is the industry Standard
1. Spoofing
2. Tampering
3. REpudation
4. Information Disclousure
5. Denial of Service
6. Elevation of Privilege
- They map one to one to security Goals 


## How do we do it ?

for each element in your model:
	for each letter in STRIDE:
		Find threats.



## Then how do u know that you are doing a good job then ?
- <mark style="background: #FFB86CA6;">You have a senior person to decide what things should we keep our focus on .</mark>


## How to find Good Threats ? (IMPORTANT)
- **Focus on the Diagram**
- Avoid Security Fantasy.
- **FOLLOW THESE RULES**:
	1. Threats should be relevant to the model ( The diagram ).
	2. **Find Impactful Things** - > **Non-trivial** and **actionable** threats . <mark style="background: #FF5582A6;"> (Strictly Prioritize!!!)</mark>
						- You cannot say that the data can be intercepted( Cause that's a solved problem).
						- You also cannot say a meteor could strike the Data center (Cause that is not solvable )
	3. Threats should be **Complete and well Framed:**
		- Can a rando dev tackle that ticket ?
		- **Threat recipe:**
		- \<Bad entity> does \<Bad thing> by exploiting \<bad design> ,which results in \<badness>
