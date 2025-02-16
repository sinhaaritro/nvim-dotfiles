return {
	{ -- bufferline for Neovim
		"akinsho/bufferline.nvim",
		enabled = not vim.g.started_by_firenvim,
		-- stylua: ignore
		keys = {
			{ '<S-h>', false },
			{ '<S-l>', false },
			{ '<leader>tp', '<Cmd>BufferLinePick<CR>', desc = '[T]ab [P]ick' },
		},
		opts = {
			options = {
				mode = "tabs",
				separator_style = "slant",
				show_close_icon = false,
				show_buffer_close_icons = false,
				always_show_bufferline = true,
				custom_areas = {
					right = function()
						local result = {}
						local root = LazyVim.root()
						table.insert(result, {
							text = "%#BufferLineTab# " .. vim.fn.fnamemodify(root, ":t"),
						})

						-- Session indicator
						if vim.v.this_session ~= "" then
							table.insert(result, { text = "%#BufferLineTab#  " })
						end
						return result
					end,
				},
				offsets = {
					{
						filetype = "neo-tree",
						text = "Neo-tree",
						highlight = "Directory",
						text_align = "center",
					},
				},
			},
		},
	},
}
