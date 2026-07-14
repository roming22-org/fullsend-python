# Application Requirements

## Overview

The demo application is a minimal Python application managed with
[uv](https://docs.astral.sh/uv/).

## Functional Requirements

1. The application prints "Hello <username>" to standard output (where
   <username> is the current system login name), falling back to
   "Hello World" if the username cannot be determined, and exits.

## Technical Requirements

1. Python >= 3.12 is required.
2. The project uses `uv` for dependency management and lifecycle
   operations (`uv sync`, `uv run`).
3. The application is runnable via:
   - `uv run demo` (using the project script entry point)
   - `uv run python -m demo` (using the package `__main__.py`)
4. A devcontainer configuration is provided for containerized
   development with Python and uv pre-installed.
