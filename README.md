
# Roc Awesome 🤘

Just a collection of random links to Roc things. 

Note some of these may not work with the current version of Roc given the rapid pace of Roc's development. If you find something that doesn't work, suggest you reach out to the originator and offer your assistance, they may accept a PR.

- [roc-lang/roc](https://github.com/roc-lang/roc) repository for Roc
- [roc-lang/examples](https://github.com/roc-lang/examples) examples for Roc
- [roc-lang.org/tutorial](https://www.roc-lang.org/tutorial) tutorial for Roc
- [roc-lang.org/builtins](https://www.roc-lang.org/builtins) docs for Roc's standard library

- [raqystyle/roc-vscode-unofficial](https://github.com/raqystyle/roc-vscode-unofficial): Unnoficial VSCode extension for Roc language

## Packages
- [lukewilliamboswell/roc-ansi-escapes](https://github.com/lukewilliamboswell/roc-ansi-escapes) Helpers to use ANSI Escape Sequences for pretty printing in the terminal
- [lukewilliamboswell/roc-parser](https://github.com/lukewilliamboswell/roc-parser): A package for parsing   
- [Hasnep/roc-math](https://github.com/Hasnep/roc-math): Mathematical functions and constants in Roc
- [Hasnep/roc-html](https://github.com/Hasnep/roc-html): A library to create HTML in Roc
- [Hasnep/roc-svg](https://github.com/Hasnep/roc-svg): A library to create SVGs in Roc
- [agu-z/roc-pg](https://github.com/agu-z/roc-pg): A PostgreSQL package for Roc
- [lukewilliamboswell/roc-json](https://github.com/lukewilliamboswell/roc-json): A JSON package for Roc 
- [roc-lang/unicode](https://github.com/roc-lang/unicode): A Unicode package to Roc
- [hasnep/roc-datetimes](https://github.com/hasnep/roc-datetimes): A package for working with Dates and Times in Roc, based on the Rust Chrono library
- [KilianVounckx/roc_regex](https://github.com/KilianVounckx/roc_regex): A toy regex implementation in Roc
- [JanCVanB/roc-random](https://github.com/lukewilliamboswell/roc-random): A Roc package for random number generation
- [Parser](https://github.com/roc-lang/roc/tree/main/examples/parser/package): A Parser package, includes some combinators and basic support for CSV, Http, and Strings
- [Subtlesplendor/roc-parser](https://github.com/Subtlesplendor/roc-parser): WIP port of Elm's Parser library to Roc, empowered by Roc's type system.

*Work In Progress*
- [roc-lang/unicode](https://github.com/roc-lang/unicode): Collection of Unicode operations like working with Graphemes

## Platforms
- [roc-lang/basic-webserver](https://github.com/roc-lang/basic-webserver): A basic webserver for Roc
- [roc-lang/basic-cli](https://github.com/roc-lang/basic-cli): A platform for making CLI apps. This is the most mature platform and is actively maintained by the core team.
- [bhansconnect/roc-fuzz](https://github.com/bhansconnect/roc-fuzz): Fuzzing platform for Roc
- [Static Site Gen](https://github.com/roc-lang/roc/tree/main/examples/static-site-gen): A platform for generating static websites, used to generate Roc Tutorial, and Examples sites, includes syntax highlighting for Roc code
- [WIP Virtual DOM](https://github.com/roc-lang/roc/tree/main/examples/virtual-dom-wip): Aim is to develop an example of a virtual DOM platform in Roc, with server-side rendering. Not working yet though.

- [vendrinc/roc-esbuild](https://github.com/vendrinc/roc-esbuild) This is a work-in-progress esbuild plugin for loading .roc files.

- [lukewilliamboswell/basic-graphics](https://github.com/lukewilliamboswell/basic-graphics) A simple platform for creating 2D images using Roc

*Embedding Examples*
- [Python](https://github.com/roc-lang/roc/tree/main/examples/python-interop)
- [Ruby](https://github.com/roc-lang/roc/tree/main/examples/ruby-interop)
- [Swift UI](https://github.com/roc-lang/roc/tree/main/examples/swiftui)
- [NodeJs](https://github.com/roc-lang/roc/tree/main/examples/nodejs-interop)
- [Java](https://github.com/roc-lang/roc/tree/main/examples/jvm-interop)

*Other Experiments*
- [lukewilliamboswell/roc-graphics-mach](https://github.com/lukewilliamboswell/roc-graphics-mach): An experiment to build a minimal graphics platform for Roc using hexops/mach-core.
- [ostcar/roc-wasm-platform](https://github.com/ostcar/roc-wasm-platform): WIP platform to build wasm modules
- [bhansconnect/roc-microbit](https://github.com/bhansconnect/roc-microbit): A roc platform for running on the microbit embedded processor
- [JanCVanB/roc-plotters](https://github.com/JanCVanB/roc-plotters): Roc platform for drawing with Plotters
- [lukewilliamboswell/roc-tui](https://github.com/lukewilliamboswell/roc-tui): WIP terminal UI platform for Roc built on tui-rs.
- [lukewilliamboswell/roc-cgi-server](https://github.com/lukewilliamboswell/roc-cgi-server) An experiment to use Roc cli apps as a CGI HTTP server

## Apps
- [Hasnep/brainroc](https://github.com/Hasnep/brainroc): A BF interpreter written in Roc.
- [bhansconnect/monkey-roc](https://github.com/bhansconnect/monkey-roc): 🐵🤘🏼 is an implementation of the Monkey interpreter from Writing An Interpreter In Go written in Roc.
- [shritesh/raytrace.roc](https://github.com/shritesh/raytrace.roc): Ray Tracing in One Weekend in Roc
- [WhileTruu/counter-roc-swiftui-app](https://github.com/WhileTruu/counter-roc-swiftui-app): A simple Roc counter app on a Swift platform, rendered with SwiftUI
- [Billzabob/roc-lox](https://github.com/Billzabob/roc-lox): Implementing the Lox programming language from Crafting Interpreters using Roc

## Tools & Others
- [RustGlue Spec](https://github.com/roc-lang/roc/blob/main/crates/glue/src/RustGlue.roc): Generate bindings to Rust for Roc types. Use with `roc glue path/to/spec path/to/generated/glue/destination path/to/platform/main.roc`
- [Hasnep/setup-roc](https://github.com/Hasnep/setup-roc): A GitHub Action to install Roc
- [Hasnep/bundle-roc-library](https://github.com/Hasnep/bundle-roc-library): A GitHub Action to bundle and release a Roc library
- [vendrinc/roc-npm](https://github.com/vendrinc/roc-npm/): NPM package to install the roc CLI and makes it available via npx roc-lang




