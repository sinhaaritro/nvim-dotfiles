-- =============================================================================
-- Formatting Configuration Manager                                           --
-- =============================================================================
-- This file configures conform.nvim to set up formatters based on project    --
-- types defined in projectconfig.lua and configs in lua/projectconfig        --
--                                                                            --
-- Plugins Used:                                                              --
-- - conform.nvim (https://github.com/stevearc/conform.nvim): Provides        --
--          formatting support for Neovim                                     --
-- - mason.nvim (https://github.com/williamboman/mason.nvim): Manages         --
--          formatter installations                                           --

return {
  {
    "stevearc/conform.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = { "williamboman/mason.nvim" },
    cmd = "ConformInfo",
    keys = {
      {
        "<leader>cf",
        function()
          require("conform").format({ async = true, lsp_format = "fallback" })
        end,
        mode = { "n", "v" },
        desc = "[C]ode [F]ormat",
      },
    },
    config = function()
      local conform = require("conform")
      local mason_registry = require("mason-registry")
      local project_config = require("utils.project_config")

      -- Basic setup for conform.nvim
      conform.setup({
        notify_on_error = false,
        format_on_save = function(bufnr)
          local disable_filetypes = {
            -- c = true, cpp = true
          }
          local lsp_format_opt
          if disable_filetypes[vim.bo[bufnr].filetype] then
            lsp_format_opt = "never"
          else
            lsp_format_opt = "fallback"
          end
          return {
            timeout_ms = 500,
            lsp_format = lsp_format_opt,
          }
        end,
      })

      -- Load project configurations
      local projecttype_configs = project_config.load_configs()

      -- Function to poll and set up formatter when installed
      local function setup_formatter_when_installed(formatter_name, filetypes, formatters, options)
        if mason_registry.is_installed(formatter_name) then
          -- Create entry for formatters_by_ft for all filetypes
          local entry = {}
          for i, fmt in ipairs(formatters) do
            entry[i] = fmt
          end
          for k, v in pairs(options) do
            entry[k] = v
          end
          for _, ft in ipairs(filetypes) do
            conform.formatters_by_ft[ft] = entry
          end
          vim.notify("Formatter " .. formatter_name .. " set up for " .. table.concat(filetypes, ", "),
            vim.log.levels.INFO)
        else
          vim.notify("Waiting for formatter: " .. formatter_name .. " to install...", vim.log.levels.INFO)
          vim.defer_fn(function()
            setup_formatter_when_installed(formatter_name, filetypes, formatters, options)
          end, 1000) -- Recheck every 1 second
        end
      end

      -- NOTE: Set up formatters based on active project types
      for _, config in pairs(projecttype_configs) do
        -- Only proceed if formatter field exists and has formatters
        if config.formatter and config.formatter.formatters then
          local formatters = config.formatter.formatters
          local options = config.formatter.options or {}
          local filetypes = config.filetypes -- Use all filetypes from the config

          for _, formatter_name in ipairs(formatters) do
            if not mason_registry.is_installed(formatter_name) then
              -- Notify and install the formatter
              vim.notify("Installing formatter: " .. formatter_name, vim.log.levels.INFO)
              require("mason.api.command").MasonInstall({ formatter_name })
              setup_formatter_when_installed(formatter_name, filetypes, formatters, options)
            else
              -- If already installed, set up immediately for all filetypes
              local entry = {}
              for i, fmt in ipairs(formatters) do
                entry[i] = fmt
              end
              for k, v in pairs(options) do
                entry[k] = v
              end
              for _, ft in ipairs(filetypes) do
                conform.formatters_by_ft[ft] = entry
              end
            end
          end
        end
      end

      -- FormatterInfo command
      vim.api.nvim_create_user_command("FormatterInfo", function()
        local filetype = vim.bo.filetype
        local formatters_entry = conform.formatters_by_ft[filetype]
        if formatters_entry then
          local formatters = {}
          for i = 1, #formatters_entry do
            table.insert(formatters, formatters_entry[i])
          end
          local opts_str = ""
          if formatters_entry.stop_after_first then
            opts_str = " (stop_after_first = true)"
          end
          print("Formatters for " .. filetype .. ": " .. table.concat(formatters, ", ") .. opts_str)
        else
          print("No formatters configured for filetype: " .. filetype)
        end
      end, {})
    end,
  },
}
