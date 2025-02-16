return {
	{ -- Neo-tree is a Neovim plugin to browse the file system
		"nvim-neo-tree/neo-tree.nvim",
		version = "*",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
			"MunifTanjim/nui.nvim",
		},
		cmd = "Neotree",
		-- lazy = false,
		init = function()
			vim.api.nvim_create_autocmd("BufEnter", {
				-- make a group to be able to delete it later
				group = vim.api.nvim_create_augroup("NeoTreeInit", { clear = true }),
				callback = function()
					local f = vim.fn.expand("%:p")
					if vim.fn.isdirectory(f) ~= 0 then
						vim.cmd("Neotree current dir=" .. f)
						-- neo-tree is loaded now, delete the init autocmd
						vim.api.nvim_clear_autocmds({ group = "NeoTreeInit" })
					end
				end,
			})
			-- keymaps
		end,
		keys = {
			{ "\\", ":Neotree reveal<CR>", desc = "NeoTree reveal", silent = true },
		},
		opts = {
			enable_git_status = true,
			close_if_last_window = true,
			filesystem = {
				filtered_items = {
					visible = true, -- This is what you want: If you set this to `true`, all "hide" just mean "dimmed out"
					hide_dotfiles = false,
					hide_gitignored = true,
				},
				window = {
					mappings = {
						["\\"] = "close_window",
					},
				},
			},
		},
	},
}
