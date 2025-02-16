return {
	{
		"williamboman/mason.nvim",
		cmd = "Mason",
		event = { "BufReadPre", "BufNewFile" },
		lazy = false,
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
