local view = require("eclipse.view.view")
local config = require("eclipse.config")

local M = {}

M.setup = config.setup
M.toggle = view.toggle
M.disable = view.disable
M.enable = view.enable

function M.reset()
	M.disable()
	require("plenary.reload").reload_module("eclipse")
	require("eclipse").enable()
end

return M
