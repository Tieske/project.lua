--- This module does something.
--
-- Explain some basics, or the design.
--
-- @copyright Copyright (c) 202x-202x your name
-- @author your name
-- @license xxx

local M = {}
M._VERSION = "0.0.1"
M._COPYRIGHT = "Copyright (c) 202x-2020x your name"
M._DESCRIPTION = "does something"


--- Does something.
-- It will do what you tell it.
-- @tparam string|function what the thing that has to be done
-- @tparam[opt=false] boolean force set tpo a truthy value to force it.
-- @treturn boolean success
-- @treturn nil|string error message on failure
-- @usage
-- local success, err = project.do_something("tell a lie", true)
-- if not success then
--     print("failed at lying; ", err)
-- end
function M.do_something(what, force)
  -- implement

end

return M
