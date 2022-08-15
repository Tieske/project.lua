# 1. Introduction

A project template to remove the tedious repetitive work of creating Lua modules

## 1.1 Why?

Creating well structured projects, including CI, documentation, sane defaults
for testing, linting, etc. Are a lot of work to set up. Even if you've done it
before it requires copying config files, updating all details, removing any
project specifics and what not.

This template is **very** opinionated. It assumes a.o.;

- LuaRocks for distribution
- Busted for testing
- LuaCheck for linting
- Ldoc for documentation generation.
- Github for code repositories
- Github Actions for CI

The reasons behind many choices and settings can [be found below](#Choices_explained).

## 1.2 Getting started

Here's a list of things to do when using this template:

1. pick a name for your project. Check on Github and LuaRocks that the name is available.
   A common pattern for naming is to use a `.lua` extension on Github, and the plain
   name for LuaRocks and when using `require`. So for this template:

    - Github (`project.lua`): "https://github.com/Tieske/`project.lua`.git"
    - LuaRocks (`project`): "luarocks install `project`"
    - Lua (`project`): "local prj = require '`project`'

2. something else

## 1.3 Workflows

The project assumes some specific workflows:

- Documentation is rendered only upon a release (otherwise the online docs would reflect the
  current development branch, instead of the latest release).

- PR's should include documentation changes and an entry in the
  [`Changelog.md`](changelog.md.html) file.


## 1.4 The Makefile

The Makefile has a number of targets defined:

- `all`: (the default) will test, lint and build the docs
- `install`: will use LuaRocks to install the package from the currently checked out code
- `clean`: will the clean the repo, remove generated artifacts and restore the docs to
  the last committed version (docs should be rendered only when releasing).
- `test`: will run the test suite using Busted, and generate the LuaCov coverage report.
- `testinst`: the same as `test`, except that it will first install the module, and it will
   disable the local source tree. This provides a better test (since it includes the rockspec
   install), but will change the locally installed LuaRocks tree.
- `lint`: will lint the Lua code files (using LuaCheck) as well as the rockspecs (using
  LuaRocks).
- `doc`: will re-render the docs (will remove the existing docs first so use this over the
  `ldoc .` command to prevent orphaned files in the docs tree).
- `dev` will install the required development dependencies using LuaRocks (busted, luacheck,
  ldoc, and luacov).

## 1.5 Choices explained

### 1.5.1 `./src` directory

The test engine (busted) will by default put this location in the search path, and put it
first. This ensures you're testing the development code and not some older installed version.

### 1.5.2 `scm-1` rockspec

The `scm` rockspec is a development version, so targetting the latest `main` branch (or
`master`). This means that:
- the rockspec is updated in PR's (files added/removed are also added/removed from the
  rockspec)
- when a change to the `scm` rockspec is merged, the updated `scm` rockspec should be
  uploaded to LuaRocks to replace the previous version.
- the revision of the rockspec (the `1` in `scm-1`) is never updated

### 1.5.3 the main modules is called `init.lua`.

Though this might seem cumbersome for a small module, the problem is that it cannot be
changed later. Hence better safe than sorry. It will also ensure that the file tree remains
clean, everything in a single folder.

If you start with `project.lua` instead of `project/init.lua`, and at some point you want
to change. The installation procedure will typically not remove the previous versions'
`project.lua` file, it will just add `project/init.lua`. Which will lead to both files
being in your file tree, and then typically the one without `init` will have precedence over
the other. So the new version of the module will be "unreachable", leading to all sorts of
unpredictable behaviour.

### 1.5.4 License

The default license is the MIT license, since that is most common in the Lua eco-system,
and used by the Lua distributions them selves.

Update the `LICENSE` file if the default MIT license doesn't suit you. Make sure
to use a format that is recognized by Github, such that when users click the
`LICENSE` file, they [get a nice header](https://github.com/Tieske/project.lua/blob/main/LICENSE)
at the top explaining the basics of the license.

Make sure to also update the license details in the code files, and in the `.rockspec` files.


