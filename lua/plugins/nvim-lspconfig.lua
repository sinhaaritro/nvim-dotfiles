-- =============================================================================
-- LSP Configuration Manager                                                  --
-- =============================================================================
-- This file configures nvim-lspconfig to set up LSP servers based on project --
-- configurations in lua/projectconfig                                        --
--                                                                            --
-- Plugins Used:                                                              --
-- - nvim-lspconfig (https://github.com/neovim/nvim-lspconfig): Configures    --
--          Neovim's LSP client                                               --
-- - mason.nvim (https://github.com/williamboman/mason.nvim): Manages LSP     --
--          server installations                                              --
-- - mason-lspconfig.nvim
--          (https://github.com/williamboman/mason-lspconfig.nvim):           --
--          Bridges mason.nvim and nvim-lspconfig                             --

return {
	"neovim/nvim-lspconfig", -- LSP client configuration
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"williamboman/mason.nvim",
		{ "williamboman/mason-lspconfig.nvim", config = function() end },
	},
  -- stylua: ignore
  keys = {
    -- { "<leader>cl", function() Snacks.picker.lsp_config() end, desc = "Lsp Info" },
    { "gd",         vim.lsp.buf.definition,                             desc = "[G]oto [D]efinition" },
    { "gr",         vim.lsp.buf.references,                             desc = "[G]oto [R]eferences",        nowait = true },
    { "gI",         vim.lsp.buf.implementation,                         desc = "[G]oto [I]mplementation" },
    { "gy",         vim.lsp.buf.type_definition,                        desc = "[G]oto T[y]pe Definition" },
    { "gD",         vim.lsp.buf.declaration,                            desc = "[G]oto [D]eclaration" },
    { "K",          function() return vim.lsp.buf.hover() end,          desc = "Hover" },
    { "gK",         function() return vim.lsp.buf.signature_help() end, desc = "Signature Help" },
    { "<c-k>",      function() return vim.lsp.buf.signature_help() end, mode = "i",                          desc = "Signature Help" },
    { "<leader>ca", vim.lsp.buf.code_action,                            desc = "[C]ode [A]ction",            mode = { "n", "v" } },
    { "<leader>cc", vim.lsp.codelens.run,                               desc = "Run Codelens",               mode = { "n", "v" } },
    { "<leader>cC", vim.lsp.codelens.refresh,                           desc = "Refresh & Display Codelens", mode = { "n" } },
    -- { "<leader>cR", function() Snacks.rename.rename_file() end, desc = "Rename File", mode ={"n"} },
    { "<leader>cr", vim.lsp.buf.rename,                                 desc = "[C]ode [R]ename" },
    -- { "<leader>cA", LazyVim.lsp.action.source, desc = "Source Action" },
    -- { "]]", function() Snacks.words.jump(vim.v.count1) end,
    --   desc = "Next Reference", cond = function() return Snacks.words.is_enabled() end },
    -- { "[[", function() Snacks.words.jump(-vim.v.count1) end,
    --   desc = "Prev Reference", cond = function() return Snacks.words.is_enabled() end },
    -- { "<a-n>", function() Snacks.words.jump(vim.v.count1, true) end,
    --   desc = "Next Reference", cond = function() return Snacks.words.is_enabled() end },
    -- { "<a-p>", function() Snacks.words.jump(-vim.v.count1, true) end,
    --   desc = "Prev Reference", cond = function() return Snacks.words.is_enabled() end },
  },
	opts = {
		diagnostics = {
			underline = true, -- Underline diagnostics
			update_in_insert = false, -- No updates in insert mode
			virtual_text = {
				spacing = 4, -- Space between text and virtual text
				source = "if_many", -- Show source if multiple
				-- this will set set the prefix to a function that returns the diagnostics icon based on the severity
				-- this only works on a recent 0.10.0 build. Will be set to "●" when not supported
				prefix = "icons",
			},
			severity_sort = true, -- Sort by severity
			signs = {
				text = {
					[vim.diagnostic.severity.ERROR] = " ", -- Error sign
					[vim.diagnostic.severity.WARN] = " ", -- Warning sign
					[vim.diagnostic.severity.HINT] = "", -- Hint sign
					[vim.diagnostic.severity.INFO] = " ", -- Info sign
				},
			},
		},
		inlay_hints = {
			enabled = true, -- Enable inlay hints
			exclude = {}, -- No excluded filetypes
		},
		codelens = {
			enabled = true, -- Enable codelens
		},
		capabilities = {
			workspace = {
				fileOperations = {
					didRename = true, -- Support file rename
					willRename = true, -- Support pre-rename
				},
			},
		},
		format = {
			formatting_options = nil, -- Default formatting options
			timeout_ms = nil, -- Default timeout
		},
	},
	config = function(_, opts)
		-- Configure diagnostics
		vim.diagnostic.config(opts.diagnostics)

		-- Load nvim-lspconfig
		local lspconfig = require("lspconfig")
		local mason_lspconfig = require("mason-lspconfig")
		local mason_registry = require("mason-registry")

		-- Load projectconfig.lua from Neovim dotfiles root
		local config_dir = vim.fn.stdpath("config")
		local project_config_path = config_dir .. "/projectconfig.lua"
		local project_config = nil
		if vim.fn.filereadable(project_config_path) == 1 then -- Check if projectconfig.lua exists
			project_config = dofile(project_config_path)
		end

		-- Collect active project types and LSP configs
		local active_types = project_config and project_config.projecttype or {}
		local projecttype_configs = {}
		local servers_to_install = {}
		local missing_files = {}

		for _, type in ipairs(active_types) do
			local filepath = config_dir .. "/lua/projectconfig/" .. type .. ".lua"
			if vim.fn.filereadable(filepath) == 1 then -- Check if config file exists
				local config = require("projectconfig." .. type)
				projecttype_configs[type] = config
				if config.lsp and config.lsp.server then -- Add LSP server if present
					table.insert(servers_to_install, config.lsp.server)
				end
			else
				table.insert(missing_files, type)
			end
		end

		-- Display a single warning for all missing files, if any
		if #missing_files > 0 then
			local warning_msg = "Warning: The following filetype configurations were not found: "
				.. table.concat(missing_files, ", ")
			vim.notify(warning_msg, vim.log.levels.WARN)
		end

		-- Ensure LSP servers are installed with mason-lspconfig
		require("mason-lspconfig").setup({
			ensure_installed = servers_to_install,
			automatic_installation = true,
		})

		-- Function to poll and set up LSP server when installed
		local function setup_lsp_when_installed(server, mason_server_name, config)
			if mason_registry.is_installed(mason_server_name) then
				lspconfig[server].setup({
					filetypes = config.filetypes,
					settings = config.lsp.settings or {},
				})
				vim.notify("LSP server " .. mason_server_name .. " set up", vim.log.levels.INFO)
			else
				vim.notify("Waiting for LSP server: " .. mason_server_name .. " to install...", vim.log.levels.INFO)
				vim.defer_fn(function()
					setup_lsp_when_installed(server, mason_server_name, config)
				end, 1000) -- Recheck every 1 second
			end
		end

		-- NOTE: Set up LSP servers based on active project types
		for _, config in pairs(projecttype_configs) do
			if config.lsp and config.lsp.server then -- Proceed if LSP is defined
				local server = config.lsp.server -- e.g., "ts_ls"
				local mason_server_name = mason_lspconfig.get_mappings().lspconfig_to_mason[server]
				if not mason_server_name then -- Check Mason mapping
					vim.notify("No Mason package found for " .. server, vim.log.levels.WARN)
					goto continue
				end

				if mason_registry.is_installed(mason_server_name) then -- Immediate setup if installed
					-- If already installed, set up immediately
					lspconfig[server].setup({
						filetypes = config.filetypes,
						settings = config.lsp.settings or {},
					})
				else
					-- If not installed, trigger installation and poll for completion
					vim.notify("Installing LSP server: " .. mason_server_name, vim.log.levels.INFO)
					require("mason.api.command").MasonInstall({ mason_server_name })
					setup_lsp_when_installed(server, mason_server_name, config)
				end
				::continue::
			end
		end
	end,
}
