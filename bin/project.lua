#!/usr/bin/env lua

--- CLI application.
-- Description goes here.
-- @script [module-name]
-- @usage
-- # start the application from a shell
-- [module-name] --some --options=here

print("Welcome to the [module-name] CLI, echoing arguments:")
for i, val in ipairs(arg) do
  print(i .. ":", val)
end
