.PHONY: build

build:
	rm -rf site/
	uv run mkdocs build
	cp _redirects site/
	cp -r api site/
	cp -r sdk site/
