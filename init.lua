-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- [[ Install `lazy.nvim` plugin manager ]]
require("config.lazy")

-- [[ Setting Options ]]
require("config.options")

-- [[ Basic Keymaps ]]
require("config.keymaps")

-- [[ Basic Auto Commands ]]
require("config.autocmds")

-- require("lspconfig").ts_ls.setup({})
