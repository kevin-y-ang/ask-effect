# ask-effect

Claude Code skills for working with the Effect TypeScript library directly from source code.

## Skills

- `/ask-effect` — Answer questions about Effect modules, APIs, and patterns by searching the actual source code. Always cites file paths and line numbers.
- `/ask-effect-do` — Implement a request using Effect. Writes the code directly while using subagents to look up accurate APIs from the source.
- `/ask-effect-init` — Set up the Effect source via shallow clone of `github.com/effect-ts/effect`.

## Install

```
npx -y skills add https://github.com/kevin-y-ang/ask-effect.git
```

## Usage

Initialize the Effect API reference (or pull the latest updates):

```
/ask-effect-init
```

Ask questions about any Effect module:

```
/ask-effect how does Effect.retry work?
/ask-effect what combinators does Stream export?
/ask-effect show me usage examples for Schema.decode
```

Implement with Effect:

```
/ask-effect-do add retry logic with exponential backoff
/ask-effect-do create an HTTP client with error handling using Platform
```
