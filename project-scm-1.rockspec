local package_name = "[project-name]"
local package_version = "scm"
local rockspec_revision = "1"
local github_account_name = "[github-account-name]"
local github_repo_name = "[repo-name]"


package = package_name
version = package_version.."-"..rockspec_revision

source = {
  url = "git+https://github.com/"..github_account_name.."/"..github_repo_name..".git",
  branch = (package_version == "scm") and "main" or nil,
  tag = (package_version ~= "scm") and package_version or nil,
}

description = {
  summary = "[short-description]",
  detailed = [[
    [short-description]
  ]],
  license = "MIT",
  homepage = "https://github.com/"..github_account_name.."/"..github_repo_name,
}

dependencies = {
  "lua >= 5.1, < 5.5",
}

build = {
  type = "builtin",

  modules = {
    ["[project-name].init"] = "src/[project-name]/init.lua",
  },

  copy_directories = {
    -- can be accessed by `luarocks [project-name] doc` from the commandline
    "docs",
  },
}
