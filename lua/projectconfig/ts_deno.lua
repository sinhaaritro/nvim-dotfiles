return {
	filetypes = { "javascript", "typescript", "javascriptreact", "typescriptreact" },
	lsp = {
		server = "denols",
		settings = {
			-- Specific settings for denols, if any
		},
	},
	dap = {
		-- Example: could be something like
		-- adapter = "js-debug-adapter"
		-- configurations = {}
	},
	test = {
		-- Example: could be something like
		-- runner = "jest"
	},
}
