# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## 🎯 IMPORTANT: Graphiti MCP Integration Active

**You have access to Graphiti MCP tools!** This is Milos's fork of Graphiti, set up specifically to create a persistent knowledge base for our collaboration. Use these tools proactively:

### Available MCP Tools
- `add_memory`: Store new knowledge, preferences, solutions, and patterns
- `search_nodes`: Find relevant information from past interactions
- `search_facts`: Discover relationships between concepts
- `get_episodes`: Retrieve recent context

### How to Use
1. **Before starting any task**: Search for relevant past knowledge
2. **After solving problems**: Store the solution for future reference
3. **When learning preferences**: Immediately save them to the graph
4. **For complex tasks**: Break down and store individual insights

### Current Setup
- **Database**: Neo4j Aura Free (cloud-hosted, always available)
- **Connection**: Configured via `~/.claude/settings.json`
- **Purpose**: Replace static CLAUDE.md files with dynamic knowledge graph

## Project Overview

Graphiti is a Python framework for building temporally-aware knowledge graphs designed for AI agents. It enables real-time incremental updates to knowledge graphs without batch recomputation, making it suitable for dynamic environments.

Key features:

- Bi-temporal data model with explicit tracking of event occurrence times
- Hybrid retrieval combining semantic embeddings, keyword search (BM25), and graph traversal
- Support for custom entity definitions via Pydantic models
- Integration with Neo4j and FalkorDB as graph storage backends

## Development Commands

### Main Development Commands (run from project root)

```bash
# Install dependencies
uv sync --extra dev

# Format code (ruff import sorting + formatting)
make format

# Lint code (ruff + mypy type checking)
make lint

# Run tests
make test

# Run all checks (format, lint, test)
make check

# Run a single test file
pytest tests/test_graphiti.py

# Run tests matching a pattern
pytest -k "test_add_episode"

# Run tests with verbose output
pytest -v
```

### Server Development (run from server/ directory)

```bash
cd server/
# Install server dependencies
uv sync --extra dev

# Run server in development mode
uvicorn graph_service.main:app --reload

# Format, lint, test server code
make format
make lint
make test
```

### MCP Server Development

```bash
# Setup environment (from project root)
make setup  # Copies .env.example to .env

# Run MCP server
make run     # or: uv run graphiti_mcp_server.py
make run-sse # Run with SSE transport

# Run with Docker
make run-docker  # or: docker compose up
make clean       # Clean up Docker and cache files

# Sync with upstream repository
make merge-upstream  # Fetch and merge latest changes from upstream
```

## Code Architecture

### Core Library (`graphiti_core/`)

The core library follows an orchestrator pattern with the `Graphiti` class as the main entry point:

- **Main Entry Point**: `graphiti.py` - Contains the main `Graphiti` class that orchestrates all functionality
- **Graph Storage**: `driver/` - Database drivers for Neo4j and FalkorDB with common interface
- **LLM Integration**: `llm_client/` - Strategy pattern for multiple providers (OpenAI, Anthropic, Gemini, Groq)
- **Embeddings**: `embedder/` - Embedding clients for various providers (OpenAI, Voyage, custom)
- **Graph Elements**: `nodes.py`, `edges.py` - Core data structures (`EntityNode`, `EpisodicNode`, `EntityEdge`, `EpisodicEdge`)
- **Search**: `search/` - Hybrid search implementation combining embeddings, BM25, and graph traversal
- **Prompts**: `prompts/` - LLM prompts for entity extraction, deduplication, summarization
- **Utilities**: `utils/` - Bulk processing, maintenance operations, datetime handling

### Server (`server/`)

- **FastAPI Service**: `graph_service/main.py` - REST API server
- **Routers**: `routers/` - API endpoints for ingestion and retrieval
- **DTOs**: `dto/` - Data transfer objects for API contracts

### MCP Server (`mcp_server/`)

- **MCP Implementation**: `graphiti_mcp_server.py` - Model Context Protocol server for AI assistants
- **Docker Support**: Containerized deployment with Neo4j
- **Configuration**: `.env.example` template for environment variables
- **Integration Rules**: `cursor_rules.md` for Cursor IDE integration patterns

### Examples (`examples/`)

- **Quickstart**: Basic usage patterns
- **Agent Examples**: Integration with AI agents (Langchain, CrewAI)
- **Domain Examples**: E-commerce, podcast processing

## Testing

- **Framework**: pytest with asyncio support
- **Unit Tests**: `tests/` - Comprehensive test suite
- **Integration Tests**: Tests with `_int` suffix require database connections
- **Evaluation**: `tests/evals/` - End-to-end evaluation scripts
- **Parallel Execution**: Uses pytest-xdist for faster test runs
- **Markers**: `@pytest.mark.integration` for integration tests

## Configuration

### Environment Variables

- `OPENAI_API_KEY` - Required for default LLM and embeddings
- `USE_PARALLEL_RUNTIME` - Optional boolean for Neo4j parallel runtime (enterprise only)
- Provider-specific keys: `ANTHROPIC_API_KEY`, `GOOGLE_API_KEY`, `GROQ_API_KEY`, `VOYAGE_API_KEY`
- `GRAPHITI_TELEMETRY_ENABLED=false` - Disable anonymous usage statistics

