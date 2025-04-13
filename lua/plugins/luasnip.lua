return {
	{
		"L3MON4D3/LuaSnip",
		enabled = not vim.g.vscode,
		event = { "InsertEnter" }, -- Load on InsertEnter, you can change this to "VeryLazy" for faster startup
		dependencies = {
			"rafamadriz/friendly-snippets", -- Optional: Provides a lot of pre-made snippets
		},
		keys = {
			{
				"<C-l>",
				function()
					local ls = require("luasnip")
					if ls.expand_or_jumpable(1) then
						ls.expand_or_jump(1)
					end
				end,
				mode = { "i", "s" },
				desc = "Expand snippet or jump forward",
				silent = true,
			},
			{
				"<C-h>",
				function()
					local ls = require("luasnip")
					if ls.jumpable(-1) then
						ls.jump(-1)
					end
				end,
				mode = { "i", "s" },
				desc = "Jump backward in snippet",
				silent = true,
			},
			{
				"<C-j>",
				function()
					local ls = require("luasnip")
					if ls.choice_active(1) then
						ls.change_choice(1)
					end
				end,
				mode = { "i", "s" },
				desc = "Next snippet choice",
				silent = true,
			},
			{
				"<C-k>",
				function()
					local ls = require("luasnip")
					if ls.choice_active(-1) then
						ls.change_choice(-1)
					end
				end,
				mode = { "i", "s" },
				desc = "Previous snippet choice",
				silent = true,
			},
		},
		config = function()
			require("luasnip.loaders.from_vscode").lazy_load() -- Load VSCode-style snippets if you have them
			require("luasnip.loaders.from_lua").lazy_load({ paths = { "~/.config/nvim/snippets" } }) -- Load LuaSnip snippets from this directory
		end,
	},
}
