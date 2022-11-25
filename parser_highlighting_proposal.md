
# Syntax Highlighting using the Roc Parser
*Thanks to @Joshua Warner for this idea*

**Goal.** Propose an approach that evolves Roc's parser to support syntax highlighting for HTML documentation.

**Background.** I have been doing some research into developing a grammar of Roc in [tree-sitter](https://tree-sitter.github.io/tree-sitter/) for the use-case of documentation syntax highlighting. A TS grammar also would provide additional benefits, such as folding and support in most text-editors. However, the more I research the more I started to question if this was an achievable project to work on. The features TS would enable are desirable in the short-term, however, I think Roc's projectional editor will be better suited in the medium-long term.

Roc's indentation rules are *very* subtle. It will be hard to build and maintain a tree-sitter parser that works correctly. Keywords are particularly challenging as they are context-sensitive with many subtle cases to handle.

**Proposed Solution.** Emit relevant syntax information as a side stream in the parser. This supports a syntax highlighting use case, and is easy to make optional which eliminates any effect on the production compiler.
 
@Joshua Warner has recently embarked on [a campaign](https://github.com/roc-lang/roc/pull/4470) to convert the parser to use combinators. His goal is to have *one* parser (to rule them all) which can be used in multiple contexts with different behaviour as required. The `Parser` trait currently has a single [parse()](https://github.com/roc-lang/roc/blob/main/crates/compiler/parse/src/parser.rs#L771) method. When everything is combinator-based; it will be possible to have a second `parse_for_highlight()` method which returns alternate date. In this case, it returns a list of syntax relevant locations in the buffer, i.e. `Vec<Loc<SyntaxElement>>`.

To do this once the parser is fully converted to combinators; we only need to implement logic in the combinators. We can capture the `Loc` information for relevant syntax such as; keywords, builtins, constants, literals, strings, comments, operators, and other characters `(`,`:` etc. Then when we serialise the text buffer, we can insert `<span>` and `</span>` wherever needed.

Note that there is a signifcant amount of up front work before we see any externally-visible progress, however, if I think this is a worthwhile objective to work towards.