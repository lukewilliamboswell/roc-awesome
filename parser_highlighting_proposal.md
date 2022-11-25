
# Syntax Highlighting using the Roc Parser
*Thanks to @Joshua Warner for these ideas*

**Goal.** Propose an approach that evolves Roc's parser to support syntax highlighting for HTML documentation.

**Background.** I have been doing some research into developing a grammar of Roc in [tree-sitter](https://tree-sitter.github.io/tree-sitter/) for the use-case of syntax highlighting. This also would provide additional benefits like enabling more advanced use cases such as folding etc and support in text-editors. However, the more I research the more I started to question if this is the best direction for Roc at this time. The features TS would enable are desirable in the short-term, however, I think they will be better satisfied by Roc's projectional editor. 

**Issues**
- Roc's indentation rules are *very* subtle so it will be hard to get a tree-sitter parser that works correctly
- This is particularly challenging for keywords etc which are context-sensitive and so there are many subtle cases to handle correctly.

**Proposed Solution** 
Emit relevant syntax information such as keywords as a side stream in the parser. This supports a syntax highlighting use case, and is easy to make optional and eliminate any effect on the production compiler.
 
@JoshuaWarner has recently embarked on [a campaign](https://github.com/roc-lang/roc/pull/4470) to convert the parser to use combinators. The goal is to have *one* parser that can be used in different contexts, and provide different behaviour as required. The Parser trait that has a single [parse method](https://github.com/roc-lang/roc/blob/main/crates/compiler/parse/src/parser.rs#L771). If everything is combinator-based, it's easy to have a second `parse_for_highlight` method in this trait that returns extra data along with the thing it just parsed. In this case, it will also return a list of locations that were parsed; in something like `Vec<Loc<SyntaxElement>>`.

When everything is converted to using combinators, we can then implement logic for just the combinators themselves. We can capture the `Loc` information for relevant syntax such as keywords, builtins, constants, literals, strings, comments, operators, and other characters `(`,`:` etc.

Then we simply serialise the text buffer and insert `<span>` and `</span>` where needed.

There is a fair amount of up front work before we see any externally-visible progress, however I think this is a worthwhile objective to aim for. 