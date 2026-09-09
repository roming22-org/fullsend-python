# Agents

## Project Overview

This is a Python application managed with `uv`. The application greets
the current user by name (e.g., "Hello Alice"). If the username cannot
be determined, it falls back to "Hello World".

## Build and Run

- Install dependencies: `uv sync`
- Run the application: `uv run fullsend-python`

## Project Structure

- `src/fullsend_python/` - Application source code
- `src/fullsend_python/main.py` - Entry point with `main()` function
- `docs/` - Project documentation
- `prompts/` - Vibe coding prompts for iterative development
- `.devcontainer/` - Development container configuration

## Conventions

- Use `uv` for all dependency and lifecycle management.
- Source code lives under `src/fullsend_python/`.
- Keep the application entry point in `src/fullsend_python/main.py`.
- Document requirements in the `docs/` folder.
- All functions must have return type annotations (use `-> None` for functions that return nothing).
- Test functions follow the pattern `test_<function_name>_<behavior>` (e.g., `test_get_greeting_name_returns_username`).
- Run tests with `uv run pytest tests/ -v`.
