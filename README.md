
# Roc Awesome 🤘

A collection of links to awesome roc things.

> 🦎 **The Roc compiler is being rewritten from Rust to Zig.** This list now tracks
> projects that work with the **new Zig-based compiler**. Projects that haven't been
> migrated yet have moved to **[LEGACY_ROC.md](LEGACY_ROC.md)** — that file doubles as
> a checklist of what still needs porting. Migrating a package or platform is a great
> way to help out! 🙌
>
> 📚 New here? Richard Feldman's writeup [**on the Rust → Zig compiler rewrite**](https://gist.github.com/rtfeldman/77fb430ee57b42f5f2ca973a3992532f) explains why it's happening and what it changes.

**Legend:** ✅ works with the new compiler · 🚧 migration in progress (PR/branch open)

- **Repository** [roc-lang/roc](https://github.com/roc-lang/roc)
- **Download Roc** ⬇️ [roc-lang/nightlies releases](https://github.com/roc-lang/nightlies/releases) — prebuilt nightly builds of the latest compiler
- **Building From Source** 🏗️ [official guide](https://github.com/roc-lang/roc/blob/main/BUILDING_FROM_SOURCE.md)
- **Tutorial** 📖 [docs/mini-tutorial-new-compiler.md](https://github.com/roc-lang/roc/blob/main/docs/mini-tutorial-new-compiler.md) — interim "mini" tutorial for the new compiler (a full rewrite is planned)
- **Language Reference** [docs/langref](https://github.com/roc-lang/roc/tree/main/docs/langref) — new-compiler reference (not yet complete or on the website, but very helpful)
- **Syntax Reference** [test/echo/all_syntax_test.roc](https://github.com/roc-lang/roc/blob/main/test/echo/all_syntax_test.roc) — a single file demonstrating the new syntax
- **Exercism Track** [exercism.org/tracks/roc](https://exercism.org/tracks/roc) 🚧 ([migration PR #198](https://github.com/exercism/roc/pull/198) — 92+ exercises ported & passing)
- **Dockerhub** [hub.docker.com/repositories/roclang](https://hub.docker.com/repositories/roclang)

> ℹ️ The [roc-lang.org](https://www.roc-lang.org) website (Examples, Tutorial, Docs) still
> documents the **old** compiler and is yet to be updated — for now use the new-compiler
> mini-tutorial and syntax reference above.

## Roc Packages 📦
- [roc-lang/http](https://github.com/roc-lang/http): HTTP client ✅ ([release 0.1](https://github.com/roc-lang/http/releases/tag/0.1))
- [roc-lang/path](https://github.com/roc-lang/path): OS filesystem path manipulation ✅ ([release 0.1](https://github.com/roc-lang/path/releases/tag/0.1))
- [lukewilliamboswell/roc-ansi](https://github.com/lukewilliamboswell/roc-ansi): ANSI escape codes for color, styling & cursor control ✅ ([release 0.9.0](https://github.com/lukewilliamboswell/roc-ansi/releases/tag/0.9.0))
- [lukewilliamboswell/roc-parser](https://github.com/lukewilliamboswell/roc-parser): Parser Combinators 🚧 ([PR #30](https://github.com/lukewilliamboswell/roc-parser/pull/30))
- [lukewilliamboswell/roc-random](https://github.com/lukewilliamboswell/roc-random): Random number generation 🚧 (branch `update-new-module-syntax`)

## Roc Platforms 🏢
- [lukewilliamboswell/roc-wasm4](https://github.com/lukewilliamboswell/roc-wasm4): WASM-4 Games 🕹️ ✅
- [lukewilliamboswell/roc-ray](https://github.com/lukewilliamboswell/roc-ray): Graphics and GUI using Raylib ✅
- [roc-lang/basic-cli](https://github.com/roc-lang/basic-cli): CLI apps 🚧 ([PR #413](https://github.com/roc-lang/basic-cli/pull/413))
- [roc-lang/basic-webserver](https://github.com/roc-lang/basic-webserver): Webservers 🚧 ([PR #163](https://github.com/roc-lang/basic-webserver/pull/163))
- [lukewilliamboswell/basic-ssg](https://github.com/lukewilliamboswell/basic-ssg): Static Site Generation 🚧 ([PR #16](https://github.com/lukewilliamboswell/basic-ssg/pull/16))

*Templates & Embedding/Interop Examples* 🗺
- [Zig platform template](https://github.com/lukewilliamboswell/roc-platform-template-zig) ✅
- [Rust platform template](https://github.com/lukewilliamboswell/roc-platform-template-rust) ✅

## Tools 🛠️
- [faldor20/tree-sitter-roc](https://github.com/faldor20/tree-sitter-roc): Tree-sitter grammar (updated for the new syntax) ✅ — also powers Helix & Neovim
- [h2000/zed-roc](https://github.com/h2000/zed-roc): Zed editor support, using the new grammar & LSP ✅
- [roc-lang/setup-roc](https://github.com/roc-lang/setup-roc): GitHub Action to install Roc ✅ — supports new-compiler nightlies (`version: nightly-new-compiler`)

## AI Skills 🤖
This repo doubles as a [Claude Code plugin marketplace](https://code.claude.com/docs/en/plugin-marketplaces) bundling skills that encode Roc best-practices — repo hygiene (`roc-hygiene`), CI scaffolding (`roc-setup-ci`), and legacy-syntax migration (`roc-migrate-legacy`). Install with:

```shell
/plugin marketplace add lukewilliamboswell/roc-awesome
/plugin install roc-skills@roc-awesome
```

Skills live under [`plugins/roc-skills/skills/`](plugins/roc-skills/skills) — contributions welcome.

### Use via symlink (for development & contributors)

If you want to **edit the skills and see changes immediately** (rather than reinstalling the plugin), clone the repo and symlink the skill folders into a skills directory Claude Code scans. Discovery is one level deep — `<skills-dir>/<skill-name>/SKILL.md` — so link each skill folder individually.

```shell
git clone https://github.com/lukewilliamboswell/roc-awesome
cd roc-awesome

# Personal scope — available in all your projects (~/.claude/skills/):
mkdir -p ~/.claude/skills
for s in plugins/roc-skills/skills/*/; do
  ln -s "$PWD/$s" ~/.claude/skills/"$(basename "$s")"
done

# …or project scope — only this repo (commit .claude/skills/ to share it):
#   ln -s "$PWD/plugins/roc-skills/skills/roc-hygiene" /path/to/project/.claude/skills/roc-hygiene
```

Notes:
- **Invocation differs from the plugin form.** Symlinked skills are invoked by directory name (`/roc-hygiene`), whereas the plugin form is namespaced (`/roc-skills:roc-hygiene`). Plugin skills are namespaced so the two installs don't collide — but two symlinked skills with the same name would, so don't symlink into a dir that already has a `roc-hygiene`.
- **Live reload:** edits to a `SKILL.md` under a watched skills dir take effect within the current session. Creating a *new* top-level skills directory that didn't exist when the session started requires restarting Claude Code. (Edits made *through* a symlink may not be detected by the file watcher on every platform — restart to be sure.)
- Personal skills go in `~/.claude/skills/`; project skills in `<project>/.claude/skills/` and should be committed to version control to share with your team.

---

📜 Looking for the older ecosystem (everything not yet migrated to the new compiler)?
See **[LEGACY_ROC.md](LEGACY_ROC.md)**.
