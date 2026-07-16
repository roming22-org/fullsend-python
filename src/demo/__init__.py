import getpass


def get_username() -> str:
    """Return the current system username, or 'World' if unavailable."""
    try:
        return getpass.getuser()
    except Exception:
        return "World"


def main() -> None:
    """Print a greeting with the current username."""
    name: str = get_username()
    print(f"Hello {name}")
