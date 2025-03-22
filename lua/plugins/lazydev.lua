-- =============================================================================
-- Neovim Development Support                                                --
-- =============================================================================
-- This file configures lazydev.nvim for Neovim development projects          --
-- when 'neovimdev' is specified in projectconfig.lua                         --
--                                                                            --
-- Plugins Used:                                                              --
-- - lazydev.nvim (https://github.com/folke/lazydev.nvim): Enhances LuaLS for --
--          Neovim config development                                         --

return {
	{
		"folke/lazydev.nvim",
		ft = "lua", -- Only load on Lua files
		opts = {
			library = {
				-- Only load luvit types when `vim.uv` is found
				{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
				-- Only load LazyVim library when `LazyVim` global is found
				{ path = "LazyVim", words = { "LazyVim" } },
				-- Load wezterm types when `wezterm` module is required
				{ path = "wezterm-types", mods = { "wezterm" } },
				-- Load xmake types when opening `xmake.lua`
				{ path = "xmake-luals-addon/library", files = { "xmake.lua" } },
			},
		},
		-- NOTE: Enable only if neovimdev is in projectconfig.lua
		enabled = function()
			-- Helper function to check if a value exists in a table
			local function has_value(tab, val)
				for _, v in ipairs(tab) do
					if v == val then
						return true
					end
				end
				return false
			end

			-- Check for projectconfig.lua in current working directory
			local project_config_path = vim.fn.getcwd() .. "/projectconfig.lua"
			local project_config = nil
			-- File readable check
			if vim.fn.filereadable(project_config_path) == 1 then
				project_config = dofile(project_config_path)
			end

			-- Check if 'neovimdev' is in projectconfig.lua
			local has_neovimdev = project_config
				and project_config.projecttype
				and has_value(project_config.projecttype, "neovimdev")
			-- Enable if either no config or neovimdev present
			return (not project_config or has_neovimdev)
		end,
	},
}
