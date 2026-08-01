.PHONY: build release

build:
	uv run mkdocs build
	cp _redirects site/
	cp -r api site/
	cp -r sdk site/
