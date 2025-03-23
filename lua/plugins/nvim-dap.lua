-- =============================================================================
-- DAP Configuration Manager                                                  --
-- =============================================================================
-- This file configures nvim-dap to set up debuggers based on project types   --
-- defined in projectconfig.lua and configs in lua/projectconfig              --
--                                                                            --
-- Plugins Used:                                                              --
-- - nvim-dap (https://github.com/mfussenegger/nvim-dap): Provides debugging  --
--          support for Neovim                                                --
-- - mason-nvim-dap.nvim (https://github.com/jay-babu/mason-nvim-dap.nvim):   --
--          Manages DAP installations via Mason                               --
-- - nvim-dap-ui (https://github.com/rcarriga/nvim-dap-ui): UI for DAP        --
-- - nvim-dap-virtual-text
--          (https://github.com/theHamsta/nvim-dap-virtual-text):             --
--          Virtual text for DAP                                              --

---@param config {type?:string, args?:string[]|fun():string[]?}
local function get_args(config)
	local args = type(config.args) == "function" and (config.args() or {}) or config.args or {} --[[@as string[] | string ]]
	local args_str = type(args) == "table" and table.concat(args, " ") or args --[[@as string]]

	config = vim.deepcopy(config)
	---@cast args string[]
	config.args = function()
		local new_args = vim.fn.expand(vim.fn.input("Run with args: ", args_str)) --[[@as string]]
		if config.type and config.type == "java" then
			---@diagnostic disable-next-line: return-type-mismatch
			return new_args
		end
		return require("dap.utils").splitstr(new_args)
	end
	return config
end

return {
	{ "nvim-neotest/nvim-nio" },
	{
		"jay-babu/mason-nvim-dap.nvim",
		dependencies = { "williamboman/mason.nvim" },
		config = function() end, -- Just install the plugin
	},
	{
		"rcarriga/nvim-dap-ui",
		dependencies = { "jay-babu/mason-nvim-dap.nvim" },
    -- stylua: ignore
    keys = {
      { "<leader>du", function() require("dapui").toggle({ reset = true }) end, desc = "Dap UI" },
      { "<leader>de", function() require("dapui").eval() end, desc = "Eval", mode = {"n", "v"} },
    },
		opts = {},
		config = function(_, opts)
			local dap = require("dap")
			local dapui = require("dapui")
			dapui.setup(opts)
			dap.listeners.after.event_initialized["dapui_config"] = function()
				dapui.open({})
			end
			dap.listeners.before.event_terminated["dapui_config"] = function()
				dapui.close({})
			end
			dap.listeners.before.event_exited["dapui_config"] = function()
				dapui.close({})
			end
		end,
	},
	{ "theHamsta/nvim-dap-virtual-text", dependencies = { "mfussenegger/nvim-dap" } },
	{
		"mfussenegger/nvim-dap",
		dependencies = {
			"williamboman/mason.nvim",
			"jay-babu/mason-nvim-dap.nvim",
			"rcarriga/nvim-dap-ui",
		},
    -- stylua: ignore
    keys = {
      { "<leader>dB", function() require("dap").set_breakpoint(vim.fn.input('Breakpoint condition: ')) end, desc = "Breakpoint Condition" },
      { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Toggle Breakpoint" },
      { "<leader>dc", function() require("dap").continue() end, desc = "Run/Continue" },
      { "<leader>da", function() require("dap").continue({ before = get_args }) end, desc = "Run with Args" },
      { "<leader>dC", function() require("dap").run_to_cursor() end, desc = "Run to Cursor" },
      { "<leader>dg", function() require("dap").goto_() end, desc = "Go to Line (No Execute)" },
      { "<leader>di", function() require("dap").step_into() end, desc = "Step Into" },
      { "<leader>dj", function() require("dap").down() end, desc = "Down" },
      { "<leader>dk", function() require("dap").up() end, desc = "Up" },
      { "<leader>dl", function() require("dap").run_last() end, desc = "Run Last" },
      { "<leader>do", function() require("dap").step_out() end, desc = "Step Out" },
      { "<leader>dO", function() require("dap").step_over() end, desc = "Step Over" },
      { "<leader>dP", function() require("dap").pause() end, desc = "Pause" },
      { "<leader>dr", function() require("dap").repl.toggle() end, desc = "Toggle REPL" },
      { "<leader>ds", function() require("dap").session() end, desc = "Session" },
      { "<leader>dt", function() require("dap").terminate() end, desc = "Terminate" },
      { "<leader>dw", function() require("dap.ui.widgets").hover() end, desc = "Widgets" },
    },
		config = function()
			vim.api.nvim_set_hl(0, "DapStoppedLine", { default = true, link = "Visual" })

			local dapIcons = {
				Stopped = { "󰁕 ", "DiagnosticWarn", "DapStoppedLine" },
				Breakpoint = " ",
				BreakpointCondition = " ",
				BreakpointRejected = { " ", "DiagnosticError" },
				LogPoint = ".>",
			}
			local signs_config = {}

			for name, sign in pairs(dapIcons) do
				local sign_definition = {}
				local sign_text = sign
				local sign_texthl = "DiagnosticInfo" -- Default highlight

				if type(sign) == "table" then
					sign_text = sign[1]
					sign_texthl = sign[2] or "DiagnosticInfo" -- Use provided highlight or default
					-- Note: vim.diagnostic.config's `signs` option primarily uses 'text' and 'texthl'.
					-- 'linehl' and 'numhl' from `sign_define` might not have direct equivalents
					-- in `vim.diagnostic.config` for diagnostic signs.
					-- If you need line highlights for DAP breakpoints, you might need to configure that
					-- separately within your DAP plugin or using other Neovim features like highlights.
				end

				sign_definition.text = sign_text
				sign_definition.texthl = sign_texthl

				signs_config["Dap" .. name] = sign_definition
			end

			vim.diagnostic.config({ signs = signs_config })

			local dap = require("dap")
			dap.set_log_level("DEBUG")

			-- Load project configurations using utils/project_config
			local project_config = require("utils.project_config")
			local projecttype_configs = project_config.load_configs()

			-- Collect DAP adapters to ensure_installed
			local dap_adapters = {}
			for _, config in pairs(projecttype_configs) do
				if config.dap and config.dap.ensure_installed then
					for _, adapter in ipairs(config.dap.ensure_installed) do
						table.insert(dap_adapters, adapter)
					end
				end
			end

			-- Setup mason-nvim-dap with dynamic ensure_installed
			require("mason-nvim-dap").setup({
				automatic_installation = true,
				ensure_installed = dap_adapters, -- Dynamically fetched from project configs
			})

			-- Set up DAP adapters and configurations based on project types
			for _, config in pairs(projecttype_configs) do
				if config.dap then
					local dap_config = config.dap
					if dap_config.adapter then
						dap.adapters[dap_config.adapter.name] = dap_config.adapter.config
					end
					if dap_config.configurations then
						for _, ft in ipairs(config.filetypes) do
							dap.configurations[ft] = dap_config.configurations
						end
					end
				end
			end
		end,
	},
}
