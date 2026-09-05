Large Language Models (LLMs) are brilliant, but they live in a bubble. Without a way to interact with the real world, they are prone to “hallucinations” — confidently stating facts that don’t exist.

Model Context Protocol (MCP) is the industry-standard solution to this problem. It provides a safe, structured bridge between LLMs and external capabilities. Today, we’re looking at FastMCP, the Pythonic way to build these tools with minimal boilerplate and maximum reliability.

In this guide, we’ll learn:

    What MCP tools are
    How FastMCP works
    Step-by-step tool creation
    Best practices for production
    How to write tool descriptions

🧠 What Is an MCP Tool?

An MCP tool is essentially a Python function made “visible” to an LLM. Instead of guessing, the LLM can now:

    Query databases for real-time inventory.
    Call APIs for weather or stock prices.
    Access local files to summarize documents.
    Trigger workflows like sending an email or booking a flight.

🔄 Tool Execution Flow

    Selection: The LLM decides which tool to use based on the user’s prompt.
    Parameters: The LLM sends the required arguments (e.g., city="London").
    Validation: FastMCP checks if the inputs match your defined schema.
    Execution: Your Python function runs.
    Response: The result is piped back to the LLM to form its final answer.

This makes LLM systems deterministic, safe, and extensible.
⚙️ Step 1 — Install FastMCP

First ensure you have the correct version:

pip install --upgrade fastmcp

If using requirements:

fastmcp>=3.0.0,<4

🏗️ Step 2 — Create Your MCP Server

Create a basic FastMCP server.

from fastmcp import FastMCP
mcp = FastMCP(name="MyToolServer")

This server will host all your tools.
🔧 Step 3 — Create Your First Tool

The easiest way is using the @mcp.tool decorator.

from fastmcp import FastMCP

mcp = FastMCP(name="CalculatorServer")
@mcp.tool
def add(a: int, b: int) -> int:
    """Adds two integer numbers together."""
    return a + b

✅ FastMCP automatically:

    Uses function name as tool name
    Uses docstring as description
    Generates JSON schema
    Validates inputs
    Handles errors

That’s it — your tool is MCP-ready.
🧾 Step 4 — Customize the Tool (Recommended)

For production systems, add metadata.

@mcp.tool(
    name="find_products",
    description="Search the product catalog",
    tags={"catalog", "search"},
    meta={"version": "1.2"}
)
def search_products(query: str, category: str | None = None) -> list[dict]:
    return [{"id": 1, "name": "Sample Product"}]

🎯 Why this matters

    Better tool discovery
    Cleaner agent behavior
    Easier observability
    Future versioning

🧾 Step 5— How to Write Tool Descriptions

One of the most common mistakes when building MCP tools is misunderstanding how descriptions work. Get this wrong, and your LLM will miss critical context.

Descriptions are the most underrated feature in MCP tool development. They’re not just documentation — they’re instructions to the LLM on when and how to use your tool.
Why Descriptions Matter

The LLM doesn’t read your code. It reads:

    Tool name
    Tool description
    Parameter descriptions

Poor descriptions = wrong tool selection = hallucinations.