print("Loading...")

local package = grin.packageFromExecutable(shell.getRunningProgram())

-- Root directory
local root = grin.resolvePackageRoot(package)

-- Add to LuaLua mod path
|Modules appendPath:"/"..grin.combine(grin.resolvePackageRoot(package), "mod")|

-- Modules
local RednetConfiguration = require("RednetConfiguration.lua")
local Connection = require("Connection.lua")

