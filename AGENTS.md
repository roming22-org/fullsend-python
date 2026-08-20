# Agents

Guidelines for AI agents and contributors working on this repository.

## Project Overview

This is a demo Python application that prints "Hello World", managed with `uv`.

## Build and Run

```bash
uv sync          # Install dependencies
uv run demo      # Run the application
```

## Project Layout

- `src/demo/` - Application source code
- `docs/` - Project documentation
- `.devcontainer/` - Dev container configuration

## Conventions

- Use `uv` for all dependency and environment management.
- Follow the `src` layout for Python packages.
- Keep the application minimal: it should only print "Hello World".
