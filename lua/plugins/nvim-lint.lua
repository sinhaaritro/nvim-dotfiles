-- =============================================================================
-- Linting Configuration Manager                                              --
-- =============================================================================
-- This file configures nvim-lint to set up linters based on project types    --
-- defined in projectconfig.lua and configs in lua/projectconfig              --
--                                                                            --
-- Plugins Used:                                                              --
-- - nvim-lint (https://github.com/mfussenegger/nvim-lint): Provides linting  --
--          support for Neovim                                                --
-- - mason.nvim (https://github.com/williamboman/mason.nvim): Manages linter  --
--          installations                                                     --

return {
	{
		"mfussenegger/nvim-lint",
		lazy = true,
		events = { "BufWritePost" },
		dependencies = { "williamboman/mason.nvim" },
		config = function()
			-- Load required modules
			local lint = require("lint")
			local mason_registry = require("mason-registry")
			local project_config = require("utils.project_config")

			-- Initialize lint.linters_by_ft
			lint.linters_by_ft = {}

			-- Load project configurations
			local projecttype_configs = project_config.load_configs()

			-- Function to set up linter when installed
			local function setup_linter_when_installed(linter_name, filetypes)
				if mason_registry.is_installed(linter_name) then
					for _, ft in ipairs(filetypes) do -- Add linter to all filetypes
						lint.linters_by_ft[ft] = lint.linters_by_ft[ft] or {}
						if not vim.tbl_contains(lint.linters_by_ft[ft], linter_name) then
							table.insert(lint.linters_by_ft[ft], linter_name)
						end
					end
					vim.notify(
						"Linter " .. linter_name .. " set up for " .. table.concat(filetypes, ", "),
						vim.log.levels.INFO
					)
					lint.try_lint() -- Trigger linting
				else
					vim.notify("Waiting for " .. linter_name .. " to install...", vim.log.levels.INFO)
					vim.defer_fn(function() -- Poll every 1 second
						setup_linter_when_installed(linter_name, filetypes)
					end, 1000)
				end
			end

			-- NOTE: Set up linters based on active project types
			for _, config in pairs(projecttype_configs) do
				if config.linter then -- Check if linter exists (no type restriction)
					local linters = type(config.linter) == "table" and config.linter or { config.linter }
					local filetypes = config.filetypes
					for _, linter_name in ipairs(linters) do
						if not mason_registry.is_installed(linter_name) then
							vim.notify("Installing linter: " .. linter_name, vim.log.levels.INFO)
							require("mason.api.command").MasonInstall({ linter_name })
							setup_linter_when_installed(linter_name, filetypes)
						else
							for _, ft in ipairs(filetypes) do
								lint.linters_by_ft[ft] = lint.linters_by_ft[ft] or {}
								if not vim.tbl_contains(lint.linters_by_ft[ft], linter_name) then
									table.insert(lint.linters_by_ft[ft], linter_name)
								end
							end
						end
					end
				end
			end

			-- Linting logic module
			local M = {}

			-- Debounce function to prevent excessive linting
			function M.debounce(ms, fn)
				local timer = vim.uv.new_timer()
				if not timer then
					vim.notify("Failed to create timer", vim.log.levels.WARN)
					return function() end -- Return a no-op function
				end
				local unpack_fn = table.unpack or unpack -- Fallback to unpack
				return function(...)
					local argv = { ... }
					timer:start(ms, 0, function()
						timer:stop()
						vim.schedule_wrap(fn)(unpack_fn(argv))
					end)
				end
			end

			-- Core linting function
			function M.lint()
				local names = lint._resolve_linter_by_ft(vim.bo.filetype)
				names = vim.list_extend({}, names)
				if #names == 0 then
					vim.list_extend(names, lint.linters_by_ft["_"] or {})
				end
				vim.list_extend(names, lint.linters_by_ft["*"] or {})
				local ctx = { filename = vim.api.nvim_buf_get_name(0) }
				ctx.dirname = vim.fn.fnamemodify(ctx.filename, ":h")
				names = vim.tbl_filter(function(name)
					local linter = lint.linters[name]
					if not linter then
						vim.notify("Linter not found: " .. name, vim.log.levels.WARN, { title = "nvim-lint" })
						return false
					end
					if type(linter) == "table" then
						local condition = linter.condition -- Assign to a local variable
						if condition then
							return condition(ctx) -- Call it only if it exists
						else
							return true -- No condition, include the linter
						end
					end
					return true -- Not a table, include linter
				end, names)
				if #names > 0 then
					lint.try_lint(names)
				end
			end

			-- Set up linting triggers with debounce
			vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
				group = vim.api.nvim_create_augroup("nvim-lint", { clear = true }),
				callback = M.debounce(100, M.lint),
			})

			-- Optional: LintInfo command for debugging
			vim.api.nvim_create_user_command("LintInfo", function()
				local filetype = vim.bo.filetype
				local linters = lint.linters_by_ft[filetype] or {}
				if #linters > 0 then
					print("Linters for " .. filetype .. ": " .. table.concat(linters, ", "))
				else
					print("No linters configured for filetype: " .. filetype)
				end
			end, {})
		end,
	},
}
