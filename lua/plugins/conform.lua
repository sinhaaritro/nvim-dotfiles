return {
	{ -- Autoformat
		"stevearc/conform.nvim",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = { "williamboman/mason.nvim" },
		cmd = "ConformInfo",
		keys = {
			{
				"<leader>cf",
				function()
					require("conform").format({ async = true, lsp_format = "fallback" })
				end,
				mode = { "n", "v" },
				desc = "[C]ode [F]ormat",
			},
		},
		config = function()
			local conform = require("conform")
			local mason_registry = require("mason-registry")

			-- Basic setup for conform.nvim
			conform.setup({
				notify_on_error = false,
				format_on_save = function(bufnr)
					local disable_filetypes = { c = true, cpp = true }
					local lsp_format_opt
					if disable_filetypes[vim.bo[bufnr].filetype] then
						lsp_format_opt = "never"
					else
						lsp_format_opt = "fallback"
					end
					return {
						timeout_ms = 500,
						lsp_format = lsp_format_opt,
					}
				end,
			})

			-- Dynamic formatter setup via FileType event
			vim.api.nvim_create_autocmd("FileType", {
				pattern = "*",
				callback = function(args)
					local ft = args.match
					local config_path = "plugins.filetypes." .. ft
					local ok, config = pcall(require, config_path)
					if not ok or not config.formatter then
						return
					end

					local formatters = config.formatter.formatters
					local options = config.formatter.options or {}

					-- Check and install formatters if not present
					for _, formatter_name in ipairs(formatters) do
						if not mason_registry.is_installed(formatter_name) then
							vim.notify("Installing formatter: " .. formatter_name, vim.log.levels.INFO)
							vim.fn.system({ "nvim", "-c", "MasonInstall " .. formatter_name, "-c", "q" })
							-- Installation is asynchronous; user may need to wait before formatting
						end
					end

					-- Create entry for formatters_by_ft
					local entry = {}
					for i, fmt in ipairs(formatters) do
						entry[i] = fmt
					end
					for k, v in pairs(options) do
						entry[k] = v
					end
					conform.formatters_by_ft[ft] = entry
				end,
			})

			-- FormatterInfo command
			vim.api.nvim_create_user_command("FormatterInfo", function()
				local filetype = vim.bo.filetype
				local formatters_entry = conform.formatters_by_ft[filetype]
				if formatters_entry then
					local formatters = {}
					for i = 1, #formatters_entry do
						table.insert(formatters, formatters_entry[i])
					end
					local opts_str = ""
					if formatters_entry.stop_after_first then
						opts_str = " (stop_after_first = true)"
					end
					print("Formatters for " .. filetype .. ": " .. table.concat(formatters, ", ") .. opts_str)
				else
					print("No formatters configured for filetype: " .. filetype)
				end
			end, {})
		end,
	},
}
