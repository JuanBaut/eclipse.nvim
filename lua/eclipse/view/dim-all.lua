local M = {}

-- Add a new function to dim all lines in a window
function M.dim_all(buf, win)
	local start, stop = vim.api.nvim_buf_line_count(buf), 0
	for lnum = start, stop, -1 do
		M.dim(buf, lnum - 1, win)
	end
end

-- Modify the M.dim function to accept a window parameter
function M.dim(buf, lnum, win)
	-- Use extmarks directly so we can set the priority
	-- Do a pcall instead to prevent spurious errors at the end of the doc
	pcall(vim.api.nvim_buf_set_extmark, buf, ns, lnum, 0, {
		end_line = lnum + 1,
		end_col = 0,
		hl_group = "Twilight",
		hl_eol = true,
		priority = 10000,
		win = win, -- Set the window for the extmark
	})
end

return M
