
# Roc Awesome 🤘

Just a collection of random links to Roc things. Help me keep this updated, PR's welcome.

If you find something that doesn't work as well as it could, please reach out and offer your assistance if you can.

**Repository** [roc-lang/roc](https://github.com/roc-lang/roc)

**Examples** [roc-lang/examples](https://github.com/roc-lang/examples)

**Tutorial** [roc-lang.org/tutorial](https://www.roc-lang.org/tutorial)

**Documentation** [roc-lang.org/docs](https://www.roc-lang.org/docs)

**Unnoficial VSCode Extension** [raqystyle/roc-vscode-unofficial](https://github.com/raqystyle/roc-vscode-unofficial)

## Future Language Changes 

### Task as Builtin

[Task as Builtin Design Proposal](https://docs.google.com/document/d/1-h9bNNCLuYV2wSvjQA58SsGHOJivH9NHGr4wU_VF5I0/edit?usp=sharing)

- Upgrages `Task` to a builtin unlocking `Task.map2`, enables concurrent task execution, improves error messages
- Introduces `Stored` ability which unlocks; performance, ergonomics, and the ability to test simulated Tasks without actually running their effects

### Module Params

[Module Params Design Proposal](https://docs.google.com/document/d/110MwQi7Dpo1Y69ECFXyyvDWzF4OYv1BLojIm08qDTvg/edit?usp=sharing)

- Enables platform-agnostic packages which can chain Tasks; all modules become platform-agnostic
- Guarantees that for a Roc module to perform effects it must declare a module parameter
- Unlocks simulating effects in tests using `expect-sim`
- Unlocks recording effects `roc run --record-fx` which can be used in tests or replay
- Enables sandboxing and polyfilling effects for improved interoperability and security

## Building From Source

[Official Guide - Building From Source](https://github.com/roc-lang/roc/blob/main/BUILDING_FROM_SOURCE.md)

1. Nix shell `nix develop`
2. Build **roc cli** `cargo build -p roc_cli --release`
3. Build **roc language server** `cargo build -p roc_lang_srv --release`

## Roc Packages
- [agu-z/roc-pg](https://github.com/agu-z/roc-pg): PostgreSQL 
- [lukewilliamboswell/roc-json](https://github.com/lukewilliamboswell/roc-json): JSON  
- [lukewilliamboswell/roc-parser](https://github.com/lukewilliamboswell/roc-parser): Parser  
- [lukewilliamboswell/roc-ansi](https://github.com/lukewilliamboswell/roc-ansi) TUI, Colors and Helpers
- [mulias/roc-array2d](https://github.com/mulias/roc-array2d) 2D Arrays
- [Hasnep/roc-math](https://github.com/Hasnep/roc-math): Math and constants
- [Hasnep/roc-html](https://github.com/Hasnep/roc-html): HTML
- [Hasnep/roc-svg](https://github.com/Hasnep/roc-svg): SVGs
- [Hasnep/roc-datetimes](https://github.com/hasnep/roc-datetimes): Dates and times 
- [JanCVanB/roc-random forked](https://github.com/lukewilliamboswell/roc-random): Random number generation

### Work In Progress
- [roc-lang/unicode](https://github.com/roc-lang/unicode): Unicode
- [Subtlesplendor/roc-parser](https://github.com/Subtlesplendor/roc-parser): Port of Elm's Parser library
- [KilianVounckx/roc_regex](https://github.com/KilianVounckx/roc_regex): Regex

## Roc Platforms
- [roc-lang/basic-webserver](https://github.com/roc-lang/basic-webserver): Webservers
- [roc-lang/basic-cli](https://github.com/roc-lang/basic-cli): CLI apps
- [bhansconnect/roc-fuzz](https://github.com/bhansconnect/roc-fuzz): Fuzzing
- [roc-lang/static-site-gen](https://github.com/roc-lang/roc/tree/main/examples/static-site-gen): Static websites

### Work In Progress
- [roc-lang/virtual-DOM](https://github.com/roc-lang/roc/tree/main/examples/virtual-dom-wip): Virtual DOM with SSR
- [vendrinc/roc-esbuild](https://github.com/vendrinc/roc-esbuild): esbuild plugin for loading `.roc` files.

### Embedding Examples
- [Zig](https://github.com/lukewilliamboswell/basic-graphics) example platform with bundle script for URL packages using Zig cross-compilation
- [Python](https://github.com/roc-lang/roc/tree/main/examples/python-interop)
- [Ruby](https://github.com/roc-lang/roc/tree/main/examples/ruby-interop)
- [Swift UI](https://github.com/roc-lang/roc/tree/main/examples/swiftui)
- [NodeJs](https://github.com/roc-lang/roc/tree/main/examples/nodejs-interop)
- [Java](https://github.com/roc-lang/roc/tree/main/examples/jvm-interop)

### Experiments
- [ostcar/roc-wasm-platform](https://github.com/ostcar/roc-wasm-platform): WASM modules
- [bhansconnect/roc-microbit](https://github.com/bhansconnect/roc-microbit): Microbit embedded processor
- [JanCVanB/roc-plotters](https://github.com/JanCVanB/roc-plotters): Drawing with Plotters
- [lukewilliamboswell/roc-tui](https://github.com/lukewilliamboswell/roc-tui): Terminal UI platform
- [lukewilliamboswell/roc-graphics-mach](https://github.com/lukewilliamboswell/roc-graphics-mach): Graphics platform using hexops/mach-core
- [lukewilliamboswell/roc-cgi-server](https://github.com/lukewilliamboswell/roc-cgi-server): CGI HTTP server using basic-cli apps 
- [lukewilliamboswell/roc-serverless](https://github.com/lukewilliamboswell/roc-serverless): HTTP handlers for WASM workers

## Roc Applications
- [isaacvando/gob](https://github.com/isaacvando/gob): Compiler for a stack based language
- [Hasnep/brainroc](https://github.com/Hasnep/brainroc): Interpreter for [BF](https://en.wikipedia.org/wiki/Brainfuck)  
- [bhansconnect/monkey-roc](https://github.com/bhansconnect/monkey-roc): Interpreter for  🐵🤘🏼 [Monkey lang](https://monkeylang.org)
- [shritesh/raytrace.roc](https://github.com/shritesh/raytrace.roc): Implementing [Ray Tracing in One Weekend](https://raytracing.github.io)
- [WhileTruu/counter-roc-swiftui-app](https://github.com/WhileTruu/counter-roc-swiftui-app): SwiftUI counter app
- [Billzabob/roc-lox](https://github.com/Billzabob/roc-lox): Interpreter for [Lox programming language](https://craftinginterpreters.com/contents.html)
- [2023 Advent of Code](https://github.com/lukewilliamboswell/roc-awesome/tree/main/aoc-2022): AoC 2023 solutions

## Tooling

### Glue Generation

Generate glue code for a platform with `roc glue path/to/spec path/to/generated/glue/destination path/to/platform/main.roc`

- [RustGlue.roc](https://github.com/roc-lang/roc/blob/main/crates/glue/src/RustGlue.roc): Bindings to Rust

### Github Actions
- [Hasnep/setup-roc](https://github.com/Hasnep/setup-roc): Install Roc
- [Hasnep/bundle-roc-library](https://github.com/Hasnep/bundle-roc-library): Bundle and release a URL package or platform
- [vendrinc/roc-npm](https://github.com/vendrinc/roc-npm/): NPM package to install roc

### ASDF Plugin
- [dkuku/asdf-roc](https://github.com/dkuku/asdf-roc): ASDF package for managing Roc versions

### Nix
- [JRMurr/roc2nix](https://github.com/JRMurr/roc2nix): Generate *things?* for Nix

