
# Roc Awesome

A collection of links to awesome roc things.

> **The Roc compiler is being rewritten from Rust to Zig.** This list now tracks
> projects that work with the **new Zig-based compiler**. Projects that haven't been
> migrated yet have moved to **[LEGACY_ROC.md](LEGACY_ROC.md)** — that file doubles as
> a checklist of what still needs porting. Migrating a package or platform is a great
> way to help out!
>
> New here? Richard Feldman's writeup [**on the Rust → Zig compiler rewrite**](https://gist.github.com/rtfeldman/77fb430ee57b42f5f2ca973a3992532f) explains why it's happening and what it changes.

- **Repository** [roc-lang/roc](https://github.com/roc-lang/roc)
- **Download Roc** [roc-lang/nightlies releases](https://github.com/roc-lang/nightlies/releases) — prebuilt nightly builds of the latest compiler
- **Building From Source** [official guide](https://github.com/roc-lang/roc/blob/main/BUILDING_FROM_SOURCE.md)
- **Tutorial** [docs/mini-tutorial-new-compiler.md](https://github.com/roc-lang/roc/blob/main/docs/mini-tutorial-new-compiler.md) — interim "mini" tutorial for the new compiler (a full rewrite is planned)
- **Language Reference** [docs/langref](https://github.com/roc-lang/roc/tree/main/docs/langref) — new-compiler reference (not yet complete or on the website, but very helpful)
- **Syntax Reference** [test/echo/all_syntax_test.roc](https://github.com/roc-lang/roc/blob/main/test/echo/all_syntax_test.roc) — a single file demonstrating the new syntax
- **Exercism Track** [exercism.org/tracks/roc](https://exercism.org/tracks/roc) — migration in progress ([PR #198](https://github.com/exercism/roc/pull/198) — 92+ exercises ported & passing)
- **Dockerhub** [hub.docker.com/repositories/roclang](https://hub.docker.com/repositories/roclang)

> The [roc-lang.org](https://www.roc-lang.org) website (Examples, Tutorial, Docs) still
> documents the **old** compiler and is yet to be updated — for now use the new-compiler
> mini-tutorial and syntax reference above.

## Roc Packages
- [roc-lang/http](https://github.com/roc-lang/http): HTTP client
- [roc-lang/path](https://github.com/roc-lang/path): OS filesystem path manipulation
- [roc-lang/unicode](https://github.com/roc-lang/unicode): Unicode text processing (grapheme clusters, code points)
- [lukewilliamboswell/roc-ansi](https://github.com/lukewilliamboswell/roc-ansi): ANSI escape codes for color, styling & cursor control
- [lukewilliamboswell/roc-parser](https://github.com/lukewilliamboswell/roc-parser): Parser Combinators
- [kili-ilo/roc-random](https://github.com/kili-ilo/roc-random): Random number generation
- [niclas-ahden/roc-crc32](https://github.com/niclas-ahden/roc-crc32): CRC32 checksum calculation

## Roc Platforms

- [roc-lang/basic-cli](https://github.com/roc-lang/basic-cli): CLI apps ([WIP PR #413](https://github.com/roc-lang/basic-cli/pull/413))
- [roc-lang/basic-webserver](https://github.com/roc-lang/basic-webserver): Webservers ([WIP PR #163](https://github.com/roc-lang/basic-webserver/pull/163))
- [lukewilliamboswell/basic-ssg](https://github.com/lukewilliamboswell/basic-ssg): Static Site Generation ([WIP PR #16](https://github.com/lukewilliamboswell/basic-ssg/pull/16))
- [lukewilliamboswell/roc-wasm4](https://github.com/lukewilliamboswell/roc-wasm4): WASM-4 Games
- [lukewilliamboswell/roc-ray](https://github.com/lukewilliamboswell/roc-ray): Graphics and GUI using Raylib
- [lukewilliamboswell/roc-platform-template-zig](https://github.com/lukewilliamboswell/roc-platform-template-zig): Zig platform template
- [lukewilliamboswell/roc-platform-template-rust](https://github.com/lukewilliamboswell/roc-platform-template-rust): Rust platform template

## Tools
- [faldor20/tree-sitter-roc](https://github.com/faldor20/tree-sitter-roc): Tree-sitter grammar (updated for the new syntax) — also powers Helix & Neovim
- [h2000/zed-roc](https://github.com/h2000/zed-roc): Zed editor support, using the new grammar & LSP
- [roc-lang/setup-roc](https://github.com/roc-lang/setup-roc): GitHub Action to install Roc — supports new-compiler nightlies (`version: nightly-new-compiler`)

---

Looking for the older ecosystem (everything not yet migrated to the new compiler)?
See **[LEGACY_ROC.md](LEGACY_ROC.md)**.
