return {
	{
		"ThePrimeagen/harpoon",
		branch = "harpoon2",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = {
			menu = {
				width = vim.api.nvim_win_get_width(0) - 4,
			},
			settings = {
				save_on_toggle = true,
			},
		},
		keys = {
			{
				"<leader><C-h>",
				function()
					local harpoon = require("harpoon")
					harpoon.ui:toggle_quick_menu(harpoon:list())
				end,
				desc = "List locations",
			},

			-- Add and remove file from list
			{
				"<leader>H",
				function()
					require("harpoon"):list():add()
				end,
				desc = "Add Location",
			},
			{
				"<leader>mr",
				function()
					require("harpoon"):list():remove()
				end,
				desc = "Remove Location",
			},

			-- Toggle previous & next buffers stored within Harpoon list
			{
				"<C-n>",
				function()
					require("harpoon"):list():next()
				end,
				desc = "Next Location",
			},
			{
				"<C-p>",
				function()
					require("harpoon"):list():prev()
				end,
				desc = "Previous Location",
			},

			-- File selection
			{
				"<leader>ha",
				function()
					require("harpoon"):list():select(1)
				end,
				desc = "Harpoon to File 1",
			},
			{
				"<leader>hs",
				function()
					require("harpoon"):list():select(2)
				end,
				desc = "Harpoon to File 2",
			},
			{
				"<leader>hd",
				function()
					require("harpoon"):list():select(3)
				end,
				desc = "Harpoon to File 3",
			},
			{
				"<leader>hf",
				function()
					require("harpoon"):list():select(4)
				end,
				desc = "Harpoon to File 4",
			},
			{
				"<leader>hg",
				function()
					require("harpoon"):list():select(5)
				end,
				desc = "Harpoon to File 5",
			},
		},
		-- config = function()
		-- 	local harpoon = require("harpoon")

		-- 	-- REQUIRED
		-- 	harpoon:setup()
		-- 	-- REQUIRED

		-- 	vim.keymap.set("n", "<C-e>", function()
		-- 		harpoon.ui:toggle_quick_menu(harpoon:list())
		-- 	end)
		-- end,
	},
}
