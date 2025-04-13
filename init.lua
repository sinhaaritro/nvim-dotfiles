-- =============================================================================
-- Leader Key Configuration                                                   --
-- =============================================================================
-- This section sets the leader keys for global and local mappings, which are --
-- essential for custom keybindings. The leader key is a prefix for many user --
-- defined shortcuts, enhancing workflow efficiency.                          --

-- Set <space> as the leader key for global mappings     * See `:help mapleader`
-- NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = " " -- Space as global leader
vim.g.maplocalleader = "\\" -- Backslash as local leader

-- =============================================================================
-- Plugin Management                                                          --
-- =============================================================================
-- This section initializes Lazy.nvim, the plugin manager responsible for     --
-- installing and managing plugins efficiently.                               --

require("config.lazy") -- Load Lazy.nvim setup

-- =============================================================================
-- General Options                                                            --
-- =============================================================================
-- This section configures Neovim's core settings, such as UI behavior,       --
-- editing preferences, and other global options.                             --

require("config.options") -- Load general options

-- =============================================================================
-- Keybindings                                                                --
-- =============================================================================
-- This section defines custom key mappings to streamline navigation,         --
-- editing, and plugin interactions.                                          --

require("config.keymaps") -- Load custom keymaps

if not vim.g.vscode then
	require("config.lsp")
end

-- =============================================================================
-- Autocommands                                                               --
-- =============================================================================
-- This section sets up automatic commands that trigger on specific events,   --
-- enhancing automation and functionality.                                    --

require("config.autocmds") -- Load autocommands

-- =============================================================================
-- Help Section                                                               --
-- =============================================================================
-- This section provides quick references and commands to explore the         --
-- configuration defined in this file. Uncomment lines to test or learn more  --

-- Useful Commands:                                                           --
--   :help mapleader       - Learn about leader key settings                  --
--   :help lua-guide       - Understand Lua usage in Neovim                   --
--   :Lazy                 - Manage plugins loaded by config.lazy             --
--   :map                  - View key mappings from config.keymaps            --
--   :autocmd              - List autocommands from config.autocmds           --

-- Explore Configuration (uncomment to print):                                --
-- print("Leader: " .. vim.g.mapleader)            -- Show current leader     --
-- print("Config path: " .. vim.fn.stdpath("config"))  -- Show config dir     --
