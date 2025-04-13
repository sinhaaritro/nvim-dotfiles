-- =============================================================================
-- Keybinding Helper                                                          --
-- =============================================================================
-- This file configures which-key.nvim to display and organize keybindings    --
-- in Neovim for improved usability                                           --
--                                                                            --
-- Plugins Used:                                                              --
-- - which-key.nvim (https://github.com/folke/which-key.nvim): Displays and   --
--          organizes keybindings with a popup menu                           --

return {
	{
		"folke/which-key.nvim",
		enabled = not vim.g.vscode,
		event = "VeryLazy",
		opts = {
			preset = "modern",
			delay = 0,
			spec = {
				{ "<leader>b", group = "[B]uffer", mode = { "n", "x" }, icon = " " },
				{ "<leader>c", group = "[C]ode", mode = { "n", "x" }, icon = " " },
				{ "<leader>d", group = "[D]ebug", mode = { "n", "x" }, icon = " " },
				{ "<leader>f", group = "[F]ind", mode = { "n" }, icon = " " },
				{ "<leader>g", group = "[G]it", mode = { "n", "x" }, icon = " " },
				{ "<leader>h", group = "[H]arpoon", mode = { "n" }, icon = " " },
				{ "<leader>q", group = "[Q]uit", mode = { "n" }, icon = "󰆓 " },
				{ "<leader>r", group = "[R]ename", icon = "󰑕 " },
				{ "<leader>s", group = "[S]earch", mode = { "n", "x" }, icon = " " },
				{ "<leader>t", group = "[T]est", mode = { "n", "x" }, icon = "󰙨 " },
				{ "<leader>T", group = "[T]erminal", mode = { "n" }, icon = " " },
				{ "<leader>u", group = "[U]i", mode = { "n", "x" }, icon = "  " },
				{ "<leader>w", group = "[W]indows", icon = " " },
				{ "<leader>x", group = "[]Diagonastic", icon = "󰝖 " },
				{ "<leader><Tab>", group = "[Tabs]", icon = "󰓩 " },
				-- { "<leader>h", group = "Git [H]unk", mode = { "n", "v" } },
			},
			-- show a warning when issues were detected with your mappings
			notify = true,
			icons = {
				breadcrumb = "»", -- symbol used in the command line area that shows your active key combo
				separator = "➜", -- symbol used between a key and it's label
				group = "+", -- symbol prepended to a group
				ellipsis = "…",
				-- set to false to disable all mapping icons,
				-- both those explicitly added in a mapping
				-- and those from rules
				mappings = true,
				--- See `lua/which-key/icons.lua` for more details
				--- Set to `false` to disable keymap icons from rules
				---@type wk.IconRule[]|false
				rules = {},
				-- use the highlights from mini.icons
				-- When `false`, it will use `WhichKeyIcon` instead
				colors = true,
				-- used by key format
				keys = vim.g.have_nerd_font and {
					Up = " ",
					Down = " ",
					Left = " ",
					Right = " ",
					C = "󰘴 ",
					M = "󰘵 ",
					D = "󰘳 ",
					S = "󰘶 ",
					CR = "󰌑 ",
					Esc = "󱊷 ",
					ScrollWheelDown = "󱕐 ",
					ScrollWheelUp = "󱕑 ",
					NL = "󰌑 ",
					BS = "󰁮",
					Space = "󱁐 ",
					Tab = "󰌒 ",
					F1 = "󱊫",
					F2 = "󱊬",
					F3 = "󱊭",
					F4 = "󱊮",
					F5 = "󱊯",
					F6 = "󱊰",
					F7 = "󱊱",
					F8 = "󱊲",
					F9 = "󱊳",
					F10 = "󱊴",
					F11 = "󱊵",
					F12 = "󱊶",
				} or {
					Up = "<Up> ",
					Down = "<Down> ",
					Left = "<Left> ",
					Right = "<Right> ",
					C = "<C-…> ",
					M = "<M-…> ",
					D = "<D-…> ",
					S = "<S-…> ",
					CR = "<CR> ",
					Esc = "<Esc> ",
					ScrollWheelDown = "<ScrollWheelDown> ",
					ScrollWheelUp = "<ScrollWheelUp> ",
					NL = "<NL> ",
					BS = "<BS> ",
					Space = "<Space> ",
					Tab = "<Tab> ",
					F1 = "<F1>",
					F2 = "<F2>",
					F3 = "<F3>",
					F4 = "<F4>",
					F5 = "<F5>",
					F6 = "<F6>",
					F7 = "<F7>",
					F8 = "<F8>",
					F9 = "<F9>",
					F10 = "<F10>",
					F11 = "<F11>",
					F12 = "<F12>",
				},
			},
		},
		keys = {
			{
				"<leader>?",
				function()
					require("which-key").show({ global = false })
				end,
				desc = "Buffer Local Keymaps (which-key)",
			},
		},
	},
}
