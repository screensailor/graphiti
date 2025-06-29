# Graphiti MCP Setup Memory - Session 2025-06-29

This document captures the comprehensive setup and configuration details from Milos's Graphiti MCP server integration with Claude Code CLI.

## Setup Details

### Repository Information
- **Forked from**: https://github.com/getzep/graphiti.git
- **Fork location**: /Users/milos/git/fork/graphiti
- **Setup date**: 2025-06-29
- **Purpose**: Building a persistent knowledge graph memory system for Claude

### Infrastructure
- **Database**: Neo4j Aura Free instance (cloud-hosted)
  - URI: neo4j+s://23a8e559.databases.neo4j.io
  - User: neo4j
- **LLM Model**: GPT-4.1-mini (for both MODEL_NAME and SMALL_MODEL_NAME)
- **Integration**: MCP (Model Context Protocol) server with Claude Code CLI

## Configuration Details

### Claude Settings
- **Settings file**: ~/.claude/settings.json
- **MCP Server name**: graphiti-memory
- **Transport**: stdio
- **Command**: /opt/homebrew/bin/uv
- **Working directory**: /Users/milos/git/fork/graphiti/mcp_server

### Custom Makefile Commands
```makefile
merge-upstream:
	git fetch upstream
	git merge upstream/main
```

### Environment Variables
- MODEL_NAME: gpt-4.1-mini
- SMALL_MODEL_NAME: gpt-4.1-mini (same as MODEL_NAME for consistency)
- SEMAPHORE_LIMIT: 10

## Key Technical Discoveries

### GPT-4.1-mini Capabilities
1. **Structured Outputs**: CONFIRMED WORKING
   - Contrary to initial assumptions, GPT-4.1-mini DOES support structured outputs
   - Tested and verified during setup
   - Works seamlessly with Graphiti's entity extraction

2. **Context Window**: 1M tokens (vs 128K for GPT-4o-mini)
   - Significantly larger context for processing complex documents
   - Better for maintaining conversation context

3. **Performance**: Superior to GPT-4o-mini for this use case
   - Better entity extraction accuracy
   - More reliable relationship mapping
   - Consistent structured output generation

## Project Goals and Purpose

### Primary Objectives
1. **Replace Static CLAUDE.md Files**
   - Move from static markdown files to dynamic knowledge graph
   - Enable real-time context updates
   - Maintain project-specific knowledge persistently

2. **Build Persistent Memory System**
   - Store project architectures and patterns
   - Remember coding solutions and approaches
   - Track user preferences and workflows
   - Maintain context across sessions

3. **Improve Collaboration**
   - Reduce need to re-explain project context
   - Build upon previous learnings
   - Create a shared knowledge base

### Use Cases
- Project architecture documentation
- Coding patterns and best practices
- Solution tracking and reuse
- User preference management
- Context preservation across sessions

## Integration Status
- MCP server configuration: COMPLETE
- Claude CLI integration: COMPLETE
- Neo4j connection: VERIFIED
- GPT-4.1-mini setup: TESTED AND WORKING

## Next Steps
1. Begin populating the knowledge graph with project information
2. Test retrieval and search capabilities
3. Establish patterns for effective memory storage
4. Build up the knowledge base through regular use

---

This setup represents a significant advancement in Claude's ability to maintain persistent context and provide more intelligent, context-aware assistance across sessions.