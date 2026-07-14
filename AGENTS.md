# Agents

## Project Overview

This is a demo Python application managed with
[uv](https://docs.astral.sh/uv/). The application prints
"Hello \<username\>" to standard output, where \<username\>
is the current system login name. If the username cannot be
determined, it falls back to "Hello World".

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

### Run tests

```bash
uv run pytest
```

### Project conventions

- Use `uv` for all dependency and lifecycle management.
- Follow conventional commits for commit messages
  (e.g., `feat:`, `fix:`, `chore:`).
- Keep the application minimal; it greets the current
  system user (falling back to "Hello World").
