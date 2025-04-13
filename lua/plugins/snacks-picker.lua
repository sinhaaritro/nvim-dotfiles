return {
	{
		"folke/snacks.nvim",
		enabled = not vim.g.vscode,
		event = "VeryLazy",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		opts = {
			picker = {
				enabled = not vim.g.vscode,
				explorer = {
					replace_netrw = true,
				},
				layout = {
					cycle = true,
					--- Use the default layout or vertical if the window is too narrow
					preset = function()
						return vim.o.columns >= 120 and "default" or "vertical"
					end,
				},
				---@class snacks.picker.matcher.Config
				matcher = {
					fuzzy = true, -- use fuzzy matching
					smartcase = true, -- use smartcase
					ignorecase = true, -- use ignorecase
					sort_empty = false, -- sort results when the search string is empty
					filename_bonus = true, -- give bonus for matching file names (last part of the path)
					file_pos = true, -- support patterns like `file:line:col` and `file:line`
					-- the bonusses below, possibly require string concatenation and path normalization,
					-- so this can have a performance impact for large lists and increase memory usage
					cwd_bonus = false, -- give bonus for matching files in the cwd
					frecency = true, -- frecency bonus
					history_bonus = true, -- give more weight to chronological order
				},
				ui_select = true,
				hidden = true,
				ignored = true,
				-- win = {
				-- 	input = {
				-- 		keys = {
				-- 			["<a-c>"] = {
				-- 				"toggle_cwd",
				-- 				mode = { "n", "i" },
				-- 			},
				-- 		},
				-- 	},
				-- },
				debug = {
					scores = false, -- show scores in the list
					leaks = false, -- show when pickers don't get garbage collected
					explorer = false, -- show explorer debug info
					files = false, -- show file debug info
					grep = false, -- show file debug info
					proc = false, -- show proc debug info
					extmarks = false, -- show extmarks errors
				},
				-- actions = {
				-- 	---@param p snacks.Picker
				-- 	toggle_cwd = function(p)
				-- 		local root = LazyVim.root({ buf = p.input.filter.current_buf, normalize = true })
				-- 		local cwd = vim.fs.normalize((vim.uv or vim.loop).cwd() or ".")
				-- 		local current = p:cwd()
				-- 		p:set_cwd(current == root and cwd or root)
				-- 		p:find()
				-- 	end,
				-- },
			},
		},
  -- stylua: ignore
  keys = {
    { "<leader><space>", function() Snacks.picker.smart() end, desc = "Find Files (Root Dir)" },
    -- { "<leader>,", function() Snacks.picker.buffers() end, desc = "Buffers" },
    -- { "<leader>/", function() Snacks.picker.grep() end, desc = "Grep (Root Dir)" },
    -- { "<leader>:", function() Snacks.picker.command_history() end, desc = "Command History" },
    -- { "<leader>n", function() Snacks.picker.notifications() end, desc = "Notification History" },
    { "<leader>e", function() Snacks.explorer() end, desc = "File Explorer" },
    -- find
    -- { "<leader>fb", function() Snacks.picker.buffers() end, desc = "Buffers" },
    { "<leader>fB", function() Snacks.picker.buffers({ hidden = true, nofile = true }) end, desc = "Buffers (all)" },
    -- { "<leader>fc", function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end, desc = "Find Config File" },
    -- { "<leader>ff", function() Snacks.picker.files() end, desc = "Find Files" },
    -- { "<leader>fg", function() Snacks.picker.git_files() end, desc = "Find Git Files" },
    -- { "<leader>fR", function() Snacks.picker.recent({ filter = { cwd = true }}) end, desc = "Recent (cwd)" },
    -- { "<leader>fp", function() Snacks.picker.projects() end, desc = "Projects" },
    -- git
    -- { "<leader>gb", function() Snacks.picker.git_branches() end, desc = "Git Branches" },
    -- { "<leader>gl", function() Snacks.picker.git_log() end, desc = "Git Log" },
    -- { "<leader>gL", function() Snacks.picker.git_log_line() end, desc = "Git Log Line" },
    -- { "<leader>gs", function() Snacks.picker.git_status() end, desc = "Git Status" },
    -- { "<leader>gS", function() Snacks.picker.git_stash() end, desc = "Git Stash" },
    -- { "<leader>gd", function() Snacks.picker.git_diff() end, desc = "Git Diff (Hunks)" },
    -- { "<leader>gf", function() Snacks.picker.git_log_file() end, desc = "Git Log File" },
    -- Grep
    -- { "<leader>sb", function() Snacks.picker.lines() end, desc = "Buffer Lines" },
    -- { "<leader>sB", function() Snacks.picker.grep_buffers() end, desc = "Grep Open Buffers" },
    -- { "<leader>sg", function() Snacks.picker.grep() end, desc = "Grep" },
    -- { "<leader>sp", function() Snacks.picker.lazy() end, desc = "Search for Plugin Spec" },
    -- { "<leader>sw", function() Snacks.picker.grep_word() end, desc = "Visual selection or word", mode = { "n", "x" } },
    -- search
    -- { '<leader>s"', function() Snacks.picker.registers() end, desc = "Registers" },
    -- { '<leader>s/', function() Snacks.picker.search_history() end, desc = "Search History" },
    -- { "<leader>sa", function() Snacks.picker.autocmds() end, desc = "Autocmds" },
    -- { "<leader>sb", function() Snacks.picker.lines() end, desc = "Buffer Lines" },
    -- { "<leader>sc", function() Snacks.picker.command_history() end, desc = "Command History" },
    { "<leader>sC", function() Snacks.picker.commands() end, desc = "Commands" },
    { "<leader>sd", function() Snacks.picker.diagnostics() end, desc = "Diagnostics" },
    -- { "<leader>sD", function() Snacks.picker.diagnostics_buffer() end, desc = "Buffer Diagnostics" },
    -- { "<leader>sh", function() Snacks.picker.help() end, desc = "Help Pages" },
    -- { "<leader>sH", function() Snacks.picker.highlights() end, desc = "Highlights" },
    -- { "<leader>si", function() Snacks.picker.icons() end, desc = "Icons" },
    -- { "<leader>sj", function() Snacks.picker.jumps() end, desc = "Jumps" },
    { "<leader>sk", function() Snacks.picker.keymaps() end, desc = "Keymaps" },
    -- { "<leader>sl", function() Snacks.picker.loclist() end, desc = "Location List" },
    -- { "<leader>sm", function() Snacks.picker.marks() end, desc = "Marks" },
    -- { "<leader>sM", function() Snacks.picker.man() end, desc = "Man Pages" },
    -- { "<leader>sp", function() Snacks.picker.lazy() end, desc = "Search for Plugin Spec" },
    -- { "<leader>sq", function() Snacks.picker.qflist() end, desc = "Quickfix List" },
    -- { "<leader>sR", function() Snacks.picker.resume() end, desc = "Resume" },
    -- { "<leader>su", function() Snacks.picker.undo() end, desc = "Undo History" },
    -- -- ui
    -- { "<leader>uC", function() Snacks.picker.colorschemes() end, desc = "Colorschemes" },
    -- LSP
    -- { "gd", function() Snacks.picker.lsp_definitions() end, desc = "Goto Definition" },
    -- { "gD", function() Snacks.picker.lsp_declarations() end, desc = "Goto Declaration" },
    { "grr", function() Snacks.picker.lsp_references() end, nowait = true, desc = "References" },
    -- { "gri", function() Snacks.picker.lsp_implementations() end, desc = "Goto Implementation" },
    -- { "gy", function() Snacks.picker.lsp_type_definitions() end, desc = "Goto T[y]pe Definition" },
    -- { "<leader>ss", function() Snacks.picker.lsp_symbols() end, desc = "LSP Symbols" },
    -- { "<leader>sS", function() Snacks.picker.lsp_workspace_symbols() end, desc = "LSP Workspace Symbols" },
  },
	},
}
