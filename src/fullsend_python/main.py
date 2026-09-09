import getpass


def get_greeting_name() -> str:
    """Return the current username, or 'World' if it cannot be determined."""
    try:
        return getpass.getuser()
    except Exception:
        return "World"


def main() -> None:
    print(f"Hello {get_greeting_name()}")


if __name__ == "__main__":
    main()
