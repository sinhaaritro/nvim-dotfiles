-- lua/utils/project_root.lua
local M = {}

-- Function to detect the project root directory
function M.get()
	-- Try to find the Git root
	local git_root = vim.fn.systemlist("git -C " .. vim.fn.expand("%:p:h") .. " rev-parse --show-toplevel")[1]
	if vim.v.shell_error == 0 and git_root and git_root ~= "" then
		return git_root
	end
	-- Fallback to current working directory
	return vim.fn.getcwd()
end

return M
