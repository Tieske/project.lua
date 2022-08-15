

# dev/test dependencies; versions can be pinned. Example: "ldoc 1.4.6"
DEV_ROCKS = "busted" "luacheck" "ldoc" "luacov"

all: test lint doc

install: luarocks
	luarocks make


# note: restore the docs to the last committed version
clean: clean_luacov clean_luarocks clean_doc
	git checkout docs


.PHONY: test
test: clean_luacov dev
	busted


# test while having the code installed; also tests the rockspec.
# this will modify the local luarocks installation/tree!
# TODO: add a forced remove from luarocks, removing ALL versions installed
.PHONY: testinst
testinst: clean_luacov dev install
	busted --lpath="" --cpath=""


.PHONY: lint
lint: dev
	@echo "luarocks lint ..."
	@for spec in $(shell find . -type f -name "*.rockspec") ; do \
	  (luarocks lint $$spec && echo "$$spec [OK]") || (echo "$$spec [NOK]"; exit 1); \
	done
	luacheck .


.PHONY: doc
doc: clean_doc
	mkdir -p ./docs
	ldoc .


.PHONY: docs
docs: doc


.PHONY: dev
dev: luarocks
	@for rock in $(DEV_ROCKS) ; do \
	  (luarocks list --porcelain $$rock | grep -q "installed") || (luarocks install $$rock || exit 1); \
	done;


.PHONY: clean_doc
clean_doc:
	$(RM) -r docs


.PHONY: clean_luarocks
clean_luarocks:
	$(RM) *.rock


.PHONY: clean_luacov
clean_luacov:
	$(RM) luacov.report.out luacov.stats.out


.PHONY: luarocks
luarocks:
	@which luarocks > /dev/null || (echo "LuaRocks was not found. Please install and/or make available in the path." && exit 1)
