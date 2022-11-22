# 1. Introduction

A project template to remove the tedious repetitive work of creating Lua modules

## 1.1 Why?

Creating well structured projects, including CI, documentation, sane defaults
for testing, linting, etc. are a lot of work to set up. Even if you've done it
before it requires copying config files, updating all details, removing any
project specifics and what not.

This template is **very** opinionated. It assumes a.o.;

- LuaRocks for distribution
- Busted for testing
- LuaCheck for linting
- Ldoc for documentation generation.
- Github for code repositories
- Github Actions for CI

The reasons behind many choices and settings can be [found below](#1_5_Choices_explained).

## 1.2 Getting started

Here's a list of things to do when using this template:

* pick a name for your project. Check on Github and LuaRocks that the name is available.
  A common pattern for naming is to use a `.lua` extension on Github, and the plain
  name for LuaRocks and when using `require`. So for this template:

    - Github (`project.lua`): "https://github.com/Tieske/`project.lua`.git"
    - LuaRocks (`project`): "luarocks install `project`"
    - Lua (`project`): "local prj = require '`project`'"


* [Go to the template on Github and create a new repo from it](https://github.com/Tieske/project.lua/generate),
  set the "`[short-description]`".

* In the new repo settings, go to "Pages", and select branch "`main`" and folder "`/docs`".

* On the main repo page edit the project details; add the link to the documentation.

* Clone the repo locally.

* Run the interactive `init.sh` script.

* Commit all changes, and push to the repo.


## 1.3 Workflows

The project assumes some specific workflows:

- Documentation is rendered only upon a release (otherwise the online docs would reflect the
  current development branch, instead of the latest release).

- PR's should include documentation changes and an entry in the
  [`CHANGELOG.md`](changelog.md.html) file.


## 1.4 The Makefile

The Makefile has a number of targets defined:

- `help`: displays the available make-targets (this is the default target)
- `install`: will use LuaRocks to install the package from the currently checked out code
- `uninstall`: will use LuaRocks to uninstall (all versions of) the package
- `clean`: will the clean the repo, remove generated artifacts and restore the docs to
  the last committed version (docs should be rendered only when releasing).
- `test`: will run the test suite using Busted, and generate the LuaCov coverage report.
- `testinst`: the same as `test`, except that it installs first and runs tests using the
  installed version (this modifies the local installation, but also tests the .rockspec
  file). This is best used when testing in CI.
- `lint`: will lint the Lua code files (using LuaCheck) as well as the rockspecs (using
  LuaRocks).
- `doc`: will re-render the docs (will remove the existing docs first, so use this over the
  `ldoc .` command to prevent orphaned files in the docs tree).
- `deps`: installs the module dependencies
- `dev`: installs the required development dependencies using LuaRocks (busted, luacheck,
  ldoc, and luacov).


## 1.5 Choices explained

### 1.5.1 "`./src`" directory

The test engine (Busted) will by default put this location in the search path, and put it
first. This ensures you're testing the development code and not some older installed version.


### 1.5.2 "`scm-1`" rockspec

The "`scm`" rockspec is a development version, so targetting the latest "`main`" branch (or
"`master`"). This means that:

- the rockspec is updated in PR's (files added/removed are also added/removed from the
  rockspec)
- when a change to the "`scm`" rockspec is merged, the updated "`scm`" rockspec should be
  uploaded to LuaRocks (forced upload) to replace the previous version.
- the revision of the rockspec (the "`1`" in "`scm-1`") should never be updated

*NOTE*: the rockspec specifes to also distribute the documentation with the package. Users
can locally do

    luarocks doc [package-name]

to access the locally installed documentation.

### 1.5.3 the main modules is called "`init.lua`".

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
`LICENSE` file, they [get a nice header](https://github.com/Tieske/project.lua/blob/main/LICENSE.md)
at the top explaining the basics of the license.

Make sure to also update the license details in the code files, and in the `.rockspec` files.


### 1.5.5 The "`README.md`"

The readme is minimalistic. If it were added to the doc generation, then many links would either
in the docs, or on Github not be rendered properly. Hence it includes as little as possible to
prevent duplication. And any relevant info should be added as a document in `./doc_topics`.


### 1.5.6 Documentation settings in "`config.ld`"

Source code documentation is parsed from `./src/`. Whilst the manual is generated from
`./doc_topics/`, and both the license and changelog are included in the docs.

The manual files will be added to the ToC in alphabetical order. Hence the manual files
have a number prefix to force the order. The actual titles will be taken from the contents
as long as they use Markdown headings (either `#` or `##` prefix)


### 1.5.7 Test coverage settings in "`.luacov`"

This files lists the source files to include in the coverage reporting. By default the report
is generated after the test run. See also the "`.busted`" file, which specifies to use LuaCov.


### 1.5.8 Lua linter rules by LuaCheck in "`.luacheck`"

See the LuaCheck documentation for exact details.


### 1.5.9 Git files in  "`.gitignore`"

This is the default set from Github for Lua. But adds;

- `*.rock` such that all packed rocks will be excluded
- `*.stats.out`, `*.report.out`; the LuaCov output files


### 1.5.9 Whitespace configuration in  "`.editorconfig`"

This defines per file-type the whitespace settings for editors to use.


### 1.5.10 Test output settings  "`.busted`"

Since when testing we do not care about successes typically, only about failures, the
defaults are quite verbose. If it succeeds we can ignore, if it fails, we have the details
we need.

It also includes coverage testing by default (Busted uses LuaCov).


### 1.5.11 The tests in "`./spec/`"

This is the default location for Busted to check for tests. Loading all Lua files
with a pattern "`*_spec.lua`". The test files will be run in sorted order, hence
the files are prefixed with digits to force a deterministic order when testing.


### 1.5.12 Published rockspecs in  "`./rockspecs/`"

This is an empty folder where published rockspecs can be added. See instructions at the top
of "`CHANGELOG.md`".


### 1.5.13 Documentation in/from  "`./docs`", "`./doc_topics`", and "`./examples`"

The documentation is generated by Ldoc. The output is written to "`./docs/`", so on Github,
the "pages" feature can be configured to point to the "`main`" branch, and the "`./docs/`" folder.

As input for the documentation there will be;

- the parsed info from the source files,
- the manual written documentation in "`./doc_topics/`",
- any examples; "`*.lua`" files in "`./examples/`"
- CSS style sheet; "`./doc_topics/ldoc.css`"

It is advised to at least have 1 markdown file in `./doc_topics`, to contain more generic information
that could also go in the readme file. Adding it here has the benefit of creating standalone
documentation that will be distributed with the package (including the readme in the docs would
add web-links to the docs, and it would not be standalone anymore).

The `doc_topics` and `examples` can be deleted if not needed, it will require some adjustments
to the Ldoc config file "`./config.ld`".
