local M = {}

local ns = vim.api.nvim_create_namespace("eclipse")

-- Modify the M.clear function to clear all dimming in a buffer
function M.clear(buf)
	vim.api.nvim_buf_clear_namespace(buf, ns, 0, -1)
end

function M.get_visible(win)
	local info = vim.fn.getwininfo(win)
	return info[1].topline, info[1].botline + 1
end

function M.focus(win, from, to, dimmers)
	if not vim.api.nvim_win_is_valid(win) then
		return
	end

	local topline, botline = M.get_visible(win)

	for l = topline, botline do
		if l < from or l >= to then
			dimmers[l] = true
		end
	end
end

return M
