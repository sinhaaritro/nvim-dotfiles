return {
	{
		"williamboman/mason.nvim",
		enabled = not vim.g.vscode,
		cmd = "Mason",
		event = { "BufReadPost" },
		keys = { { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" } },
		build = ":MasonUpdate",
		-- NOTE: `opts = {}` is the same as calling `require('mason').setup({})`
		opts = {
			ui = {
				icons = {
					package_installed = "✓",
					package_pending = "➜",
					package_uninstalled = "✗",
				},
			},
		},
	},
}
