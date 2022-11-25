
# Roc Update 
*Summary of recent changes to Roc, 25 Nov 2022*

Pull requests to update welcome!

## Documentation
- Tutorial migrated to HTML now located [roc-lang.org/tutorial](https://www.roc-lang.org/tutorial), improved visuals and styling, @georgesboris working to improve UX.
- New [design assets repository](https://github.com/roc-lang/design-assets), central location for roc fonts, colors, logo etc for website.
- New [README.md](https://github.com/roc-lang/roc/tree/main/crates) for rust crates to explain Roc internals.

## Tooling
- `roc edit` design ideas moved to [/design/editor/](https://github.com/roc-lang/roc/tree/main/design/editor), includes high-level goals and requirements. All queries, concerns, ideas welcome.
- `roc build --bundle` for URL packages tracked in [PR#4562](https://github.com/roc-lang/roc/pull/4562), described in [proposal](https://docs.google.com/document/d/1SRzBuW_hn17LzCpxk-DWCHqpegI2WzuLdQpE3-qc9Lc/edit). Easy method to share platforms, package manager will expand with additional features.
- `roc glue` WIP to support Effects as simple Tag Unions with callbacks [discussion](https://roc.zulipchat.com/#narrow/stream/231634-beginners/topic/Understanding.20Effects/near/306927954).

## Language
- Eq and Hash Abilities and multiple bindings added in [PR#4290](https://github.com/roc-lang/roc/pull/4290) and [PR#4305](https://github.com/roc-lang/roc/pull/4305), simplifies Roc code.
- `crash` being tracked in [PR#4460](https://github.com/roc-lang/roc/pull/4460) with design [discussion](https://roc.zulipchat.com/#narrow/stream/304641-ideas/topic/crash/near/302000918) improves experience handling unreachable code and supports *TODO* workflows.
- `dbg` added in [PR#4578](https://github.com/roc-lang/roc/pull/4578), described in [proposal](https://docs.google.com/document/d/1VsEGIwZDWdssCQKnzxijjzpj0WpgTSsR_eeZHX0A4ug/edit) enables printline debugging for development.

## Platforms
- WIP @brian-carroll explorations with [Virtual-DOM](https://github.com/roc-lang/roc/pull/4427) to implement [Action-State in Roc](https://docs.google.com/document/d/16qY4NGVOHu8mvInVD-ddTajZYSsFvFBvQON_hmyHGfo/edit), identifing areas to improve Roc language and compiler.
- Cli API simplified in [PR#4582](https://github.com/roc-lang/roc/pull/4582) with removal of third param from Task.
- @lukewilliamboswell has made progress on [Tui](https://github.com/lukewilliamboswell/roc/tree/tui/examples/tui), intent is to explore Action-State and editor ideas.