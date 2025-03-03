return {
	{
		"jiaoshijie/undotree",
		event = "VeryLazy",
		dependencies = "nvim-lua/plenary.nvim",
		config = true,
		keys = { -- load the plugin only when using it's keybinding:
			{ "<leader>u", "<cmd>lua require('undotree').toggle()<cr>", desc = "[U]ndo tree" },
		},
	},
}
