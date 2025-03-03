return {
	{
		"L3MON4D3/LuaSnip",
		-- version = "2.*", -- If you want to pin a specific version
		event = "InsertEnter", -- Load on InsertEnter, you can change this to "VeryLazy" for faster startup
		dependencies = {
			"rafamadriz/friendly-snippets", -- Optional: Provides a lot of pre-made snippets
		},
		config = function()
			-- require("luasnip.loaders.from_vscode").lazy_load() -- Load VSCode-style snippets if you have them
			require("luasnip.loaders.from_lua").lazy_load({ paths = "~/.config/nvim/snippets" }) -- Load LuaSnip snippets from this directory

			local ls = require("luasnip")
			vim.keymap.set({ "i", "s" }, "<C-l>", function()
				if ls.expand_or_jumpable(1) then
					ls.expand_or_jump(1)
				end
			end, { silent = true })

			vim.keymap.set({ "i", "s" }, "<C-h>", function()
				if ls.jumpable(-1) then
					ls.jump(-1)
				end
			end, { silent = true })
			vim.keymap.set({ "i", "s" }, "<C-j>", function()
				if ls.choice_active(1) then
					ls.change_choice(1)
				end
			end, { silent = true })

			vim.keymap.set({ "i", "s" }, "<C-k>", function()
				if ls.choice_active(-1) then
					ls.change_choice(-1)
				end
			end, { silent = true })
		end,
	},
}
