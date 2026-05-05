

## - How LLM APIs work.


**The client = your application code** that sits between the user, the LLM, and external APIs. It's the orchestrator. Concrete examples: the ChatGPT web app (the JS running in your browser + their backend), the Claude Desktop app, a custom Python script you wrote that calls `anthropic.messages.create()`, or — relevant to your Governance Sentinel work — an MCP host like Claude Desktop. **The LLM itself never directly touches an external API.** It only generates text/JSON saying "please call this function with these args," and the client decides whether and how to actually do it.
**

![[Pasted image 20260505151832.png]]
- **You → Client**: you type into the Claude Desktop window. The client here is Claude Desktop itself.
- **Client → LLM**: Claude Desktop sends a request to `api.anthropic.com/v1/messages` with your prompt _plus_ a list of available tools (e.g., `get_weather` with a JSON schema for its arguments).
- **LLM → Client**: the model responds with a `tool_use` block — JSON saying `{"name": "get_weather", "input": {"city": "Boston"}}`. **It does not call anything.** It just emits structured output.
- **Client → External API**: Claude Desktop's code parses that JSON, looks up which function `get_weather` maps to, and makes the actual HTTPS call to a weather service.
- **External API → Client**: weather service returns `{"temp": 45, "conditions": "rainy"}`.
- **Client → LLM**: Claude Desktop sends a _new_ API request that includes the original conversation plus a `tool_result` block with the weather data.
- **LLM → Client**: now with the data in context, the model generates a normal text reply.
- **Client → User**: Claude Desktop renders that text in the UI.