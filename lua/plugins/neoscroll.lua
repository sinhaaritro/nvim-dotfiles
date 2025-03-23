return {
	{ --Smooth scrolling
		"karb94/neoscroll.nvim",
		enabled = true,
		event = { "BufReadPre", "BufNewFile" },
		opts = {},
		config = function()
			local neoscroll = require("neoscroll")
			local keymap = {
				-- scroll half page
				["<C-u>"] = function()
					neoscroll.ctrl_u({ duration = 50 })
				end,
				["<C-d>"] = function()
					neoscroll.ctrl_d({ duration = 50 })
				end,
				-- scroll full page
				["<C-b>"] = function()
					neoscroll.ctrl_b({ duration = 100 })
				end,
				["<C-f>"] = function()
					neoscroll.ctrl_f({ duration = 100 })
				end,
				-- scroll few lines
				["<C-y>"] = function()
					neoscroll.scroll(-0.1, { move_cursor = false, duration = 100 })
				end,
				["<C-e>"] = function()
					neoscroll.scroll(0.1, { move_cursor = false, duration = 100 })
				end,
				-- scroll cursor to top/middle/buttom
				["zt"] = function()
					neoscroll.zt({ half_win_duration = 50 })
				end,
				["zz"] = function()
					neoscroll.zz({ half_win_duration = 50 })
				end,
				["zb"] = function()
					neoscroll.zb({ half_win_duration = 50 })
				end,
			}
			local modes = { "n", "v", "x" }
			for key, func in pairs(keymap) do
				vim.keymap.set(modes, key, func)
			end
		end,
	},
}
