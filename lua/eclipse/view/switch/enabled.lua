local config = require("eclipse.config")

local M = {}

function M.enable()
	if not M.enabled then
		config.colors()
		M.enabled = true
		-- HACK: use defer_fn since TreeSitter is doing something that breaks the dimmers
		vim.cmd([[
        augroup Eclipse
          autocmd!
          autocmd BufWritePost,CursorMoved,CursorMovedI,WinScrolled * lua require("eclipse.view").update()
          autocmd WinEnter * lua require("eclipse.view").on_win_enter()
          autocmd BufWritePost * lua vim.defer_fn(function()require("eclipse.view").update()end, 0)
          autocmd ColorScheme * lua require("eclipse.config").colors()
        augroup end]])
		M.started = true
		M.on_win_enter()
	end
end

-- turn this on later
M.enabled = false

return M
