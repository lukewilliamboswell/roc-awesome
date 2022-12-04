
## [Installation](#installation)

Roc doesn't have a numbered release or an installer yet, but you can download a nightly release of the `roc` command-line executable from the [Releases page](https://github.com/roc-lang/roc/releases) (under "Assets"). After you [unzip it](https://kinsta.com/knowledgebase/unzip-tar-gz/), be sure to add `roc` to your [PATH](https://www.java.com/en/download/help/path.html).

You'll know it worked when you can run `roc version` in your terminal and see it print out some version information.

If you get stuck, friendly people will be happy to help if you open a topic in [#beginners](https://roc.zulipchat.com/#narrow/stream/231634-beginners) on [Roc Zulip Chat](https://roc.zulipchat.com/) and ask for assistance!

## [Strings and Numbers](#strings-and-numbers)

Let's start by getting acquainted with Roc's [_Read-Eval-Print-Loop_](https://en.wikipedia.org/wiki/Read%E2%80%93eval%E2%80%93print_loop), or **REPL** for short. Run this in a terminal:

`roc repl`

If Roc is [installed](#installation), you should see this:

`The rockin’ roc repl`

So far, so good!

### [Hello, World!](#hello-world)

Try typing this at the REPL prompt and pressing Enter:

`"Hello, World!"`

The REPL should cheerfully display the following:

`"Hello, World!" : Str \# val1`

Congratulations! You've just written your first Roc code.