.PHONY: all

all:
	uv run mkdocs build
	cp -r api site/
