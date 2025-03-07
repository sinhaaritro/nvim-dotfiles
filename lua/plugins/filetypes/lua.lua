return {
	lsp = {
		server = "lua_ls",
		settings = {
			cmd = { "lua-language-server" },
			filetypes = { "lua" },
			settings = {
				Lua = {
					completion = {
						callSnippet = "Replace",
					},
					diagnostics = {
						globals = { "vim", "require" },
					},
					workspace = {
						library = vim.api.nvim_get_runtime_file("", true),
					},
					telemetry = {
						enable = false,
					},
				},
			},
		},
	},
	formatter = {
		formatters = { "stylua" },
	},
	linter = {
		-- Example: could be something like
		-- linters = { "luacheck" }
	},
	dap = {
		-- Example: could be something like
		-- adapter = "lua-dap"
		-- configurations = {}
	},
	test = {
		-- Example: could be something like
		-- runner = "busted"
	},
}
