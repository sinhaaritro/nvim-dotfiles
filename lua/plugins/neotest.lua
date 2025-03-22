-- =============================================================================
-- Neotest Configuration Manager                                              --
-- =============================================================================
-- This file configures neotest to run tests based on project types defined   --
-- in projectconfig.lua and configs in lua/projectconfig.                     --
--                                                                            --
-- Plugins Used:                                                              --
-- - neotest (https://github.com/nvim-neotest/neotest): Test runner for Neovim--
-- - nvim-nio (https://github.com/nvim-neotest/nvim-nio): Async I/O for Neovim--
-- - plenary.nvim (https://github.com/nvim-lua/plenary.nvim): Lua utilities   --
-- - FixCursorHold.nvim (https://github.com/antoinemadec/FixCursorHold.nvim): --
--          Fixes cursor hold issues in Neovim                                --
-- - nvim-treesitter (https://github.com/nvim-treesitter/nvim-treesitter):    --
--          Syntax highlighting and parsing for Neovim                        --
-- - neotest-vitest (https://github.com/marilari88/neotest-vitest): Adapter   --
--          for Vitest tests (loaded dynamically based on project config)     --

-- Function to check if a test adapter is required by the project config
local function is_adapter_required(adapter_name)
	local project_config = require("utils.project_config") -- Adjust path if needed
	local projecttype_configs = project_config.load_configs()
	for _, config in pairs(projecttype_configs) do
		if config.test and config.test.adapter == adapter_name then
			return true
		end
	end
	return false
end

return {
	{ "marilari88/neotest-vitest", lazy = true, cond = is_adapter_required("marilari88/neotest-vitest") },
	{
		"nvim-neotest/neotest",
		lazy = true,
		dependencies = {
			{ "nvim-neotest/nvim-nio", lazy = true },
			{ "nvim-lua/plenary.nvim", lazy = true },
			{ "antoinemadec/FixCursorHold.nvim", lazy = true },
			{ "nvim-treesitter/nvim-treesitter", lazy = true },
		},
    -- stylua: ignore
    keys = {
      { "<leader>t", "", desc = "+test"},
      { "<leader>tt", function() require("neotest").run.run(vim.fn.expand("%")) end, desc = "Run File (Neotest)" },
      { "<leader>tT", function() require("neotest").run.run(vim.uv.cwd()) end, desc = "Run All Test Files (Neotest)" },
      { "<leader>tr", function() require("neotest").run.run() end, desc = "Run Nearest (Neotest)" },
      { "<leader>tl", function() require("neotest").run.run_last() end, desc = "Run Last (Neotest)" },
      { "<leader>ts", function() require("neotest").summary.toggle() end, desc = "Toggle Summary (Neotest)" },
      { "<leader>to", function() require("neotest").output.open({ enter = true, auto_close = true }) end, desc = "Show Output (Neotest)" },
      { "<leader>tO", function() require("neotest").output_panel.toggle() end, desc = "Toggle Output Panel (Neotest)" },
      { "<leader>tS", function() require("neotest").run.stop() end, desc = "Stop (Neotest)" },
      { "<leader>tw", function() require("neotest").watch.toggle(vim.fn.expand("%")) end, desc = "Toggle Watch (Neotest)" },
      { "<leader>td", function() require("neotest").run.run({strategy = "dap"}) end, desc = "Debug Nearest" },
    },
		config = function()
			-- Load project-specific configurations
			local project_config = require("utils.project_config") -- Adjust path if needed
			local projecttype_configs = project_config.load_configs()

			-- Collect adapter names from your project config
			local test_adapters = {}
			for _, config in pairs(projecttype_configs) do
				if config.test and config.test.adapter then
					local adapter_name = config.test.adapter:match("^.*/(.*)$") or config.test.adapter
					-- Check if the adapter is loaded (it will be if required by the project)
					table.insert(test_adapters, adapter_name) -- e.g., "neotest-vitest"
				end
			end

			-- Load the adapters dynamically
			local adapters = {}
			for _, adapter_name in ipairs(test_adapters) do
				local success, adapter_module = pcall(require, adapter_name)
				if success then
					table.insert(adapters, adapter_module)
				else
					print("Warning: Failed to load adapter " .. adapter_name)
				end
			end

			require("neotest").setup({
				-- Configure highlights
				highlights = {
					running = "DiagnosticInfo",
					passed = "DiagnosticOk",
					failed = "DiagnosticError",
					skipped = "DiagnosticHint",
					unknown = "DiagnosticWarn",
				},
				-- Enable output panel
				output = { open_on_run = true, open_on_failure = true },
				-- Define custom adapter configurations.
				adapters = adapters,
			})
		end,
	},
}
