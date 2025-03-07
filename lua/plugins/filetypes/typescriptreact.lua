return {
	lsp = {
		server = "ts_ls",
		settings = {
			cmd = { "typescript-language-server", "--stdio" },
			filetypes = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
			settings = {
				typescript = {
					inlayHints = {
						includeInlayParameterNameHints = "all",
						includeInlayParameterNameHintsWhenArgumentMatchesName = false,
						includeInlayFunctionParameterTypeHints = true,
						includeInlayVariableTypeHints = true,
						includeInlayPropertyDeclarationTypeHints = true,
						includeInlayFunctionLikeReturnTypeHints = true,
						includeInlayEnumMemberValueHints = true,
					},
				},
			},
		},
	},
	formatter = {
		formatters = { "prettier" },
	},
	linter = {
		-- Example: could be something like
		-- linters = { "eslint" }
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
