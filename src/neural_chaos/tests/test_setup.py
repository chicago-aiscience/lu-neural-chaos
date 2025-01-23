"""Setup tests"""

import pytest

from neural_chaos import main


def test_true() -> None:
    assert True


@pytest.mark.skip
def test_false() -> None:
    assert False


def test_main() -> None:
    assert main() == 0
