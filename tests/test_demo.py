"""Tests for the demo application."""

import subprocess
import sys
from unittest.mock import patch

from demo import get_username, main


class TestGetUsername:
    """Tests for get_username()."""

    def test_returns_system_username(self):
        """get_username returns the system username when available."""
        with patch("demo.getpass.getuser", return_value="Alice"):
            assert get_username() == "Alice"

    def test_falls_back_to_world(self):
        """get_username returns 'World' when the username is unavailable."""
        with patch("demo.getpass.getuser", side_effect=Exception("no user")):
            assert get_username() == "World"


class TestMain:
    """Tests for main()."""

    def test_greets_with_username(self, capsys):
        """main() prints 'Hello <username>' when username is available."""
        with patch("demo.getpass.getuser", return_value="Alice"):
            main()
        captured = capsys.readouterr()
        assert captured.out == "Hello Alice\n"

    def test_greets_with_world_on_failure(self, capsys):
        """main() prints 'Hello World' when username is unavailable."""
        with patch("demo.getpass.getuser", side_effect=Exception("no user")):
            main()
        captured = capsys.readouterr()
        assert captured.out == "Hello World\n"


class TestTyping:
    """Tests for type annotations."""

    def test_mypy_strict(self):
        """mypy --strict reports no errors on the demo package."""
        result = subprocess.run(
            [sys.executable, "-m", "mypy", "--strict", "src/demo/"],
            capture_output=True,
            text=True,
        )
        assert result.returncode == 0, (
            f"mypy --strict failed:\n{result.stdout}\n{result.stderr}"
        )
