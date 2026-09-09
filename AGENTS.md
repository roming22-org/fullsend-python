# Agents

## Project Overview

This is a Python application managed with `uv`. The application prints
"Hello World" to standard output.

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
- Always commit `uv.lock` — this is an application (not a library), so the lock file must be tracked for reproducible dependency resolution. Never add `uv.lock` to `.gitignore`.
- Document requirements in the `docs/` folder.
