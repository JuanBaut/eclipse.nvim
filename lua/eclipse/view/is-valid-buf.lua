local config = require("eclipse.config")

local M = {}

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

return M
