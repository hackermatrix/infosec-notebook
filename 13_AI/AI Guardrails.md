**Components:**

The guard object is the main interface for Guardrails. It can be used without configuration for string-based LLM apps, and accepts a pydantic object for structured data usecases. The Guard is then used to run the Guardrails AI engine. It is the object that wraps LLM calls, orchestrates validation, and keeps track of call history.

String-based LLM apps are applications where you send a text prompt to an LLM and get back plain text (a string). There's no expected structure to the output — it's just free-form text. Think of a chatbot where you ask a question and get a paragraph back. In this case, you can use the Guard object without any special configuration because you're just validating raw text (e.g., checking if the output contains toxic language, or if it's within a certain length).

Pydantic object usage is for when you need the LLM's output to follow a specific structure — like a JSON object with defined fields and types. Pydantic is a Python library for data validation. You define a model (a schema) that says "I expect a response with a name field that's a string, an age field that's an integer," etc. When you pass a Pydantic object to the Guard, it knows the shape of the data you expect and can validate that the LLM's output actually conforms to that structure.

![[Pasted image 20260324050232.png]]
![[Pasted image 20260324050316.png]]
**

**Validators**

Validators are how we apply quality controls to the outputs of LLMs. They specify the criteria to measure whether an output is valid, as well as what actions to take when an output does not meet those criteria.

Validators are basic Guardrails components that are used to validate an aspect of an LLM workflow. Validators can be used a to prevent end-users from seeing the results of faulty or unsafe LLM responses.  

Eg. PII CHECK

Multiple validators can be combined together into Input and Output Guards that intercept the inputs and outputs of LLMs

**How do Validators work?**

Each validator is a method that encodes some criteria, and checks if a given value meets that criteria.

If the value passes the criteria defined, the validator returns PassResult

If the value does not pass the criteria, a FailResult


**
**
https://guardrailsai.com/guardrails/docs/concepts/guard
https://guardrailsai.com/guardrails/docs/quickstart/guardrails_server
https://guardrailsai.com/hub
https://guardrails.openai.com/