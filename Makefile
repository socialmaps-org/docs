.PHONY: build release

build:
	uv run mkdocs build
	cp -r api site/

release:
	cd site/; git add -A; git commit -m "$$(date -Iseconds)";
