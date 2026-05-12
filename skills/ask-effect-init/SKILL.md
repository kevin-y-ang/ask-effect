---
name: ask-effect-init
description: Vendor the Effect API reference via git subtree so AI agents can look up Effect APIs from source code. Use when user wants to initialize the Effect API reference, set up the Effect API reference, or run /ask-effect-init.
---

# Effect Reference Setup

Vendor the Effect API reference as a git subtree so AI coding agents can look up accurate Effect APIs directly from source code.

Effect lives at `github.com/Effect-TS/effect` — git subtree nests the repository as a subdirectory under `repos/effect/`, committed as part of your project. Once added, it behaves like any other directory in the project.

**If the skill was invoked explicitly by the user:** consider that as permission to just go ahead and execute.

## If `repos/effect/` does NOT exist

Add as a git subtree:

```bash
git subtree add \
  --prefix=repos/effect \
  https://github.com/Effect-TS/effect.git \
  main \
  --squash
```

The `--squash` flag is important — without it, the entire upstream history (thousands of commits) gets pulled into your project's git history. `--squash` collapses everything into a single commit.

## If `repos/effect/` already exists

Pull in changes from upstream:

```bash
git subtree pull \
  --prefix=repos/effect \
  https://github.com/Effect-TS/effect.git \
  main \
  --squash
```

Each update lands as a single commit, which keeps history predictable and easy to review.

## Configure the agent

After adding the subtree, the agent needs to know how to use the vendored source. Ask the user the following question:

> Would you like me to add instructions for using `@repos/` as read-only reference material to `AGENTS.md` and/or `CLAUDE.md`?

- **If you have an ask-question tool available (e.g. `AskQuestion` tool in Cursor, `AskUserQuestion` tool in Claude Code, `request_user_input` tool in Codex):** use it with the options "Yes, both AGENTS.md and CLAUDE.md", "Yes, only AGENTS.md", "Yes, only CLAUDE.md" and "No".
- **Otherwise:** ask the user directly.

If the user agrees, append the following section to each selected file (create the file if it does not exist):

```md
## Vendored Repositories

This project vendors external repositories under @repos/

  - Use vendored repositories as read-only reference material when working with related libraries
  - Prefer examples and patterns from the vendored source code over generated guesses or web search results
  - Do not edit files under @repos/ unless explicitly asked
  - Do not import from @repos/ - application code should continue importing from normal package dependencies

When writing Effect code, inspect @repos/effect/ for examples of idiomatic usage, tests, module structure, and API de
sign. Treat it as the source of truth for Effect patterns. Always read @repos/effect/LLMS.md before writing any Effec
t code (if present).
```

## Configure the editor

To keep your editor from surfacing search results and auto-imports from the vendored source, add the following to `.vscode/settings.json`:

```json
{
  "typescript.preferences.autoImportFileExcludePatterns": [
    "repos/**"
  ],
  "javascript.preferences.autoImportFileExcludePatterns": [
    "repos/**"
  ],

  "files.exclude": {
    "repos/**": true
  },

  "files.watcherExclude": {
    "repos/**": true
  },

  "search.exclude": {
    "repos/**": true
  }
}
```

Other editors can be configured similarly.

## Configure the TypeScript toolchain

Scan the repo root for config files belonging to the following tools: TypeScript, ESLint, oxlint, Biome, Prettier, oxfmt, Vitest, Jest.

List the tools that were detected, then ask the user:

> Would you like me to modify {{TOOL_LIST}} to exclude `repos/`?

- **If you have an ask-question tool available (e.g. `AskQuestion` tool in Cursor, `AskUserQuestion` tool in Claude Code, `request_user_input` tool in Codex):** use it with the options "Yes, modify all the tools", "Choose which tools to modify" and "No".
- **Otherwise:** ask the user directly.

If the user picks "Choose which tools to modify", ask a follow-up multi-select question listing only the detected tools.

For each chosen tool, locate its config and add the appropriate exclusion for `repos/`.

## Checklist

- [ ] `repos/effect/` exists with source files
- [ ] Subtree commit is in the project's git history
- [ ] _(optional)_ `AGENTS.md` and/or `CLAUDE.md` reference `@repos/` as read-only reference material
- [ ] _(optional)_ Editor configured to exclude `repos/` from search, watching, and auto-imports
- [ ] _(optional)_ Detected TypeScript toolchain configs updated to exclude `repos/`
