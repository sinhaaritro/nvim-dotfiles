-- =============================================================================
-- Basic Keymaps Configuration                                                --
-- =============================================================================
-- This section defines custom key mappings to enhance navigation, editing,   --
-- and workflow efficiency in Neovim. See `:help vim.keymap.set()`            --

-- =============================================================================
-- Search and Highlight Keymaps                                               --
-- =============================================================================
-- This section manages search-related keymaps, such as clearing highlights   --

vim.keymap.set(
	"n",
	"<Esc>",
	"<cmd>nohlsearch<CR>",
	{ desc = "Clear highlights of search when pressing <Esc> in normal mode", noremap = true, silent = true }
)
vim.keymap.set("n", "n", "'Nn'[v:searchforward].'zv'", { expr = true, desc = "Next Search Result" })
vim.keymap.set("x", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next Search Result" })
vim.keymap.set("o", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next Search Result" })
vim.keymap.set("n", "N", "'nN'[v:searchforward].'zv'", { expr = true, desc = "Prev Search Result" })
vim.keymap.set("x", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev Search Result" })
vim.keymap.set("o", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev Search Result" })
vim.keymap.set(
	"n",
	"<leader>ur",
	"<Cmd>nohlsearch<Bar>diffupdate<Bar>normal! <C-L><CR>",
	{ desc = "Redraw / Clear hlsearch / Diff Update" }
)

-- =============================================================================
-- Pasting and Editing Keymaps                                                --
-- =============================================================================
-- This section handles keymaps for pasting, indenting, and text manipulation --

vim.keymap.set({ "n", "x" }, "<leader>p", [["0p]], { desc = "Paste from yank register" })
vim.keymap.set("v", "<", "<gv", { noremap = true, silent = true, desc = "Repeat Indenting" })
vim.keymap.set("v", ">", ">gv", { noremap = true, silent = true, desc = "Repeat Indenting" })
vim.keymap.set("n", "gco", "o<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>", { desc = "Add Comment Below" })
vim.keymap.set("n", "gcO", "O<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>", { desc = "Add Comment Above" })
vim.keymap.set("i", ",", ",<c-g>u") -- Add undo breakpoint for comma
vim.keymap.set("i", ".", ".<c-g>u") -- Add undo breakpoint for period
vim.keymap.set("i", ";", ";<c-g>u") -- Add undo breakpoint for semicolon
vim.keymap.set({ "i", "x", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save File" })

-- =============================================================================
-- Navigation Keymaps                                                         --
-- =============================================================================
-- This section includes keymaps for moving lines, cursor, and disabling      --
-- arrow keys for better navigation habits                                    --

-- TIP: Disable arrow keys in normal and visual mode                          --
vim.keymap.set({ "n", "v" }, "<left>", '<cmd>echo "Use h to move!!"<CR>', { desc = "Disable arrow keys", remap = true })
vim.keymap.set(
	{ "n", "v" },
	"<right>",
	'<cmd>echo "Use l to move!!"<CR>',
	{ desc = "Disable arrow keys", remap = true }
)
vim.keymap.set({ "n", "v" }, "<up>", '<cmd>echo "Use k to move!!"<CR>', { desc = "Disable arrow keys", remap = true })
vim.keymap.set({ "n", "v" }, "<down>", '<cmd>echo "Use j to move!!"<CR>', { desc = "Disable arrow keys", remap = true })
vim.keymap.set("n", "<A-j>", "<cmd>execute 'move .+' . v:count1<cr>==", { desc = "Move Down" })
vim.keymap.set("n", "<A-k>", "<cmd>execute 'move .-' . (v:count1 + 1)<cr>==", { desc = "Move Up" })
vim.keymap.set("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move Down" })
vim.keymap.set("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move Up" })
vim.keymap.set("v", "<A-j>", ":<C-u>execute \"'<,'>move '>+\" . v:count1<cr>gv=gv", { desc = "Move Down" })
vim.keymap.set("v", "<A-k>", ":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<cr>gv=gv", { desc = "Move Up" })

-- =============================================================================
-- Buffer Management Keymaps                                                  --
-- =============================================================================
-- This section defines keymaps for navigating and managing buffers           --

vim.keymap.set("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Prev Buffer" })
vim.keymap.set("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Next Buffer" })
vim.keymap.set("n", "[b", "<cmd>bprevious<cr>", { desc = "Prev Buffer" })
vim.keymap.set("n", "]b", "<cmd>bnext<cr>", { desc = "Next Buffer" })
vim.keymap.set("n", "<leader>bb", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })
vim.keymap.set("n", "<leader>`", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })
vim.keymap.set("n", "<leader>bD", "<cmd>:bd<cr>", { desc = "Delete Buffer and Window" })
vim.keymap.set("n", "<leader>bo", function()
	-- Get the current buffer ID
	local current_buf = vim.api.nvim_get_current_buf()
	-- Iterate over all buffers
	for _, buf in ipairs(vim.api.nvim_list_bufs()) do
		-- Delete each buffer except the current one, if it’s loaded and not modified
		if buf ~= current_buf and vim.api.nvim_buf_is_loaded(buf) then
			vim.api.nvim_buf_delete(buf, { force = false }) -- Use force=false to skip modified buffers
		end
	end
end, { desc = "Delete Other Buffers" })

-- =============================================================================
-- Window and Tab Management Keymaps                                          --
-- =============================================================================
-- This section handles keymaps for splitting, navigating, and managing       --
-- windows and tabs                                                           --

vim.keymap.set("n", "<leader>-", "<C-W>s", { desc = "Split Window Below", remap = true })
vim.keymap.set("n", "<leader>|", "<C-W>v", { desc = "Split Window Right", remap = true })
vim.keymap.set("n", "<leader>wd", "<C-W>c", { desc = "Delete Window", remap = true })
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Go to Left Window", remap = true })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Go to Lower Window", remap = true })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Go to Upper Window", remap = true })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Go to Right Window", remap = true })
vim.keymap.set("n", "<leader><tab>l", "<cmd>tablast<cr>", { desc = "Last Tab" })
vim.keymap.set("n", "<leader><tab>o", "<cmd>tabonly<cr>", { desc = "Close Other Tabs" })
vim.keymap.set("n", "<leader><tab>f", "<cmd>tabfirst<cr>", { desc = "First Tab" })
vim.keymap.set("n", "<leader><tab><tab>", "<cmd>tabnew<cr>", { desc = "New Tab" })
vim.keymap.set("n", "<leader><tab>]", "<cmd>tabnext<cr>", { desc = "Next Tab" })
vim.keymap.set("n", "<leader><tab>d", "<cmd>tabclose<cr>", { desc = "Close Tab" })
vim.keymap.set("n", "<leader><tab>[", "<cmd>tabprevious<cr>", { desc = "Previous Tab" })

