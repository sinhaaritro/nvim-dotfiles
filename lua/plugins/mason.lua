return {
	{
		"williamboman/mason.nvim",
		enabled = true,
		cmd = "Mason",
		event = { "BufReadPre", "BufNewFile" },
		keys = { { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" } },
		build = ":MasonUpdate",
		lazy = true,
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
