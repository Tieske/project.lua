local package_name = "project"
local package_version = "scm"
local rockspec_revision = "1"
local github_account_name = "Tieske"
local github_repo_name = "homie.lua"


package = package_name
version = package_version.."-"..rockspec_revision

source = {
   url = "git+https://github.com/"..github_account_name.."/"..github_repo_name..".git",
   branch = (package_version == "scm") and "main" or nil,
   tag = (package_version ~= "scm") and package_version or nil,
}

description = {
   summary = "Lua project template",
   detailed = [[
      A template for Lua projects that includes opinionated defaults for
      testing, documentation, CI, etc.
   ]],
   license = "MIT/X11",
   homepage = "https://github.com/"..github_account_name.."/"..github_repo_name,
}

dependencies = {
   "lua >= 5.1, < 5.5",
}

build = {
   type = "builtin",

   modules = {
      ["project.init"] = "src/project/init.lua",
   },

   copy_directories = {
      -- can be accessed by `luarocks [rockname] doc` from the commandline
      "docs",
   },
}
