from unittest.mock import patch

from fullsend_python.main import get_greeting_name, main


def test_get_greeting_name_returns_username():
    with patch("fullsend_python.main.getpass.getuser", return_value="Alice"):
        assert get_greeting_name() == "Alice"


def test_get_greeting_name_falls_back_to_world():
    with patch("fullsend_python.main.getpass.getuser", side_effect=Exception):
        assert get_greeting_name() == "World"


def test_main_greets_current_user(capsys):
    with patch("fullsend_python.main.getpass.getuser", return_value="Alice"):
        main()
    assert capsys.readouterr().out.strip() == "Hello Alice"


def test_main_falls_back_to_world(capsys):
    with patch("fullsend_python.main.getpass.getuser", side_effect=Exception):
        main()
    assert capsys.readouterr().out.strip() == "Hello World"
