return {
	{
		"akinsho/toggleterm.nvim",
		enabled = not vim.g.vscode,
		cmd = { "ToggleTerm", "TermSelect" },
		keys = {
			{ "<leader>T", "", desc = "+[T]erminal" },
			{
				"<leader>Tf",
				function()
					local count = vim.v.count1
					require("toggleterm").toggle(count, 0, require("utils.project_root").get(), "float")
				end,
				desc = "ToggleTerm (float root_dir)",
			},
			{
				"<leader>Th",
				function()
					local count = vim.v.count1
					require("toggleterm").toggle(count, 15, require("utils.project_root").get(), "horizontal")
				end,
				desc = "ToggleTerm (horizontal root_dir)",
			},
			{
				"<leader>Tv",
				function()
					local count = vim.v.count1
					require("toggleterm").toggle(
						count,
						vim.o.columns * 0.4,
						require("utils.project_root").get(),
						"vertical"
					)
				end,
				desc = "ToggleTerm (vertical root_dir)",
			},
			{
				"<leader>Tn",
				"<cmd>ToggleTermSetName<cr>",
				desc = "Set term name",
			},
			{
				"<leader>Ts",
				"<cmd>TermSelect<cr>",
				desc = "Select term",
			},
			{
				"<leader>Tt",
				function()
					require("toggleterm").toggle(1, 100, require("utils.project_root").get(), "tab")
				end,
				desc = "ToggleTerm (tab root_dir)",
			},
			{
				"<leader>TT",
				function()
					require("toggleterm").toggle(1, 100, vim.fn.getcwd(), "tab")
				end,
				desc = "ToggleTerm (tab cwd_dir)",
			},
			{
				"<leader>Tlg",
				function()
					local Terminal = require("toggleterm.terminal").Terminal
					local lazygit = Terminal:new({ cmd = "lazygit", id = 42, direction = "float", hidden = true })
					if lazygit:is_open() then
						lazygit:close()
					else
						lazygit:open()
					end
				end,
				desc = "Open Lazygit Terminal",
			},
			{
				"<leader>Tld",
				function()
					local Terminal = require("toggleterm.terminal").Terminal
					local lazydocker = Terminal:new({ cmd = "lazydocker", id = 43, direction = "float", hidden = true })
					if lazydocker:is_open() then
						lazydocker:close()
					else
						lazydocker:open()
					end
				end,
				desc = "Open Lazydocker Terminal",
			},
		},
		opts = {
			-- size can be a number or function which is passed the current terminal
			size = function(term)
				if term.direction == "horizontal" then
					return 15
				elseif term.direction == "vertical" then
					return vim.o.columns * 0.4
				end
			end,
			open_mapping = [[<c-\>]],
			-- on_open = fun(t: Terminal), -- function to run when the terminal opens
			-- on_close = fun(t: Terminal), -- function to run when the terminal closes
			-- on_stdout = fun(t: Terminal, job: number, data: string[], name: string) -- callback for processing output on stdout
			-- on_stderr = fun(t: Terminal, job: number, data: string[], name: string) -- callback for processing output on stderr
			-- on_exit = fun(t: Terminal, job: number, exit_code: number, name: string) -- function to run when terminal process exits
			hide_numbers = true, -- hide the number column in toggleterm buffers
			shade_filetypes = {},
			shade_terminals = true,
			-- shading_factor = '<number>', -- the degree by which to darken to terminal colour, default: 1 for dark backgrounds, 3 for light
			start_in_insert = true,
			insert_mappings = true, -- whether or not the open mapping applies in insert mode
			terminal_mappings = true, -- whether or not the open mapping applies in the opened terminals
			persist_size = true,
			direction = "horizontal" or "vertical" or "window" or "float",
			-- direction = "vertical",
			close_on_exit = true, -- close the terminal window when the process exits
			-- shell = vim.o.shell, -- change the default shell
			-- This field is only relevant if direction is set to 'float'
			-- float_opts = {
			--   -- The border key is *almost* the same as 'nvim_open_win'
			--   -- see :h nvim_open_win for details on borders however
			--   -- the 'curved' border is a custom border type
			--   -- not natively supported but implemented in this plugin.
			--   border = 'single' or 'double' or 'shadow' or 'curved',
			--   width = <value>,
			--   height = <value>,
			--   winblend = 3,
			--   highlights = {
			--     border = "Normal",
			--     background = "Normal",
			--   }
			-- }
		},
	},
}
