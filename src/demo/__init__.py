import getpass


def get_username():
    """Return the current system username, or 'World' if unavailable."""
    try:
        return getpass.getuser()
    except Exception:
        return "World"


def main():
    """Print a greeting with the current username."""
    name = get_username()
    print(f"Hello {name}")
