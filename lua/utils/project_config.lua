-- =============================================================================
-- Project Configuration Utility                                              --
-- =============================================================================
-- This module provides utilities to load and manage project configurations   --
-- from projectconfig.lua and lua/projectconfig                               --
--                                                                            --
-- Dependencies: None                                                         --

local M = {}

-- Load projectconfig.lua and return active types and configs
function M.load_configs()
  -- Load projectconfig.lua from Neovim dotfiles root
  local config_dir = vim.fn.stdpath("config")
  local project_config_path = config_dir .. "/projectconfig.lua"
  local project_config = nil
  if vim.fn.filereadable(project_config_path) == 1 then -- Check if projectconfig.lua exists
    project_config = dofile(project_config_path)
  end

  -- Collect active project types and configs
  local active_types = project_config and project_config.projecttype or {}
  local projecttype_configs = {}
  local missing_files = {}

  for _, type in ipairs(active_types) do
    local filepath = config_dir .. "/lua/projectconfig/" .. type .. ".lua"
    if vim.fn.filereadable(filepath) == 1 then -- Check if config file exists
      local config = require("projectconfig." .. type)
      projecttype_configs[type] = config
    else
      table.insert(missing_files, type)
    end
  end

  -- Notify about missing config files as info
  if #missing_files > 0 then
    local info_msg = "Info: Missing project configs: " .. table.concat(missing_files, ", ")
    vim.notify(info_msg, vim.log.levels.INFO) -- Use INFO level
  end

  return projecttype_configs
end

-- Get LSP servers to install from configs
function M.get_lsp_servers(configs)
  local servers_to_install = {}
  for _, config in pairs(configs) do
    if config.lsp and config.lsp.server then -- Add LSP server if present
      table.insert(servers_to_install, config.lsp.server)
    end
  end
  return servers_to_install
end

return M
