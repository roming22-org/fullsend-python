# Agents

## Project Overview

This is a demo Python application managed with
[uv](https://docs.astral.sh/uv/). The application prints
"Hello World" to standard output.

## Repository Structure

- `src/demo/` - Application source code
- `docs/` - Project documentation
- `.devcontainer/` - Dev container configuration

## Development

### Setup

```bash
uv sync
```

### Run the application

```bash
uv run demo
```

### Project conventions

- Use `uv` for all dependency and lifecycle management.
- Follow conventional commits for commit messages
  (e.g., `feat:`, `fix:`, `chore:`).
- Keep the application minimal; it should only print
  "Hello World".
