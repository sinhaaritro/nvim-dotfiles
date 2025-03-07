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
      { "gd", vim.lsp.buf.definition, desc = "[G]oto [D]efinition" },
      { "gr", vim.lsp.buf.references, desc = "[G]oto [R]eferences", nowait = true },
      { "gI", vim.lsp.buf.implementation, desc = "[G]oto [I]mplementation" },
      { "gy", vim.lsp.buf.type_definition, desc = "[G]oto T[y]pe Definition" },
      { "gD", vim.lsp.buf.declaration, desc = "[G]oto [D]eclaration" },
      { "K", function() return vim.lsp.buf.hover() end, desc = "Hover" },
      { "gK", function() return vim.lsp.buf.signature_help() end, desc = "Signature Help" },
      { "<c-k>", function() return vim.lsp.buf.signature_help() end, mode = "i", desc = "Signature Help" },
      { "<leader>ca", vim.lsp.buf.code_action, desc = "[C]ode [A]ction", mode = { "n", "v" } },
      { "<leader>cc", vim.lsp.codelens.run, desc = "Run Codelens", mode = { "n", "v" } },
      { "<leader>cC", vim.lsp.codelens.refresh, desc = "Refresh & Display Codelens", mode = { "n" } },
      -- { "<leader>cR", function() Snacks.rename.rename_file() end, desc = "Rename File", mode ={"n"} },
      { "<leader>cr", vim.lsp.buf.rename, desc = "[C]ode [R]ename" },
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
			underline = true,
			update_in_insert = false,
			virtual_text = {
				spacing = 4,
				source = "if_many",
				prefix = "●",
				-- this will set set the prefix to a function that returns the diagnostics icon based on the severity
				-- this only works on a recent 0.10.0 build. Will be set to "●" when not supported
				-- prefix = "icons",
			},
			severity_sort = true,
			signs = {
				text = {
					[vim.diagnostic.severity.ERROR] = " ",
					[vim.diagnostic.severity.WARN] = " ",
					[vim.diagnostic.severity.HINT] = "",
					[vim.diagnostic.severity.INFO] = " ",
				},
			},
		},
		-- Enable this to enable the builtin LSP inlay hints on Neovim >= 0.10.0
		-- Be aware that you also will need to properly configure your LSP server to
		-- provide the inlay hints.
		inlay_hints = {
			enabled = true,
			exclude = {}, -- filetypes for which you don't want to enable inlay hints
		},
		-- Enable this to enable the builtin LSP code lenses on Neovim >= 0.10.0
		-- Be aware that you also will need to properly configure your LSP server to
		-- provide the code lenses.
		codelens = {
			enabled = true,
		},
		-- add any global capabilities here
		capabilities = {
			workspace = {
				fileOperations = {
					didRename = true,
					willRename = true,
				},
			},
		},
		-- options for vim.lsp.buf.format
		-- `bufnr` and `filter` is handled by the LazyVim formatter,
		-- but can be also overridden when specified
		format = {
			formatting_options = nil,
			timeout_ms = nil,
		},
	},
	config = function(_, opts)
		vim.diagnostic.config(opts.diagnostics)

		-- Autocommand to load configurations based on filetype
		vim.api.nvim_create_autocmd("FileType", {
			pattern = "*", -- Matches all filetypes
			callback = function(args)
				local ft = args.match -- e.g., "lua", "typescript"
				local config_path = "plugins.filetypes." .. ft

				-- Load filetype-specific config
				local ok, config = pcall(require, config_path)
				if not ok then
					return -- Skip if no config exists
				end

				-- Proceed if an LSP server is specified in the config
				if config.lsp then
					local lspconfig = require("lspconfig")
					local mason_lspconfig = require("mason-lspconfig")
					local mason_registry = require("mason-registry")
					local server = config.lsp.server -- e.g., "ts_ls"
					local settings = config.lsp.settings or {}

					-- Map the lspconfig server name to the Mason package name
					local mason_server_name = mason_lspconfig.get_mappings().lspconfig_to_mason[server]
					if not mason_server_name then
						vim.notify("No Mason package found for " .. server, vim.log.levels.WARN)
						return
					end

					-- Check if the server is already installed
					if not mason_registry.is_installed(mason_server_name) then
						-- Notify and install the server
						vim.notify("Installing LSP server: " .. mason_server_name, vim.log.levels.INFO)
						require("mason.api.command").MasonInstall({ mason_server_name })

						-- Delay the setup to ensure installation completes
						vim.defer_fn(function()
							mason_registry.refresh() -- Update the registry after installation
							lspconfig[server].setup(settings) -- Set up the LSP server
							vim.notify(
								"LSP server " .. mason_server_name .. " installed and set up",
								vim.log.levels.INFO
							)
						end, 1000) -- Wait 1 second
					else
						-- If already installed, set up immediately
						lspconfig[server].setup(settings)
					end
				end
			end,
		})
	end,
}
