return {
	{
		"mfussenegger/nvim-lint",
		events = { "BufWritePost", "BufReadPost", "InsertLeave" },
		dependencies = { "williamboman/mason.nvim" },
		config = function()
			local lint = require("lint")
			local mason_registry = require("mason-registry")

			-- Initialize lint.linters_by_ft as an empty table
			lint.linters_by_ft = {}

			-- Helper function to install a linter if not present
			local function install_linter(linter_name)
				if not mason_registry.is_installed(linter_name) then
					vim.notify("Installing linter: " .. linter_name, vim.log.levels.INFO)
					vim.fn.system({ "nvim", "-c", "MasonInstall " .. linter_name, "-c", "q" })
					return true -- Installation triggered
				end
				return false -- Already installed
			end

			-- Helper function to add linter to lint.linters_by_ft
			local function add_linter_to_ft(filetype, linter_name)
				lint.linters_by_ft[filetype] = lint.linters_by_ft[filetype] or {}
				if not vim.tbl_contains(lint.linters_by_ft[filetype], linter_name) then
					table.insert(lint.linters_by_ft[filetype], linter_name)
				end
			end

			-- Dynamic linter setup via FileType event
			vim.api.nvim_create_autocmd("FileType", {
				pattern = "*",
				callback = function(args)
					local ft = args.match
					local config_path = "plugins.filetypes." .. ft
					local ok, config = pcall(require, config_path)
					if not ok or not config.linter then
						return
					end

					for _, linter_name in ipairs(config.linter) do
						if install_linter(linter_name) then
							-- Delay setup to allow installation
							vim.defer_fn(function()
								mason_registry.refresh()
								add_linter_to_ft(ft, linter_name)
								vim.notify("Linter " .. linter_name .. " installed for " .. ft, vim.log.levels.INFO)
								lint.try_lint() -- Trigger linting after installation
							end, 2000)
						else
							-- Add immediately if already installed
							add_linter_to_ft(ft, linter_name)
						end
					end
				end,
			})

			-- Linting logic module
			local M = {}

			-- Debounce function to prevent excessive linting
			function M.debounce(ms, fn)
				local timer = vim.uv.new_timer()
				return function(...)
					local argv = { ... }
					timer:start(ms, 0, function()
						timer:stop()
						vim.schedule_wrap(fn)(unpack(argv))
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
					end
					return linter and not (type(linter) == "table" and linter.condition and not linter.condition(ctx))
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
