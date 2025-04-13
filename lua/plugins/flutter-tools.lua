return {
	{
		"nvim-flutter/flutter-tools.nvim",
		-- NOTE: Enable only if neovimdev is in projectconfig.lua
		enabled = function()
			if not vim.g.vscode then
				return false
			end
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
			local config_dir = vim.fn.stdpath("config")
			local project_config_path = config_dir .. "/projectconfig.lua"
			local project_config = nil
			-- File readable check
			if vim.fn.filereadable(project_config_path) == 1 then
				project_config = dofile(project_config_path)
			end

			-- Check if 'neovimdev' is in projectconfig.lua
			local has_neovimdev = project_config
				and project_config.projecttype
				and has_value(project_config.projecttype, "flutter")
			-- Enable if either no config or neovimdev present
			return (not project_config or has_neovimdev)
		end,

		event = "VeryLazy",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"stevearc/dressing.nvim", -- optional for vim.ui.select
		},
		config = function()
			require("flutter-tools").setup({
				-- flutter_path = nil,
				flutter_lookup_cmd = "dirname $(which flutter)",
				fvm = false,
				widget_guides = { enabled = true },
				lsp = {
					settings = {
						showtodos = true,
						completefunctioncalls = true,
						analysisexcludedfolders = {
							vim.fn.expand("$Home/.pub-cache"),
						},
						renamefileswithclasses = "prompt",
						updateimportsonrename = true,
						enablesnippets = true,
					},
				},
				debugger = {
					enabled = true,
					run_via_dap = true,
					exception_breakpoints = {},
					register_configurations = function(paths)
						local dap = require("dap")
						-- See also: https://github.com/akinsho/flutter-tools.nvim/pull/292
						dap.adapters.dart = {
							type = "executable",
							command = paths.flutter_bin,
							args = { "debug-adapter" },
						}
						dap.configurations.dart = {}
						require("dap.ext.vscode").load_launchjs()
					end,
				},
			})
		end,
	},
}
