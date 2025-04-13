return {
	{ --Smooth scrolling
		"karb94/neoscroll.nvim",
		enabled = not vim.g.vscode,
		event = { "BufReadPost" },
		keys = {
			-- Scroll half page
			{
				"<C-u>",
				function()
					require("neoscroll").ctrl_u({ duration = 50 })
				end,
				mode = { "n", "v", "x" },
				desc = "Scroll half page up",
			},
			{
				"<C-d>",
				function()
					require("neoscroll").ctrl_d({ duration = 50 })
				end,
				mode = { "n", "v", "x" },
				desc = "Scroll half page down",
			},
			-- Scroll full page
			{
				"<C-b>",
				function()
					require("neoscroll").ctrl_b({ duration = 100 })
				end,
				mode = { "n", "v", "x" },
				desc = "Scroll full page up",
			},
			{
				"<C-f>",
				function()
					require("neoscroll").ctrl_f({ duration = 100 })
				end,
				mode = { "n", "v", "x" },
				desc = "Scroll full page down",
			},
			-- Scroll few lines
			{
				"<C-y>",
				function()
					require("neoscroll").scroll(-0.1, { move_cursor = false, duration = 100 })
				end,
				mode = { "n", "v", "x" },
				desc = "Scroll few lines up",
			},
			{
				"<C-e>",
				function()
					require("neoscroll").scroll(0.1, { move_cursor = false, duration = 100 })
				end,
				mode = { "n", "v", "x" },
				desc = "Scroll few lines down",
			},
			-- Scroll cursor to top/middle/bottom
			{
				"zt",
				function()
					require("neoscroll").zt({ half_win_duration = 50 })
				end,
				mode = { "n", "v", "x" },
				desc = "Scroll cursor to top",
			},
			{
				"zz",
				function()
					require("neoscroll").zz({ half_win_duration = 50 })
				end,
				mode = { "n", "v", "x" },
				desc = "Scroll cursor to middle",
			},
			{
				"zb",
				function()
					require("neoscroll").zb({ half_win_duration = 50 })
				end,
				mode = { "n", "v", "x" },
				desc = "Scroll cursor to bottom",
			},
		},
	},
}
