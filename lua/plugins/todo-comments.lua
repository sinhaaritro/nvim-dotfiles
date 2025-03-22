-- =============================================================================
-- Todo Comments Support                                                      --
-- =============================================================================
-- This file configures todo-comments.nvim to highlight and navigate comments --
-- in Neovim projects                                                         --
--                                                                            --
-- Plugins Used:                                                              --
-- - todo-comments.nvim (https://github.com/folke/todo-comments.nvim):        --
--          Highlights todo, notes, etc in comments                           --
-- - plenary.nvim (https://github.com/nvim-lua/plenary.nvim): Provides        --
--          utility functions for todo-comments.nvim                          --

return {
	{ -- Highlight todo, notes, etc in comments
		"folke/todo-comments.nvim",
		cmd = { "TodoTrouble", "TodoTelescope" }, -- Commands to trigger loading
		event = "VeryLazy",
		dependencies = { "nvim-lua/plenary.nvim" }, -- Required utility plugin
		opts = {
			signs = true, -- Disable signs in gutter
			keywords = {
				FIX = {
					icon = " ", -- icon used for the sign, and in search results
					color = "error", -- can be a hex color, or a named color (see below)
					alt = { "FIXME", "BUG", "FIXIT", "ISSUE" }, -- a set of other keywords that all map to this FIX keywords
					-- signs = false, -- configure signs for some keywords individually
				},
				TODO = { icon = " ", color = "info" },
				HACK = { icon = " ", color = "warning" },
				WARN = { icon = " ", color = "warning", alt = { "WARNING", "XXX" } },
				PERF = { icon = " ", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
				NOTE = { icon = " ", color = "hint", alt = { "INFO" } },
				TEST = { icon = "󰙨 ", color = "test", alt = { "TESTING", "PASSED", "FAILED" } },
				EXAMPLE = { icon = "󰖌 ", color = "info" },
			},
			colors = {
				error = { "DiagnosticError", "ErrorMsg", "#DC2626" },
				warning = { "DiagnosticWarn", "WarningMsg", "#FBBF24" },
				info = { "DiagnosticInfo", "#2563EB" },
				hint = { "DiagnosticHint", "#10B981" },
				default = { "Identifier", "#7C3AED" },
				test = { "Identifier", "#FF00FF" },
			},
		},
    -- stylua: ignore
    keys = {
      { "]t", function() require("todo-comments").jump_next() end, desc = "Next Todo Comment" },
      { "[t", function() require("todo-comments").jump_prev() end, desc = "Previous Todo Comment" },
      { "<leader>xt", "<cmd>Trouble todo toggle<cr>", desc = "Todo (Trouble)" },
      { "<leader>xT", "<cmd>Trouble todo toggle filter = {tag = {TODO,FIX,FIXME}}<cr>", desc = "Todo/Fix/Fixme (Trouble)" },
      { "<leader>st", "<cmd>TodoTelescope<cr>", desc = "Todo" },
      { "<leader>sT", "<cmd>TodoTelescope keywords=TODO,FIX,FIXME<cr>", desc = "Todo/Fix/Fixme" },
    },
	},
}
