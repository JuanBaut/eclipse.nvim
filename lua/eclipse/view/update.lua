local M = {}

function M.update(win)
	win = win or vim.api.nvim_get_current_win()
	if not M.enabled or not vim.api.nvim_win_is_valid(win) then
		return false
	end
	local buf = vim.api.nvim_win_get_buf(win)
	if not M.is_valid_buf(buf) then
		return
	end

	-- Clear any existing dimming in the current window
	M.clear(buf)

	-- Dim all lines in other windows displaying the same buffer
	for _, other in ipairs(vim.api.nvim_list_wins()) do
		if other ~= win and vim.api.nvim_win_get_buf(other) == buf then
			M.dim_all(buf, other)
		end
	end
end

return M
