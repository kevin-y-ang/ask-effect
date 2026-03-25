---
name: ask-effect
description: Answer questions about Effect by searching the Effect API reference. Use when user asks about Effect modules, Effect APIs, Effect patterns, how to use an Effect module, or runs /ask-effect with a question.
---

# Ask Effect

Answer questions about the Effect TypeScript library by searching the Effect API reference.

**Required argument:** a question about Effect (e.g., "how does Effect.retry work?")

## Check the Effect API reference

Run this single check before doing anything else:

[staleness-check.sh](./scripts/staleness-check.sh)

**If OK:** proceed to the next section.

**If MISSING:** ask the user the following question:

> The Effect API reference is not available. Would you like me to run the `/ask-effect-init` skill? This will download the Effect API reference under `<repo-root>/.vendor/` and add `.vendor/` to .gitignore.

- **If you have an ask-question tool available (e.g. `AskQuestion` tool in Cursor, `AskUserQuestion` tool in Claude Code, `request_user_input` tool in Codex):** use it with the options "Yes" and "No".
- **Otherwise:** ask the user directly.

**If the user agrees:** run the `/ask-effect-init` skill.
**If the user declines:** stop — tell the user you cannot answer Effect questions without the Effect API reference.

**If STALE:** ask the user the following question:

> The Effect API reference is {{AGE}} days old. APIs may have changed. Want me to update it first?

- **If you have an ask-question tool available (e.g. `AskQuestion` tool in Cursor, `AskUserQuestion` tool in Claude Code, `request_user_input` tool in Codex):** use it with the options "Update" and "Continue without updating".
- **Otherwise:** ask the user directly.

**If the user agrees to update:**

```bash
git -C .vendor/effect pull --depth 1 origin main
```

**If the user declines:** proceed with the current API reference.

**If ERROR:** tell the user the `.vendor/effect` directory appears corrupted. Ask the user the following question:

> The Effect API reference appears corrupted. Would you like me to re-run the `/ask-effect-init` skill to re-clone it?

- **If you have an ask-question tool available (e.g. `AskQuestion` tool in Cursor, `AskUserQuestion` tool in Claude Code, `request_user_input` tool in Codex):** use it with the options "Yes" and "No".
- **Otherwise:** ask the user directly.

### Search the Effect API reference to answer the question

**If you have a subagent tool available (e.g. `Task` tool in Cursor, `Agent` tool in Claude Code, `spawn_agent` tool in Codex):** delegate the search to a subagent using the prompt template below.
  - **If the question is broad or ambiguous:** launch multiple subagents in parallel to explore different candidates, then synthesize results.
  - **If the question is specific:** use a single subagent and return its answer verbatim — do not summarize or rewrite it.

````
Answer this question about the Effect TypeScript library by searching the Effect API reference.
Do NOT guess — only answer from what you find in the API reference.
Always cite file paths and line numbers. Show relevant code snippets.

**Question:** {{USER_QUESTION}}

**API reference:** `.vendor/effect/`

**Directory structure:**

```
.vendor/effect/
├── packages/effect/              # Core Effect library
│   ├── src/                      #   module source files (Effect.ts, Stream.ts, etc.)
│   ├── src/internal/             #   internal implementation details
│   └── test/                     #   colocated tests
├── packages/schema/              # Schema (validation, serialization)
│   ├── src/                      #   module source
│   └── test/                     #   tests
├── packages/platform/            # Platform-agnostic abstractions (HTTP, FileSystem, etc.)
├── packages/platform-node/       # Node.js platform implementation
├── packages/platform-browser/    # Browser platform implementation
├── packages/platform-bun/        # Bun platform implementation
├── packages/cli/                 # CLI framework
├── packages/cluster/             # Distributed computing
├── packages/sql/                 # SQL base package
├── packages/sql-pg/              # PostgreSQL client
├── packages/sql-mysql2/          # MySQL client
├── packages/sql-sqlite-*/        # SQLite variants (node, bun, wasm, etc.)
├── packages/sql-drizzle/         # Drizzle ORM integration
├── packages/sql-kysely/          # Kysely integration
├── packages/rpc/                 # RPC framework
├── packages/ai/                  # AI integrations
├── packages/experimental/        # Experimental APIs
├── packages/opentelemetry/       # OpenTelemetry integration
├── packages/vitest/              # Vitest testing utilities
├── packages/printer-ansi/        # ANSI terminal printer
├── packages/typeclass/           # Typeclass definitions
└── packages/workflow/            # Workflow engine
```

**Where to look:**
1. Module source — `packages/<package>/src/` contains public API modules (one file per module, e.g. `Effect.ts`, `Stream.ts`)
2. Types — exported interfaces and type aliases are defined in the module source files
3. Internal implementation — `packages/<package>/src/internal/` contains the actual implementations
4. Tests — `packages/<package>/test/` contains tests showing usage patterns
````

**If you do NOT have subagent functionality:** Search the Effect API reference directly using Grep, Glob, and Read tools. Use the directory structure in the prompt template above to navigate.

### Answer from the API reference

- Always cite the file path and line numbers where you found the answer
- Show relevant code snippets from the actual source
- Do NOT guess or rely on training data — if you cannot find the answer in the API reference, say so
- If the question is ambiguous, list what you found and ask the user to clarify
