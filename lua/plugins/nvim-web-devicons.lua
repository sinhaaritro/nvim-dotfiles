return {
	{ -- Useful for getting pretty icons, but requires a Nerd Font.
		"nvim-tree/nvim-web-devicons",
		enabled = not vim.g.vscode and vim.g.have_nerd_font,

		opts = {},
	},
}
