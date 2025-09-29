# Social Maps Documentation

Visit <https://docs.socialmaps.org/> for the documentation itself. This README is for contributors.

We use [MkDocs](https://www.mkdocs.org/) and [Material for MkDocs](https://squidfunk.github.io/mkdocs-material/) to generate a static site for our documentation, and [uv](https://docs.astral.sh/uv/) as our Python package manager. Our API Reference uses a different software called [Scalar](https://scalar.com/), which is a JavaScript application that renders our API Reference client-side based on our OpenAPI spec. The entire documentation is generated statically, which we then host on [Codeberg Pages](https://codeberg.page/).

## Contributing
When you clone the repo for the first time, run

```console
$ git worktree add site/ pages
```

to checkout the `pages` branch inside the `site/` directory.
