-- =============================================================================
-- Neovim Options Configuration                                               --
-- =============================================================================
-- This section configures Neovim's core settings using vim.opt, controlling  --
-- behavior for file handling, visuals, editing, and more. See `:help vim.opt`--

-- NOTE: You can change these options as you wish! * See `:help option-list`
-- Use `:set all` to list all options, `:options` for a detailed view
local opt = vim.opt -- Alias for vim.opt

-- =============================================================================
-- File Management Options                                                    --
-- =============================================================================
-- This section sets options related to file writing, undo, and sessions      --

opt.autowrite = true -- Enable auto write
opt.confirm = true -- Confirm before exiting modified buffer
opt.sessionoptions = {
	"buffers",
	"curdir",
	"tabpages",
	"winsize",
	"help",
	"globals",
	"skiprtp",
	"folds",
} -- Session components
opt.undodir = vim.fn.expand("~/.cache/nvim/undodir") -- Set undo directory
opt.undofile = true -- Enable persistent undo
opt.undolevels = 10000 -- Set max undo levels

-- =============================================================================
-- Visual Display Options                                                     --
-- =============================================================================
-- This section configures UI elements like line numbers, statusline, and     --
-- visual feedback                                                            --

opt.breakindent = true -- Wrapped lines keep indent
opt.cursorline = true -- Highlight current line
opt.fillchars = {
	foldopen = "", -- Fold open symbol
	foldclose = "", -- Fold closed symbol
	fold = " ", -- Fold fill character
	foldsep = " ", -- Fold separator
	diff = "╱", -- Diff fill character
	eob = " ", -- End of buffer fill
}
opt.foldlevel = 99 -- Start with all folds open
opt.foldexpr = "v:lua.require'lazyvim.util'.ui.foldexpr()" -- Custom fold expression
opt.foldmethod = "expr" -- Use expression-based folding
opt.foldtext = "" -- Custom fold text (empty)
opt.laststatus = 3 -- Global statusline
opt.linebreak = true -- Wrap at word boundaries
opt.list = true -- Show invisible characters
opt.listchars = {
	tab = "» ",
	leadmultispace = "» ",
	trail = "·",
	nbsp = "␣",
} -- Define invisible chars
opt.number = true -- Show line numbers
opt.numberwidth = 3 -- Min width for line numbers
opt.pumblend = 10 -- Popup menu transparency
opt.pumheight = 10 -- Max popup menu height
opt.relativenumber = true -- Show relative line numbers
opt.ruler = false -- Disable default ruler
opt.scrolloff = 4 -- Vertical context lines
opt.showmode = false -- Hide mode (statusline used)
opt.sidescrolloff = 8 -- Horizontal context columns
opt.signcolumn = "yes" -- Always show signcolumn
opt.smoothscroll = true -- Smooth scrolling
opt.termguicolors = true -- Enable true color support
opt.winminwidth = 5 -- Minimum window width
opt.wrap = true -- Enable line wrapping

-- =============================================================================
-- Editing Behavior Options                                                   --
-- =============================================================================
-- This section sets options for text editing, indentation, and clipboard     --

-- NOTE: Clipboard sync depends on SSH and Neovim >= 0.10.0
opt.clipboard = vim.env.SSH_TTY and "" or "unnamedplus" -- Sync clipboard outside SSH
opt.completeopt = "menu,menuone,noselect" -- Completion menu settings
opt.conceallevel = 2 -- Hide markup for bold/italic
opt.expandtab = true -- Use spaces instead of tabs
opt.formatexpr = "v:lua.require'lazyvim.util'.format.formatexpr()" -- Custom format expression
opt.formatoptions = "jcroqlnt" -- Formatting options
opt.mouse = "a" -- Enable mouse in all modes
opt.shiftround = true -- Round indent to shiftwidth
opt.shiftwidth = 2 -- Indent size
opt.shortmess:append({ W = true, I = true, c = true, C = true }) -- Shorten messages
opt.smartindent = true -- Auto-indent smartly
opt.softtabstop = 2 -- Spaces per soft tab
opt.splitbelow = true -- New splits below current
opt.splitkeep = "screen" -- Keep screen layout on split
opt.splitright = true -- New splits right of current
opt.tabstop = 2 -- Spaces per tab
opt.virtualedit = "block" -- Cursor free in block mode
opt.wildmode = "longest:full,full" -- Command-line completion mode

-- =============================================================================
-- Search and Replace Options                                                 --
-- =============================================================================
-- This section configures search, grep, and substitution behavior            --

opt.grepformat = "%f:%l:%c:%m" -- Grep output format
opt.grepprg = "rg --vimgrep" -- Use ripgrep for grep
opt.hlsearch = true -- Highlight search matches
opt.ignorecase = true -- Case-insensitive search
opt.inccommand = "nosplit" -- Preview substitutions
opt.incsearch = true -- Show matches while typing
opt.smartcase = true -- Case-sensitive with capitals

-- =============================================================================
-- Miscellaneous Options                                                      --
-- =============================================================================
-- This section includes other useful settings not fitting above categories   --

opt.jumpoptions = "view" -- Restore view on jumps
opt.spelllang = { "en" } -- Set spellcheck language
opt.timeoutlen = 300 -- Time for key sequences
opt.updatetime = 200 -- Swap file/CursorHold delay

-- =============================================================================
-- Help Section                                                               --
-- =============================================================================
-- This section provides quick references and commands to explore the config  --
-- defined in this file. Uncomment lines to test or learn more about it       --

-- Useful Commands:                                                           --
--   :help vim.opt         - Learn about vim.opt and option settings          --
--   :set all             - List all current option values                    --
--   :options             - View detailed options overview                    --
-- Explore Configuration:                                                     --
-- print("Shiftwidth: " .. opt.shiftwidth:get())  -- Show shiftwidth value    --
-- print("Clipboard: " .. opt.clipboard:get())    -- Show clipboard setting   --
