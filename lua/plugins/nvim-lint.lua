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

			-- Load filetypeconfig.lua from the root of the config directory
			local config_dir = vim.fn.stdpath("config")
			local filetypeconfig_path = config_dir .. "/filetypeconfig.lua"
			local filetypeconfig = dofile(filetypeconfig_path) or { active_filetypes = {} }
			local active_filetypes = filetypeconfig.active_filetypes or {}

			-- Collect linter configurations and track missing files
			local filetype_configs = {}
			local missing_files = {}

			for _, ft in ipairs(active_filetypes) do
				local filepath = config_dir .. "/lua/filetypes/" .. ft .. ".lua"
				if vim.fn.filereadable(filepath) == 1 then
					local config = require("filetypes." .. ft)
					filetype_configs[ft] = config
				else
					table.insert(missing_files, ft)
				end
			end

			-- Display a single warning for all missing files, if any
			if #missing_files > 0 then
				local warning_msg = "Warning: The following filetype configurations were not found: "
					.. table.concat(missing_files, ", ")
				vim.notify(warning_msg, vim.log.levels.WARN)
			end

			-- Function to poll and set up linter when installed
			local function setup_linter_when_installed(linter_name, filetypes)
				if mason_registry.is_installed(linter_name) then
					-- Add linter to lint.linters_by_ft for all filetypes
					for _, ft in ipairs(filetypes) do
						lint.linters_by_ft[ft] = lint.linters_by_ft[ft] or {}
						if not vim.tbl_contains(lint.linters_by_ft[ft], linter_name) then
							table.insert(lint.linters_by_ft[ft], linter_name)
						end
					end
					vim.notify(
						"Linter " .. linter_name .. " set up for " .. table.concat(filetypes, ", "),
						vim.log.levels.INFO
					)
					lint.try_lint() -- Trigger linting after setup
				else
					vim.notify("Waiting for linter: " .. linter_name .. " to install...", vim.log.levels.INFO)
					vim.defer_fn(function()
						setup_linter_when_installed(linter_name, filetypes)
					end, 1000) -- Recheck every 1 second
				end
			end

			-- Set up linters based on active filetype configurations
			for _, config in pairs(filetype_configs) do
				-- Only proceed if linter field exists and is a table
				if config.linter and type(config.linter) == "table" then
					local linters = config.linter
					local filetypes = config.filetypes -- Use all filetypes from the config

					for _, linter_name in ipairs(linters) do
						if not mason_registry.is_installed(linter_name) then
							-- Notify and install the linter
							vim.notify("Installing linter: " .. linter_name, vim.log.levels.INFO)
							require("mason.api.command").MasonInstall({ linter_name })
							setup_linter_when_installed(linter_name, filetypes)
						else
							-- If already installed, set up immediately for all filetypes
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
				return function(...)
					local argv = { ... }
					timer:start(ms, 0, function()
						timer:stop()
						vim.schedule_wrap(fn)(table.unpack(argv))
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
