local M = {}

function M.on_win_enter()
	local current = vim.api.nvim_get_current_win()

	for _, win in ipairs(vim.api.nvim_list_wins()) do
		-- Skip the window we just switched from
		if win ~= current then
			-- Always update dimming for external windows
			M.update(win)
		end
	end

	-- Optional update for the current window (might not be needed)
	M.update()
end

return M