-- =============================================================================
-- Diagnostics and Lists Keymaps                                              --
-- =============================================================================
-- This section includes keymaps for diagnostics, quickfix, and location      --
-- lists                                                                      --

-- NOTE: Toggle location list with error handling
vim.keymap.set("n", "<leader>xl", function()
	local success, err = pcall(vim.fn.getloclist(0, { winid = 0 }).winid ~= 0 and vim.cmd.lclose or vim.cmd.lopen)
	if not success and err then
		vim.notify(err, vim.log.levels.ERROR)
	end
end, { desc = "Location List" })
-- NOTE: Toggle quickfix list with error handling
vim.keymap.set("n", "<leader>xq", function()
	local success, err = pcall(vim.fn.getqflist({ winid = 0 }).winid ~= 0 and vim.cmd.cclose or vim.cmd.copen)
	if not success and err then
		vim.notify(err, vim.log.levels.ERROR)
	end
end, { desc = "Quickfix List" })
vim.keymap.set("n", "[q", vim.cmd.cprev, { desc = "Previous Quickfix" })
vim.keymap.set("n", "]q", vim.cmd.cnext, { desc = "Next Quickfix" })
local diagnostic_goto = function(next, severity)
	local go = next and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
	severity = severity and vim.diagnostic.severity[severity] or nil
	return function()
		go({ severity = severity })
	end
