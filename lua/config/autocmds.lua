-- =============================================================================
-- Basic Autocommands Configuration                                           --
-- =============================================================================
-- This section defines autocommands to automate tasks in Neovim, such as     --
-- file reloading, highlighting, and UI adjustments. See `:help lua-guide-autocommands` --

-- NOTE: Helper function to create autocommand groups
local function augroup(name)
	return vim.api.nvim_create_augroup(name, opts or { clear = true }) -- Create/clear group
end

-- =============================================================================
-- File and Buffer Management Autocommands                                    --
-- =============================================================================
-- This section handles autocommands related to file changes, buffer state,   --
-- and directory creation                                                     --

vim.api.nvim_create_autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
	desc = "Check if we need to reload the file when it changed",
	group = augroup("checktime"),
	callback = function()
		if vim.o.buftype ~= "nofile" then -- Skip nofile buffers
			vim.cmd("checktime")
		end
	end,
})
vim.api.nvim_create_autocmd("BufReadPost", {
	desc = "Go to last loc when opening a buffer",
	group = augroup("last_loc"),
	callback = function(event)
		local exclude = { "gitcommit" } -- Exclude specific filetypes
		local buf = event.buf
		if vim.tbl_contains(exclude, vim.bo[buf].filetype) or vim.b[buf].lazyvim_last_loc then
			return
		end
		vim.b[buf].lazyvim_last_loc = true -- Mark buffer as visited
		local mark = vim.api.nvim_buf_get_mark(buf, '"') -- Get last position
		local lcount = vim.api.nvim_buf_line_count(buf) -- Total lines
		if mark[1] > 0 and mark[1] <= lcount then -- Validate position
			pcall(vim.api.nvim_win_set_cursor, 0, mark) -- Restore cursor
		end
	end,
})
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
	desc = "Auto create dir when saving a file if directory missing",
	group = augroup("auto_create_dir"),
	callback = function(event)
		if event.match:match("^%w%w+:[\\/][\\/]") then -- Skip URLs
			return
		end
		local file = vim.uv.fs_realpath(event.match) or event.match -- Resolve path
		vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p") -- Create dir
	end,
})

-- =============================================================================
-- LSP Based Autocommands                                                     --
-- =============================================================================
-- This section manages autocommands for LSP                                  --

if not vim.g.vscode then
	local lsp_config = require("config.lsp")

	vim.api.nvim_create_autocmd("LspAttach", {
		desc = "Setup LSP Features (CodeLens, Hints, Completion)",
		group = augroup("LspSetup"), -- One group for the main attach logic
		callback = function(args)
			local client = vim.lsp.get_client_by_id(args.data.client_id)
			local bufnr = args.buf

			-- Basic validation
			if not client or not bufnr or not vim.api.nvim_buf_is_valid(bufnr) then
				return
			end

			-- vim.notify("LspAttach triggered for client: " .. client.name .. ", buffer: " .. bufnr, vim.log.levels.INFO)

			-- Call your specific setup functions
			lsp_config.setup_codelens(client, bufnr)
			lsp_config.setup_inlay_hints(client, bufnr)
			lsp_config.setup_completion(client, bufnr)
			-- lsp_config.setup_signature_help(client, bufnr)

			-- vim.notify("LspAttach setup finished for buffer " .. bufnr, vim.log.levels.INFO)
		end,
	})
end
-- =============================================================================
-- UI and Display Autocommands                                                --
-- =============================================================================
-- This section manages autocommands for UI adjustments like resizing and     --
-- highlighting                                                               --

vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = augroup("highlight_yank"),
	callback = function()
		(vim.hl or vim.highlight).on_yank() -- Highlight yanked text
	end,
})
vim.api.nvim_create_autocmd({ "VimResized" }, {
	desc = "Resize splits if window got resized",
	group = augroup("resize_splits"),
	callback = function()
		local current_tab = vim.fn.tabpagenr() -- Save current tab
		vim.cmd("tabdo wincmd =") -- Equalize all splits
		vim.cmd("tabnext " .. current_tab) -- Restore tab
	end,
})

-- =============================================================================
-- Filetype-Specific Settings Autocommands                                    --
-- =============================================================================
-- This section applies autocommands to adjust settings based on filetype     --

vim.api.nvim_create_autocmd("FileType", {
	desc = "Close some filetypes with <q>",
	group = augroup("close_with_q"),
	pattern = {
		"PlenaryTestPopup",
		"checkhealth",
		"dbout",
		"gitsigns-blame",
		"grug-far",
		"help",
		"lspinfo",
		"neotest-output",
		"neotest-output-panel",
		"neotest-summary",
		"notify",
		"qf",
		"spectre_panel",
		"startuptime",
		"tsplayground",
	},
	callback = function(event)
		vim.bo[event.buf].buflisted = false -- Mark as unlisted
		vim.schedule(function() -- Delay keymap setup
			vim.keymap.set("n", "q", function()
				vim.cmd("close") -- Close window
				pcall(vim.api.nvim_buf_delete, event.buf, { force = true }) -- Delete buffer
			end, {
				buffer = event.buf,
				silent = true,
				desc = "Quit buffer",
			})
		end)
	end,
})
vim.api.nvim_create_autocmd("FileType", {
	desc = "Wrap and check for spell in text filetypes",
	group = augroup("wrap_spell"),
	pattern = { "text", "plaintex", "typst", "gitcommit", "markdown" },
	callback = function()
		vim.opt_local.wrap = true -- Enable wrapping
		vim.opt_local.spell = true -- Enable spellcheck
	end,
})

-- =============================================================================
-- Help Section                                                               --
-- =============================================================================
-- This section provides quick references and commands to explore the config  --
-- defined in this file. Uncomment lines to test or learn more about it       --

-- Useful Commands:                                                           --
--   :help lua-guide-autocommands - Learn about autocommands in Lua           --
--   :autocmd                     - List all current autocommands             --
-- Explore Configuration:                                                     --
-- print(vim.inspect(vim.api.nvim_get_autocmds({ group = "checktime" })))     --
--                                -- Inspect checktime group                  --
-- vim.api.nvim_get_autocmds({ group = "highlight_yank" })                    --
--                                -- List yank autocommands                   --
