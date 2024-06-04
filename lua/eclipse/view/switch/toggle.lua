local M = {}

function M.toggle()
	if M.enabled then
		M.disable()
	else
		M.enable()
	end
end

function M.is_empty(buf, line)
	local lines = vim.api.nvim_buf_get_lines(buf, line, line + 1, false)
	if vim.fn.trim(lines[1]) == "" then
		return true
	end
	return false
end

return M
