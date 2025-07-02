.PHONY: install format lint test all check

# Define variables
PYTHON = python3
UV = uv
PYTEST = $(UV) run pytest
RUFF = $(UV) run ruff
PYRIGHT = $(UV) run pyright

# Default target
all: format lint test

# Install dependencies
install:
	$(UV) sync --extra dev

# Format code
format:
	$(RUFF) check --select I --fix
	$(RUFF) format

# Lint code
lint:
	$(RUFF) check
	$(PYRIGHT) ./graphiti_core 

# Run tests
test:
	$(PYTEST)

# Run format, lint, and test
check: format lint test

# User commands

sync:
    uv sync

setup:
    cp .env.example .env
    @echo "Remember to edit .env with your API keys!"

run:
    uv run graphiti_mcp_server.py

run-sse:
    uv run graphiti_mcp_server.py --transport sse

run-docker:
    docker compose up

clean:
    docker compose down
    rm -rf __pycache__

merge-upstream:
    git fetch upstream
    git merge upstream/main

