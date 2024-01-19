
# Roc Awesome 🤘

A collection of links to awesome roc things. 

- **Repository** [roc-lang/roc](https://github.com/roc-lang/roc)
- **Examples** [roc-lang/examples](https://github.com/roc-lang/examples)
- **Tutorial** [roc-lang.org/tutorial](https://www.roc-lang.org/tutorial)
- **Documentation** [roc-lang.org/docs](https://www.roc-lang.org/docs)
- **Unnoficial VSCode Extension** [raqystyle/roc-vscode-unofficial](https://github.com/raqystyle/roc-vscode-unofficial)
- **Unnocifial Tree-Sitter Grammar** [faldor20/tree-sitter-roc](https://github.com/faldor20/tree-sitter-roc)

## Building From Source 🏗️

[Official Guide - Building From Source](https://github.com/roc-lang/roc/blob/main/BUILDING_FROM_SOURCE.md)

Enter nix shell `nix develop`

Build **roc cli && language server** `cargo build -p roc_cli --release && cargo build -p roc_lang_srv --release`

## Roc Packages 📦
- [agu-z/roc-pg](https://github.com/agu-z/roc-pg): PostgreSQL 
- [Hasnep/roc-math](https://github.com/Hasnep/roc-math): Math and constants
- [Hasnep/roc-html](https://github.com/Hasnep/roc-html): HTML
- [Hasnep/roc-svg](https://github.com/Hasnep/roc-svg): SVGs
- [Hasnep/roc-datetimes](https://github.com/hasnep/roc-datetimes): Dates and times 
- [JanCVanB/roc-random forked](https://github.com/lukewilliamboswell/roc-random): Random number generation
- [lukewilliamboswell/roc-json](https://github.com/lukewilliamboswell/roc-json): JSON  
- [lukewilliamboswell/roc-parser](https://github.com/lukewilliamboswell/roc-parser): Parser  
- [lukewilliamboswell/roc-ansi](https://github.com/lukewilliamboswell/roc-ansi) TUI, Colors and Helpers
- [mulias/roc-array2d](https://github.com/mulias/roc-array2d) 2D Arrays
- [Subtlesplendor/roc-data](https://github.com/Subtlesplendor/roc-data): Useful types like Stack, Queue, Bag

*Work In Progress*
- 🚧 [roc-lang/unicode](https://github.com/roc-lang/unicode): Unicode
- 🚧 [Subtlesplendor/roc-parser](https://github.com/Subtlesplendor/roc-parser): Port of Elm's Parser library
- 🚧 [KilianVounckx/roc_regex](https://github.com/KilianVounckx/roc_regex): Regex

## Roc Platforms 🏢
- [roc-lang/basic-webserver](https://github.com/roc-lang/basic-webserver): Webservers
- [roc-lang/basic-cli](https://github.com/roc-lang/basic-cli): CLI apps
- [lukewilliamboswell/roc-wasm4](https://github.com/lukewilliamboswell/roc-wasm4): WASM-4 Games 🕹️
- [bhansconnect/roc-fuzz](https://github.com/bhansconnect/roc-fuzz): Fuzzing
- [roc-lang/static-site-gen](https://github.com/roc-lang/roc/tree/main/examples/static-site-gen): Static websites

*Work In Progress*
- 🚧 [lukewilliamboswell/roc-gui](https://github.com/lukewilliamboswell/roc-gui): GUI apps
- 🚧 [roc-lang/virtual-DOM](https://github.com/roc-lang/roc/tree/main/examples/virtual-dom-wip): Virtual DOM with SSR
- 🚧 [ostcar/roc-wasi-platform](https://github.com/ostcar/roc-wasi-platform): WASI
- 🚧 [vendrinc/roc-esbuild](https://github.com/vendrinc/roc-esbuild): esbuild plugin for loading `.roc` files.

*Other languages & Embedding Examples* 🗺
- 🚧 [alexpyattaev/roc-plugin-example](https://github.com/alexpyattaev/roc-plugin-example/tree/master): [Rust] A plugin example for a bevy game
- [lukewilliamboswell/roc-zig-platform](https://github.com/lukewilliamboswell/roc-zig-platform): [Zig] Example platform with bundle script for URL packages using Zig cross-compilation
- [Python](https://github.com/roc-lang/roc/tree/main/examples/python-interop)
- [Ruby](https://github.com/roc-lang/roc/tree/main/examples/ruby-interop)
- [Swift UI](https://github.com/roc-lang/roc/tree/main/examples/swiftui)
- [NodeJs](https://github.com/roc-lang/roc/tree/main/examples/nodejs-interop)
- [Java](https://github.com/roc-lang/roc/tree/main/examples/jvm-interop)

**Glue Generation** for a platform with `roc glue path/to/spec path/to/generated/glue/destination path/to/platform/main.roc`
[RustGlue.roc](https://github.com/roc-lang/roc/blob/main/crates/glue/src/RustGlue.roc): Bindings to Rust

## Tooling 🛠️

- [Hasnep/setup-roc](https://github.com/Hasnep/setup-roc): Github action to tnstall Roc
- [Hasnep/bundle-roc-library](https://github.com/Hasnep/bundle-roc-library): Github action to bundle packages
- [vendrinc/roc-npm](https://github.com/vendrinc/roc-npm/): NPM package to install roc
- [dkuku/asdf-roc](https://github.com/dkuku/asdf-roc): ASDF package for managing Roc versions
- [JRMurr/roc2nix](https://github.com/JRMurr/roc2nix): Nix library for building Apps & Platforms
- [roc-lang docker](https://github.com/roc-lang/roc/tree/main/docker): Dockerfiles for roc 

## Experiments 🔭
- [ostcar/roc-wasm-platform](https://github.com/ostcar/roc-wasm-platform): WASM modules
- [bhansconnect/roc-microbit](https://github.com/bhansconnect/roc-microbit): Microbit embedded processor
- [JanCVanB/roc-plotters](https://github.com/JanCVanB/roc-plotters): Drawing with Plotters
- [lukewilliamboswell/roc-tui](https://github.com/lukewilliamboswell/roc-tui): Terminal UI platform
- [lukewilliamboswell/roc-graphics-mach](https://github.com/lukewilliamboswell/roc-graphics-mach): Graphics platform using hexops/mach-core
- [lukewilliamboswell/roc-cgi-server](https://github.com/lukewilliamboswell/roc-cgi-server): CGI HTTP server using basic-cli apps 
- [lukewilliamboswell/roc-serverless](https://github.com/lukewilliamboswell/roc-serverless): HTTP handlers for WASM workers

## Language Changes 🧱 

[Task as Builtin Design Proposal](https://docs.google.com/document/d/1-h9bNNCLuYV2wSvjQA58SsGHOJivH9NHGr4wU_VF5I0/edit?usp=sharing)

- Upgrades `Task` to a builtin unlocking `Task.map2`, enables concurrent task execution, improves error messages
- ~~Introduces `Stored` ability which unlocks; performance, ergonomics, and the ability to test simulated Tasks without actually running their effects~~

[Module Params Design Proposal](https://docs.google.com/document/d/110MwQi7Dpo1Y69ECFXyyvDWzF4OYv1BLojIm08qDTvg/edit?usp=sharing)

- Enables platform-agnostic packages which can chain Tasks; all modules become platform-agnostic
- Guarantees that for a Roc module to perform effects it must declare a module parameter
- Unlocks simulating effects in tests using `expect-sim`
- Unlocks recording effects `roc run --record-fx` which can be used in tests or replay
- Enables sandboxing and polyfilling effects for improved interoperability and security

## Roc Applications 💾
- [isaacvando/gob](https://github.com/isaacvando/gob): Compiler for a stack-based language
- [Hasnep/brainroc](https://github.com/Hasnep/brainroc): Interpreter for [BF](https://en.wikipedia.org/wiki/Brainfuck)  
- [bhansconnect/monkey-roc](https://github.com/bhansconnect/monkey-roc): Interpreter for  🐵🤘🏼 [Monkey lang](https://monkeylang.org)
- [shritesh/raytrace.roc](https://github.com/shritesh/raytrace.roc): Implementing [Ray Tracing in One Weekend](https://raytracing.github.io)
- [WhileTruu/counter-roc-swiftui-app](https://github.com/WhileTruu/counter-roc-swiftui-app): SwiftUI counter app
- [Billzabob/roc-lox](https://github.com/Billzabob/roc-lox): Interpreter for [Lox programming language](https://craftinginterpreters.com/contents.html)
- [lukewilliamboswell/aoc](https://github.com/lukewilliamboswell/aoc): My AoC Solutions

## Other

🎄🎁🎄 [Advent of Code template](https://github.com/lukewilliamboswell/aoc-template)