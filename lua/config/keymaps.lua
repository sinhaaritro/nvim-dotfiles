-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>", { noremap = true, silent = true })

-- Diagnostic keymaps
vim.keymap.set(
	"n",
	"<leader>q",
	vim.diagnostic.setloclist,
	{ noremap = true, silent = true, desc = "Open diagnostic [Q]uickfix list" }
)

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { noremap = true, silent = true, desc = "Exit terminal mode" })

-- TIP: Disable arrow keys in normal mode
vim.keymap.set("n", "<left>", '<cmd>echo "Use h to move!!"<CR>')
vim.keymap.set("n", "<right>", '<cmd>echo "Use l to move!!"<CR>')
vim.keymap.set("n", "<up>", '<cmd>echo "Use k to move!!"<CR>')
vim.keymap.set("n", "<down>", '<cmd>echo "Use j to move!!"<CR>')

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { noremap = true, silent = true, desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { noremap = true, silent = true, desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { noremap = true, silent = true, desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { noremap = true, silent = true, desc = "Move focus to the upper window" })

-- Window Management
vim.keymap.set(
	"n",
	"<leader>sv",
	":vsplit<CR>",
	{ noremap = true, silent = true, desc = "[S]plit window [V]ertically" }
)
vim.keymap.set(
	"n",
	"<leader>sh",
	":split<CR>",
	{ noremap = true, silent = true, desc = "[S]plit window [H]orizontally" }
)
vim.keymap.set("n", "<leader>sm", ":MaximizerToogle<CR>", { noremap = true, silent = true, desc = "Toogle Minimize" })

-- Indenting
vim.keymap.set("v", "<", "<gv", { noremap = true, silent = true, desc = "Repeat Indenting" })
vim.keymap.set("v", ">", ">gv", { noremap = true, silent = true, desc = "Repeat Indenting" })

-- Move lines up and down
vim.keymap.set("v", "K", ":m '>-2<CR>gv-gv", { noremap = true, silent = true, desc = "Move Selected 1 Line Up" })
vim.keymap.set("v", "J", ":m '>+1<CR>gv-gv", { noremap = true, silent = true, desc = "Move Selected 1 Line Down" })

-- Pasting
vim.keymap.set({ "n", "x" }, "<leader>p", [["0p]], { desc = "paste from yank register" })
