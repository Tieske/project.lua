# CHANGELOG

#### Releasing new versions

- create a release branch
- update the changelog below
- update version and copyright-years in `./LICENSE` and `./src/[project-name]/init.lua` (in doc-comments
  header, and in module constants)
- create a new rockspec and update the version inside the new rockspec:
  `cp [project-name]-scm-1.rockspec ./rockspecs/[project-name]-X.Y.Z-1.rockspec`
- test: run `make test` and `make lint`
- clean and render the docs: run `make clean` and `make docs`
- commit the changes as `release X.Y.Z`
- push the commit, and create a release PR
- after merging tag the release commit with `X.Y.Z`
- upload to LuaRocks: `luarocks upload ./rockspecs/[project-name]-X.Y.Z-1.rockspec --api-key=ABCDEFGH`
- test the newly created rock: `luarocks install [project-name]`

### Version X.Y.Z, unreleased

  - a fix
  - a change

### Version 0.1.0, released 01-Jan-2022

  - initial release
