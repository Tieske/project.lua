# Guidance for AI agents

This file is the main entry point for AI tools working in this repository. It provides project context and points to authoritative sources for conventions.

Other files to follow from this main entry point:

| Path | Purpose |
|------|---------|
| [`CONTRIBUTING.md`](./CONTRIBUTING.md) | for contributing guidelines |
| [`spec/AGENTS.md`](spec/AGENTS.md) | for test conventions |
| [.luacheckrc](.luacheckrc) and [.editorconfig](.editorconfig) | for project wide style and lint rules |
| [doc_topics/](./doc_topics/) | The context for this project |


## What this project is

The context can be acquired from `doc_topics/` (to prevent duplication here). If the contents are still just the template placeholders, then an AI Agent may suggest to scan the codebase and generate/update the contents.


## Project layout

| Path | Purpose |
|------|---------|
| `src/` | Lua source |
| `spec/` | Tests (Busted); see [`spec/AGENTS.md`](spec/AGENTS.md) for test conventions |
| `examples/` | Example scripts |
| `doc_topics/` | user facing generic documentation about purpose, design etc. |
| `bin/` | Commandline scripts, see [rockspec]([module-name]-scm-1.rockspec) |
| `.luacheckrc` | LuaCheck lint configuration (authoritative for lint) |
| `.editorconfig` | Editor/formatting preferences |
| `config.ld` | ldoc configuration for API docs |
| `AGENTS.md` | main entrypoint for AI agents |

## Testing

**Every new feature, bug fix, or behavioural change MUST be accompanied by tests.** Do not submit code changes without corresponding test coverage. If a test is genuinely not applicable, document the reason.

For test file conventions, isolation rules, code style, and vertical whitespace rules, see **[spec/AGENTS.md](spec/AGENTS.md)**.

## Lua compatibility

All code MUST be compatible with the Lua versions specified in the [rockspec]([module-name]-scm-1.rockspec). This includes LuaJIT. Do not use features specific to a single Lua version without a compatibility shim.

## Code style

Code style is defined in [CONTRIBUTING.md](CONTRIBUTING.md). Ensure `luacheck .` passes with zero warnings before committing.