### Database Setup

- **Neo4j**: Version 5.26+ required, available via Neo4j Desktop
- **FalkorDB**: Version 1.1.2+ as alternative backend
- Indices and constraints are automatically created on first run

## Development Guidelines

### Code Style

- Use Ruff for formatting and linting (configured in pyproject.toml)
- Line length: 100 characters
- Quote style: single quotes
- Type checking with MyPy is enforced
- Always run `make lint` before committing

### Testing Requirements

- Run tests with `make test` or `pytest`
- Integration tests require database connections
- Use `pytest-xdist` for parallel test execution
- Always verify your changes don't break existing tests

### Dependency Management

- Uses `uv` package manager (modern Python package manager)
- Optional extras: `[anthropic]`, `[groq]`, `[google-genai]` for additional providers
- Install with: `uv sync --extra dev` for development dependencies

### LLM Provider Support

The codebase supports multiple LLM providers but works best with services supporting structured output (OpenAI, Gemini). Other providers may cause schema validation issues, especially with smaller models.

### MCP Server Usage Guidelines

When working with the MCP server, follow the patterns established in `mcp_server/cursor_rules.md`:

- Always search for existing knowledge before adding new information
- Use specific entity type filters (`Preference`, `Procedure`, `Requirement`)
- Store new information immediately using `add_memory`
- Follow discovered procedures and respect established preferences

### Key Architectural Patterns

- **Orchestrator Pattern**: The `Graphiti` class coordinates all operations
- **Strategy Pattern**: LLM and embedder clients share common interfaces
- **Repository Pattern**: Database drivers abstract storage backends
- **Builder Pattern**: Bulk processing utilities for efficient graph operations
- **Temporal Awareness**: All data includes event occurrence and ingestion timestamps

## MCP Server Setup Guide

### Prerequisites

1. **Python 3.10+** and **uv** package manager installed
2. **Neo4j 5.26+** database (can use Docker or Neo4j Desktop)
3. **OpenAI API key** for LLM operations

### Quick Setup

1. **Clone and setup**:
   ```bash
   git clone https://github.com/getzep/graphiti.git
   cd graphiti
   make setup  # Creates .env from template
   ```

2. **Configure `.env`**:
   ```bash
   OPENAI_API_KEY=your_key_here
   MODEL_NAME=gpt-4o-mini  # or gpt-4o
   NEO4J_PASSWORD=your_neo4j_password
   ```

3. **Run with Docker** (includes Neo4j):
   ```bash
   make run-docker
   ```
   
   Or **run locally** (requires Neo4j running separately):
   ```bash
   make run  # stdio transport for Claude Desktop
   make run-sse  # SSE transport for Cursor
   ```

### MCP Client Configuration

#### Claude Desktop (stdio transport)
```json
{
  "mcpServers": {
    "graphiti-memory": {
      "transport": "stdio",
      "command": "/path/to/.local/bin/uv",
      "args": [
        "run",
        "--isolated",
        "--directory",
        "/path/to/graphiti/mcp_server",
        "--project",
        ".",
        "graphiti_mcp_server.py",
        "--transport",
        "stdio"
      ],
      "env": {
        "NEO4J_URI": "bolt://localhost:7687",
        "NEO4J_USER": "neo4j",
        "NEO4J_PASSWORD": "password",
        "OPENAI_API_KEY": "sk-XXXXXXXX"
      }
    }
  }
}
```

#### Cursor IDE (SSE transport)
```json
{
  "mcpServers": {
    "graphiti-memory": {
      "url": "http://localhost:8000/sse"
    }
  }
}
```

### Key MCP Server Features

- **Episode Management**: Add/retrieve/delete temporal episodes
- **Entity & Fact Search**: Semantic and hybrid search capabilities
- **Group Management**: Namespace data with group IDs
- **JSON Processing**: Extract entities from structured data
- **Concurrency Control**: `SEMAPHORE_LIMIT` for rate limiting (default: 10)

### Troubleshooting

- **Rate Limits**: Lower `SEMAPHORE_LIMIT` if getting 429 errors
- **Memory Issues**: Adjust Neo4j memory settings in docker-compose.yml
- **Connection Issues**: Verify Neo4j is running and credentials are correct
- **Path Issues**: Use absolute paths in MCP client configuration

## Fork-Specific Information

### Purpose of This Fork
This is Milos's fork of the upstream Graphiti repository (https://github.com/getzep/graphiti.git). The primary modifications are:

1. **Custom Makefile commands** for easier MCP server management
2. **Configured for personal knowledge base** using Neo4j Aura Free
3. **Integration with Claude Code CLI** for persistent memory across sessions

### Syncing with Upstream
```bash
make merge-upstream  # Fetch and merge latest changes from getzep/graphiti
```

### Knowledge Base Strategy
- **What to Store**: Project architectures, coding patterns, problem solutions, preferences, workflows
- **When to Store**: Immediately after learning something new or solving a problem
- **How to Search**: Before starting tasks, check for relevant past knowledge
- **Benefits**: No more re-explaining context, cumulative learning, pattern recognition
