local M = {}

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

return M
