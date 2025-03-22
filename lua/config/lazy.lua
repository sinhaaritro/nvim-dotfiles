-- =============================================================================
-- Lazy.nvim Bootstrap                                                        --
-- =============================================================================
-- This section bootstraps Lazy.nvim, ensuring it is installed and added to   --
-- the runtime path for plugin management.                                    --

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim" -- Define Lazy.nvim path

-- NOTE: Check if Lazy.nvim exists, install if not
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git" -- Git repo URL
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	-- NOTE: Handle clone failure with error message
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {}) -- Display error and wait
		vim.fn.getchar() -- Wait for keypress
		os.exit(1) -- Exit Neovim
	end
end
vim.opt.rtp:prepend(lazypath) -- Add Lazy.nvim to runtime path

-- =============================================================================
-- Lazy.nvim Setup                                                            --
-- =============================================================================
-- This section configures Lazy.nvim with plugin specifications, defaults,    --
-- checker, performance, and readme settings for efficient plugin management  --

require("lazy").setup({ -- Setup Lazy.nvim
	spec = {
		{ import = "plugins" }, -- Import plugins from lua/plugins
	},
	defaults = {
		-- Set this to `true` to have all your plugins lazy-loaded by default
		-- Only do this if you know what you are doing, as it can lead to
		-- unexpected behavior
		lazy = false, -- Disable lazy-loading by default
		-- It's recommended to leave version=false for now, since a lot the
		-- plugin that support versioning have outdated releases, which may
		-- break your Neovim install
		version = false, -- Use latest git commit
		-- version = "*", -- Latest stable version (commented)
	},
	-- automatically check for plugin updates
	checker = {
		enabled = true, -- Enable update checks
		notify = false, -- Notify on updates
	},
	performance = {
		cache = {
			enabled = true, -- Enable caching
		},
		reset_packpath = true, -- Reset package path
		rtp = {
			reset = true, -- Reset runtime path
			---@type string[]
			paths = {}, -- Custom RTP paths
			---@type string[] list any plugins you want to disable here
			disabled_plugins = {
				"gzip", -- Disable gzip plugin
				"matchit", -- Disable matchit plugin
				"matchparen", -- Disable matchparen plugin
				"netrwPlugin", -- Disable netrw plugin
				"tarPlugin", -- Disable tar plugin
				"tohtml", -- Disable tohtml plugin
				"tutor", -- Disable tutor plugin
				"zipPlugin", -- Disable zip plugin
			},
		},
	},
	-- lazy can generate helptags from the headings in markdown readme files so
	-- :help works even for plugins that don't have vim docs when the readme
	--  opens with :help it will be correctly displayed as markdown
	readme = {
		enabled = true, -- Enable readme support
		root = vim.fn.stdpath("state") .. "/lazy/readme", -- Set readme root path
		files = { "README.md", "lua/**/README.md" }, -- Files to process
		-- only generate markdown helptags for plugins that don't have docs
		skip_if_doc_exists = true, -- Skip if docs exist
	},
})
-- NOTE: Custom notification for plugin updates
vim.api.nvim_create_autocmd("User", {
	pattern = "LazyUpdate", -- Trigger on update event
	callback = function()
		vim.notify("Plugins updated", vim.log.levels.INFO) -- Show non-blocking message
	end,
})

-- =============================================================================
-- Help Section                                                               --
-- =============================================================================
-- This section provides quick references and commands to explore the config  --
-- defined in this file. Uncomment lines to test or learn more about it       --

-- Useful Commands:                                                           --
--   :Lazy                 - Manage plugins and view Lazy.nvim status         --
--   :help lazy.nvim       - View Lazy.nvim documentation                     --
-- Explore Configuration:                                                     --
-- print("Lazy path: " .. vim.fn.stdpath("data") .. "/lazy/lazy.nvim")
--                         -- Show Lazy.nvim path                             --
-- vim.opt.rtp:get()       -- Show runtime path                               --
