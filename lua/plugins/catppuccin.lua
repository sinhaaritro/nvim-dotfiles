return {
	{
		"catppuccin/nvim",
		enabled = not vim.g.vscode,
		lazy = false,
		name = "catppuccin",
		priority = 1000,
		opts = {
			{
				flavour = "frappe", -- latte, frappe, macchiato, mocha
				background = { -- :h background
					light = "latte",
					dark = "mocha",
				},
				transparent_background = true, -- disables setting the background color.
				show_end_of_buffer = false, -- shows the '~' characters after the end of buffers
				term_colors = false, -- sets terminal colors (e.g. `g:terminal_color_0`)
				dim_inactive = {
					enabled = false, -- dims the background color of inactive window
					shade = "dark",
					percentage = 0.15, -- percentage of the shade to apply to the inactive window
				},
				no_italic = false, -- Force no italic
				no_bold = false, -- Force no bold
				no_underline = false, -- Force no underline
				styles = { -- Handles the styles of general hi groups (see `:h highlight-args`):
					comments = { "italic" }, -- Change the style of comments
					conditionals = { "italic" },
					loops = {},
					functions = {},
					keywords = {},
					strings = {},
					variables = {},
					numbers = {},
					booleans = {},
					properties = {},
					types = {},
					operators = {},
					-- miscs = {}, -- Uncomment to turn off hard-coded styles
				},
				color_overrides = {},
				custom_highlights = {},
				default_integrations = true,
				integrations = {
					alpha = true,
					blink_cmp = true,
					cmp = true,
					dashboard = true,
					flash = true,
					fzf = true,
					gitsigns = true,
					nvimtree = true,
					leap = true,
					lsp_trouble = true,
					mason = true,
					markdown = true,
					mini = {
						enabled = true,
						indentscope_color = "",
					},
					neotest = true,
					neotree = true,
					noice = true,
					notify = true,
					semantic_tokens = true,
					snacks = true,
					telescope = true,
					treesitter = true,
					treesitter_context = true,
					which_key = true,
					-- For more plugins integrations please scroll down (https://github.com/catppuccin/nvim#integrations)
				},
			},
		},
		config = function()
			-- 	require("catppuccin").setup({
			-- 		transparent_background = true,
			-- 	})
			vim.cmd.colorscheme("catppuccin-mocha")
		end,
	},
}
