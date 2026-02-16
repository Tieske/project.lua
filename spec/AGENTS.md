# Guidance for AI agents — test suite

This file covers conventions for the Busted test files in `./spec/`.

## Test framework

Tests use [Busted](https://lunarmodules.github.io/busted/). Run them with `busted` from the repository root. Lint with `luacheck`.
Coverage information will be in the file `luacov.report.out`.

When running tests using `busted` ALWAYS specify `--output=utfTerminal` which generates less output than the default `gtest` handler. To save on tokens.

The Makefile can be used (`make test` or `make lint`) once to ensure the proper test tools get installed. Again; to reduce output and save tokens AI agents should NOT use the Makefile for regular testing, that is for humans.

## File layout

Spec files are named with a numeric prefix and a descriptive suffix: `NN-topic_spec.lua`. The numbering controls execution order and groups related concerns.

When adding tests, place them in the file that matches their scope. Only create a new file when the topic is clearly distinct from existing files.

## Test isolation

In Busted the test files are run as Lua files; all `describe` blocks execute at load time. All other blocks only run at test-runtime. Therefore:

- All initialization MUST be in `setup` or `before_each` blocks, NEVER directly in `describe` blocks.
- Variables may be declared at the `describe` level (to keep them in scope), but MUST NOT be assigned values there.
- The only exception is code that generates tests (table-driven tests), which is designed to run at the `describe` level.

Example:

```lua
describe("some block", function()

  local my_module    -- only declare here, no values!

  before_each(function()
    my_module = require "my.module.something"   -- initialize here
  end)



  it("a test", function()
    -- test goes here
  end)


  it("another test", function()
    -- test goes here
  end)

end)
```

## Code style

Style follows [.editorconfig](../.editorconfig), LF line endings) and [.luacheckrc](../.luacheckrc).

### General

- Keep test descriptions concise and starting with a verb (e.g. "creates ...", "rejects ...", "transitions ...").

### Vertical whitespace

- 3 blank lines between `describe` blocks
- 1 blank line at the start of a `describe` block
- 2 blank lines between other blocks (`it`, `setup`, `before_each`, etc)
- 3 blank lines between initialization (`setup`/`teardown`/etc) and the first `it` or `describe` block
- 1 blank line between multiple closing `end)` statements

### Test file structure

When unit testing functions or methods, each function should have its own `describe` block inside the module-level `describe`. This keeps tests grouped by function and provides a clear structure.

Example:

```lua
describe("my_object", function()

  describe("some_method()", function()

    it("prints something cool", function()
      -- implementation here
    end)

  end)



  describe("another_method()", function()

    it("throws an error on something bad", function()
      -- implementation here
    end)

  end)

end)
```
