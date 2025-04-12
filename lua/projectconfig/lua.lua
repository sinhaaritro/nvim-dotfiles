return {
	filetypes = { "lua" },
	formatter = {
		formatters = { "stylua" },
	},
	linter = { "luacheck" },
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
