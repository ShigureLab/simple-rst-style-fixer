VERSION := `poetry run python -c "import sys; from docufix import __version__ as version; sys.stdout.write(version)"`

test:
  poetry run pytest --reruns 3 --reruns-delay 1
  just clean

fmt:
  poetry run isort .
  poetry run black .

fmt-docs:
  poetry run docufix '**/*.md' --fix
  poetry run docufix '**/*.rst' --fix

build:
  poetry build

publish:
  touch docufix/py.typed
  poetry publish --build
  git tag "v{{VERSION}}"
  git push --tags
  just clean-builds

clean:
  find . -name "*.pyc" -print0 | xargs -0 rm -f
  rm -rf .pytest_cache/
  rm -rf .mypy_cache/
  find . -maxdepth 3 -type d -empty -print0 | xargs -0 -r rm -r

clean-builds:
  rm -rf build/
  rm -rf dist/
  rm -rf *.egg-info/
