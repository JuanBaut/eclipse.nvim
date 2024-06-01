local config = require("eclipse.config")

local M = {}

local ns = vim.api.nvim_create_namespace("eclipse")

M.enabled = false

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

function M.disable()
	if M.enabled then
		M.enabled = false
		pcall(vim.cmd, "autocmd! Eclipse")
		pcall(vim.cmd, "augroup! Eclipse")
		for _, buf in pairs(vim.api.nvim_list_bufs()) do
			if vim.api.nvim_buf_is_valid(buf) then
				M.clear(buf)
			end
		end
	end
end

function M.toggle()
	if M.enabled then
		M.disable()
	else
		M.enable()
	end
end

function M.clear(buf, from, to)
	from = from or 0
	to = to or -1
	if from < 0 then
		from = 0
	end
	vim.api.nvim_buf_clear_namespace(buf, ns, from, to)
end

function M.dim(buf, lnum)
	-- use extmarks directly so we can set the priority
	-- do a pcall instead to prevent spurious errors at the end of the doc
	pcall(vim.api.nvim_buf_set_extmark, buf, ns, lnum, 0, {
		end_line = lnum + 1,
		end_col = 0,
		hl_group = "Eclipse",
		hl_eol = true,
		priority = 10000,
	})
	-- vim.api.nvim_buf_add_highlight(buf, ns, "Eclipse", lnum, 0, -1)
end

function M.is_empty(buf, line)
	local lines = vim.api.nvim_buf_get_lines(buf, line, line + 1, false)
	if vim.fn.trim(lines[1]) == "" then
		return true
	end
	return false
end

function M.is_valid_buf(buf)
	-- Skip special buffers
	local buftype = vim.api.nvim_buf_get_option(buf, "buftype")
	if buftype ~= "" then
		return false
	end
	local filetype = vim.api.nvim_buf_get_option(buf, "filetype")
	if vim.tbl_contains(config.options.exclude, filetype) then
		return false
	end
	return true
end

function M.update(win)
	win = win or vim.api.nvim_get_current_win()

	if not M.enabled or not vim.api.nvim_win_is_valid(win) then
		return false
	end
	local buf = vim.api.nvim_win_get_buf(win)
	if not M.is_valid_buf(buf) then
		return
	end
	local cursor = vim.api.nvim_win_get_cursor(win)
	local from, to = M.get_context(buf, cursor[1] - 1)

	local dimmers = {}
	M.focus(win, from, to, dimmers)

	for _, other in ipairs(vim.api.nvim_list_wins()) do
		if other ~= win and vim.api.nvim_win_get_buf(other) == buf then
			M.focus(other, from, to, dimmers)
		end
	end

	M.clear(buf, from - 1, to - 1)

	for lnum, _ in pairs(dimmers) do
		M.dim(buf, lnum - 1)
	end
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
