
# Roc Awesome 🤘

Just a collection of random links to Roc things. Help me keep this updated, PR's welcome.

If you find something that doesn't work as well as it could, please reach out and offer your assistance if you can.

**Repository** [roc-lang/roc](https://github.com/roc-lang/roc) repository for Roc
**Examples** [roc-lang/examples](https://github.com/roc-lang/examples) examples for Roc
**Tutorial** [roc-lang.org/tutorial](https://www.roc-lang.org/tutorial) tutorial for Roc
**Documentation** [roc-lang.org/docs](https://www.roc-lang.org/docs) links to docs for Roc

**Unnoficial VSCode Extension** [raqystyle/roc-vscode-unofficial](https://github.com/raqystyle/roc-vscode-unofficial) VSCode extension for Roc language

## Building From Source

[Official Guide - Building From Source](https://github.com/roc-lang/roc/blob/main/BUILDING_FROM_SOURCE.md)

1. Nix shell `nix develop`
2. Build **roc cli** `cargo build -p roc_cli --release`
3. Build **language server** `cargo build -p roc_lang_srv --release`

## Roc Packages
- [agu-z/roc-pg](https://github.com/agu-z/roc-pg): PostgreSQL package
- [lukewilliamboswell/roc-json](https://github.com/lukewilliamboswell/roc-json): JSON package 
- [lukewilliamboswell/roc-parser](https://github.com/lukewilliamboswell/roc-parser): parser pacakge  
- [lukewilliamboswell/roc-ansi-escapes](https://github.com/lukewilliamboswell/roc-ansi-escapes) terminal pretty printing
- [Hasnep/roc-math](https://github.com/Hasnep/roc-math): maths and constants
- [Hasnep/roc-html](https://github.com/Hasnep/roc-html): create HTML
- [Hasnep/roc-svg](https://github.com/Hasnep/roc-svg): create SVGs
- [hasnep/roc-datetimes](https://github.com/hasnep/roc-datetimes): work with dates and times 
- [JanCVanB/roc-random forked](https://github.com/lukewilliamboswell/roc-random): random number generation

### Work In Progress
- [roc-lang/unicode](https://github.com/roc-lang/unicode): Unicode package
- [Subtlesplendor/roc-parser](https://github.com/Subtlesplendor/roc-parser): port of Elm's Parser library
- [KilianVounckx/roc_regex](https://github.com/KilianVounckx/roc_regex): regex implementation

## Roc Platforms
- [roc-lang/basic-webserver](https://github.com/roc-lang/basic-webserver): make webservers
- [roc-lang/basic-cli](https://github.com/roc-lang/basic-cli): make CLI apps
- [bhansconnect/roc-fuzz](https://github.com/bhansconnect/roc-fuzz): fuzzing platform
- [Static Site Gen](https://github.com/roc-lang/roc/tree/main/examples/static-site-gen): generate static websites

### Work In Progress
- [WIP Virtual DOM](https://github.com/roc-lang/roc/tree/main/examples/virtual-dom-wip): Aim is to develop an example of a virtual DOM platform in Roc, with server-side rendering. Not working yet though.
- [vendrinc/roc-esbuild](https://github.com/vendrinc/roc-esbuild) This is a work-in-progress esbuild plugin for loading .roc files.

### Embedding Examples
- [Zig](https://github.com/lukewilliamboswell/basic-graphics) example platform including bundle script to make URL package for multiple arhitectures using Zig cross-compilation
- [Python](https://github.com/roc-lang/roc/tree/main/examples/python-interop)
- [Ruby](https://github.com/roc-lang/roc/tree/main/examples/ruby-interop)
- [Swift UI](https://github.com/roc-lang/roc/tree/main/examples/swiftui)
- [NodeJs](https://github.com/roc-lang/roc/tree/main/examples/nodejs-interop)
- [Java](https://github.com/roc-lang/roc/tree/main/examples/jvm-interop)

### Experiments
- [lukewilliamboswell/roc-graphics-mach](https://github.com/lukewilliamboswell/roc-graphics-mach): a graphics platform using hexops/mach-core
- [ostcar/roc-wasm-platform](https://github.com/ostcar/roc-wasm-platform): build wasm modules
- [bhansconnect/roc-microbit](https://github.com/bhansconnect/roc-microbit): microbit embedded processor
- [JanCVanB/roc-plotters](https://github.com/JanCVanB/roc-plotters): drawing with Plotters
- [lukewilliamboswell/roc-tui](https://github.com/lukewilliamboswell/roc-tui): terminal UI platform
- [lukewilliamboswell/roc-cgi-server](https://github.com/lukewilliamboswell/roc-cgi-server) use basic-cli apps as a CGI HTTP server
- [lukewilliamboswell/roc-serverless](https://github.com/lukewilliamboswell/roc-serverless) write HTTP handlers for Cloudfare WASM workers

## Roc Applications
- [isaacvando/gob](https://github.com/isaacvando/gob): compiler for a stack based language
- [Hasnep/brainroc](https://github.com/Hasnep/brainroc): an interpreter for [BF](https://en.wikipedia.org/wiki/Brainfuck)  
- [bhansconnect/monkey-roc](https://github.com/bhansconnect/monkey-roc): 🐵🤘🏼 interpreter for [Monkey lang](https://monkeylang.org)
- [shritesh/raytrace.roc](https://github.com/shritesh/raytrace.roc): implementing [Ray Tracing in One Weekend](https://raytracing.github.io)
- [WhileTruu/counter-roc-swiftui-app](https://github.com/WhileTruu/counter-roc-swiftui-app): SwiftUI counter app
- [Billzabob/roc-lox](https://github.com/Billzabob/roc-lox): interpretor for [Lox programming language](https://craftinginterpreters.com/contents.html)
- [2023 Advent of Code](https://github.com/lukewilliamboswell/roc-awesome/tree/main/aoc-2022): AoC 2023 solutions

## Tooling

### Glue Generation

Generate glue code for a platform with `roc glue path/to/spec path/to/generated/glue/destination path/to/platform/main.roc`

- [RustGlue.roc](https://github.com/roc-lang/roc/blob/main/crates/glue/src/RustGlue.roc) enerate bindings to Rust for Roc types.

### Github Actions
- [Hasnep/setup-roc](https://github.com/Hasnep/setup-roc): installs Roc
- [Hasnep/bundle-roc-library](https://github.com/Hasnep/bundle-roc-library): bundle and release a URL package or platform
- [vendrinc/roc-npm](https://github.com/vendrinc/roc-npm/): NPM package to install roc

### ASDF Plugin
- [dkuku/asdf-roc](https://github.com/dkuku/asdf-roc): ASDF package for managing Roc versions

### Nix
- [JRMurr/roc2nix](https://github.com/JRMurr/roc2nix): WIP to generate things for Nix

