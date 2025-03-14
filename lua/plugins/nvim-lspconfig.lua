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
    inlay_hints = {
      enabled = true,
      exclude = {},
    },
    codelens = {
      enabled = true,
    },
    capabilities = {
      workspace = {
        fileOperations = {
          didRename = true,
          willRename = true,
        },
      },
    },
    format = {
      formatting_options = nil,
      timeout_ms = nil,
    },
  },
  config = function(_, opts)
    -- Configure diagnostics
    vim.diagnostic.config(opts.diagnostics)

    -- Load nvim-lspconfig
    local lspconfig = require("lspconfig")
    local mason_lspconfig = require("mason-lspconfig")
    local mason_registry = require("mason-registry")

    -- Load filetypeconfig.lua from the root of the config directory
    local config_dir = vim.fn.stdpath("config")
    local filetypeconfig_path = config_dir .. "/filetypeconfig.lua"
    local filetypeconfig = dofile(filetypeconfig_path) or { active_filetypes = {} }
    local active_filetypes = filetypeconfig.active_filetypes or {}

    -- Collect LSP servers to install and track missing files
    local servers_to_install = {}
    local missing_files = {}
    local filetype_configs = {}

    for _, ft in ipairs(active_filetypes) do
      local filepath = config_dir .. "/lua/filetypes/" .. ft .. ".lua"
      if vim.fn.filereadable(filepath) == 1 then
        local config = require("filetypes." .. ft)
        filetype_configs[ft] = config
        -- Only add to servers_to_install if lsp field is present and valid
        if config.lsp and config.lsp.server then
          table.insert(servers_to_install, config.lsp.server)
        end
      else
        table.insert(missing_files, ft)
      end
    end

    -- Display a single warning for all missing files, if any
    if #missing_files > 0 then
      local warning_msg = "Warning: The following filetype configurations were not found: " ..
          table.concat(missing_files, ", ")
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
        end, 1000)     -- Recheck every 1 second
      end
    end

    -- Set up each LSP server based on active filetype configurations
    -- for ft, config in pairs(filetype_configs) do
    for _, config in pairs(filetype_configs) do
      -- Only proceed if lsp field exists and has a server
      if config.lsp and config.lsp.server then
        local server = config.lsp.server     -- e.g., "ts_ls"

        -- Map the lspconfig server name to the Mason package name
        local mason_server_name = mason_lspconfig.get_mappings().lspconfig_to_mason[server]
        if not mason_server_name then
          vim.notify("No Mason package found for " .. server, vim.log.levels.WARN)
          goto continue
        end

        -- Check if the server is already installed
        if mason_registry.is_installed(mason_server_name) then
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
