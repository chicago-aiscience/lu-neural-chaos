
PYTHON = python3

.PHONY: install
install:
	uv export --no-emit-workspace --no-dev --no-hashes --output-file requirements.txt
	uv export --no-emit-workspace --dev --no-hashes --output-file requirements-dev.txt
	pre-commit autoupdate
	pre-commit install

.PHONY: run
run:
	uv run python -m neural_chaos

.PHONY: lint
lint:
	uv run --dev ruff format
	uv run --dev ruff check --fix
	uv run --no-dev pyright
	pre-commit run

.PHONY: check
check:
	uv run --dev pytest --cov-config=.coveragerc --cov-branch --cov=src/neural_chaos/ src/neural_chaos/tests/

.PHONY: bench
bench:
	uv run --dev pytest src/neural_chaos/benches/ --codspeed

.PHONY: clean
clean:
	find . -type d -name '__pycache__' -exec rm -rf {} +
	rm -f coverage.xml
	rm -f .coverage

.PHONY: distclean
distclean: clean
	rm -rf .ruff_cache/
	rm -rf .venv/
	rm -rf .pytest_cache/
	rm -rf .codspeed/

.PHONY: bootstrap
bootstrap:
	rm -rf .venv/
	$(PYTHON) -m venv .venv
	.venv/bin/python -m pip install pipx
	.venv/bin/pipx install uv
	.venv/bin/pipx install pre-commit
