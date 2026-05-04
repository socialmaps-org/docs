.PHONY: build release

build:
	uv run mkdocs build
	cp -r api site/
	cp -r sdk site/

release:
	cd site/; git add -A; git commit -m "$$(date -Iseconds)";