end
vim.keymap.set("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Line Diagnostics" })
vim.keymap.set("n", "]d", diagnostic_goto(true), { desc = "Next Diagnostic" })
vim.keymap.set("n", "[d", diagnostic_goto(false), { desc = "Prev Diagnostic" })
vim.keymap.set("n", "]e", diagnostic_goto(true, "ERROR"), { desc = "Next Error" })
vim.keymap.set("n", "[e", diagnostic_goto(false, "ERROR"), { desc = "Prev Error" })
vim.keymap.set("n", "]w", diagnostic_goto(true, "WARN"), { desc = "Next Warning" })
vim.keymap.set("n", "[w", diagnostic_goto(false, "WARN"), { desc = "Prev Warning" })
vim.keymap.set(
	"n",
	"<leader>q",
	vim.diagnostic.setloclist,
	{ noremap = true, silent = true, desc = "Open diagnostic [Q]uickfix list" }
)

-- =============================================================================
-- Miscellaneous Keymaps                                                      --
-- =============================================================================
-- This section covers terminal, snippets, quitting, and other utilities      --

vim.keymap.set("n", "<leader>l", "<cmd>Lazy<cr>", { desc = "Lazy" })
vim.keymap.set("n", "<leader>fn", "<cmd>enew<cr>", { desc = "New File" })

vim.keymap.set("n", "<leader>cp", function()
	local config_path = vim.fn.stdpath("config") .. "/projectconfig.lua"
	local buf = vim.api.nvim_create_buf(false, true) -- Create a new scratch buffer
	vim.api.nvim_buf_set_name(buf, "projectconfig") -- Set buffer name to "projectconfig"
	vim.bo[buf].filetype = "lua" -- Set filetype to "lua"
	vim.api.nvim_open_win(buf, true, {
		relative = "editor",
		width = math.floor(vim.o.columns * 0.8),
		height = math.floor(vim.o.lines * 0.8),
		row = math.floor((vim.o.lines - vim.o.lines * 0.8) / 2),
		col = math.floor((vim.o.columns - vim.o.columns * 0.8) / 2),
		style = "minimal",
		border = "rounded",
	})
	vim.cmd("edit " .. config_path) -- Load the project config file
end, { desc = "Open project config in floating window" })

vim.keymap.set("n", "<leader>qq", "<cmd>qa<cr>", { desc = "Quit All" })
vim.keymap.set("n", "<leader>ui", vim.show_pos, { desc = "Inspect Pos" })
vim.keymap.set("n", "<leader>uI", function()
	vim.treesitter.inspect_tree()
	vim.api.nvim_input("I")
end, { desc = "Inspect Tree" })
vim.keymap.set("t", "<C-/>", "<cmd>close<cr>", { desc = "Hide Terminal" })
vim.keymap.set("t", "<c-_>", "<cmd>close<cr>", { desc = "which_key_ignore" })
-- NOTE: Easier exit from terminal mode, may not work in all terminals       --
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { noremap = true, silent = true, desc = "Exit terminal mode" })
vim.keymap.set("s", "<Tab>", function()
	return vim.snippet.active({ direction = 1 }) and "<cmd>lua vim.snippet.jump(1)<cr>" or "<Tab>"
end, { expr = true, desc = "Jump Next" })
vim.keymap.set({ "i", "s" }, "<S-Tab>", function()
	return vim.snippet.active({ direction = -1 }) and "<cmd>lua vim.snippet.jump(-1)<cr>" or "<S-Tab>"
end, { expr = true, desc = "Jump Previous" })
vim.keymap.set({ "i", "n", "s" }, "<esc>", function()
	vim.cmd("noh")
	return "<esc>"
end, { expr = true, desc = "Escape and Clear hlsearch" })

-- =============================================================================
-- Help Section                                                               --
-- =============================================================================
-- This section provides quick references and commands to explore the config  --
-- defined in this file. Uncomment lines to test or learn more about it       --

-- Useful Commands:                                                           --
--   :help vim.keymap.set()- Learn about keymap configuration                 --
--   :map                  - List all current key mappings                    --
-- Explore Configuration:                                                     --
-- vim.api.nvim_get_keymap("n")                  -- List normal mode maps     --
-- print(vim.inspect(vim.api.nvim_get_keymap("n")))  -- Inspect keymaps       --
