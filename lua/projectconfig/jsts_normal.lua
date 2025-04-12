return {
	filetypes = { "javascript", "typescript", "javascriptreact", "typescriptreact" },
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
