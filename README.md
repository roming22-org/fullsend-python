# fullsend-python

A demo Python application that greets the current user by name. If the
username cannot be determined, it falls back to "Hello World".

## Prerequisites

- Python 3.12+
- [uv](https://docs.astral.sh/uv/)

## Getting Started

### Install dependencies

```bash
uv sync
```

### Run the application

```bash
uv run fullsend-python
```

## Development

### Using the devcontainer

Open this repository in VS Code and use the "Reopen in Container" command to
start developing inside the devcontainer. The container comes with Python 3.12
and `uv` pre-installed.

### Project structure

```
src/fullsend_python/    # Application source code
docs/                   # Documentation
prompts/                # Vibe coding prompts
```
