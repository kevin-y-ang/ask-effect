---
name: ask-effect-do
description: Do a request related to Effect. Use when user wants to you to implement, modify, or debug something related to Effect, or when the user runs /ask-effect-do with a request.
---

# Implement with Effect

Implement a user request using the Effect TypeScript library, referencing the Effect API reference for accurate APIs and patterns.

**Required argument:** a description of what to implement (e.g., "add retry logic with exponential backoff using Effect")

## Check the Effect API reference

Run the Effect API reference staleness check before doing anything else:

[staleness-check.sh](./scripts/staleness-check.sh)

**If OK:** proceed to the next section.

**If MISSING:** ask the user the following question:

> The Effect API reference is not available. Would you like me to run the `/ask-effect-init` skill? This will download the Effect API reference under `<repo-root>/.vendor/` and add `.vendor/` to .gitignore.

- **If you have an ask-question tool available (e.g. `AskQuestion` tool in Cursor, `AskUserQuestion` tool in Claude Code, `request_user_input` tool in Codex):** use it with the options "Yes" and "No".
- **Otherwise:** ask the user directly.

**If the user agrees:** run the `/ask-effect-init` skill.
**If the user declines:** stop — tell the user this skill is not effective without the Effect API reference.

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

## Implement the request

Implement the user's request directly.

If you require additional details about how to use Effect modules, types, patterns, or APIs while implementing, use subagents to gather that context from the Effect API reference. Use the prompt template below for each subagent lookup.

- Launch subagent lookups in parallel when you need information about multiple modules.
- You may launch subagent lookups at any point during implementation when you encounter a module or API you are unsure about.
- Always verify against the Effect API reference via a subagent lookup before using an API you are not certain about.

**Subagent prompt template for Effect lookups:**

````
Answer this question about the Effect TypeScript library by searching the Effect API reference.
Do NOT guess or rely on training data — only answer from what you find in the API reference.
Always cite file paths and line numbers. Show relevant code snippets.

**Question:** {{LOOKUP_QUESTION}}

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

### Implementation guidelines

- Use correct imports, function signatures, and module APIs as found in the Effect API reference
- Follow patterns from existing tests in `packages/<package>/test/` when available
- If the API reference reveals that a module does not support what the user is asking for, say so and suggest alternatives found in the API reference
