return {
	filetypes = { "javascript", "typescript", "javascriptreact", "typescriptreact" },
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
	linter = { "eslint_d" },
	dap = {
		ensure_installed = { "js" },
		adapter = {
			name = "pwa-node",
			config = {
				type = "server",
				host = "localhost",
				port = "${port}",
				executable = {
					command = "node",
					args = {
						vim.fn.stdpath("data") .. "/mason/packages/js-debug-adapter/js-debug/src/dapDebugServer.js",
						"${port}",
					},
				},
			},
		},
		-- configurations = {
		-- 	{
		-- 		type = "pwa-node",
		-- 		request = "launch",
		-- 		name = "Launch file",
		-- 		program = "${file}",
		-- 		cwd = "${workspaceFolder}",
		-- 	},
		-- },
	},
	test = {
		adapter = "marilari88/neotest-vitest",
	},
}
