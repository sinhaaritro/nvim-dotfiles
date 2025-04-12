-- lua/config/lsp.lua
-- Handles global LSP settings, dynamic server list retrieval,
-- and feature setup logic.

local M = {}

-- ======================================================
-- Configuration Functions
-- ======================================================

--- Sets up global diagnostic appearance.
vim.diagnostic.config({
	virtual_lines = { current_line = true },
	-- 		virtual_text = {
	-- 	spacing = 4, -- Space between text and virtual text
	-- 	source = "if_many", -- Show source if multiple
	-- 	prefix = "●",
	-- 	-- this will set set the prefix to a function that returns the diagnostics icon based on the severity
	-- 	-- this only works on a recent 0.10.0 build. Will be set to "●" when not supported
	-- 	-- prefix = "icons",
	-- },
	severity_sort = true, -- Sort by severity
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = " ", -- Error sign
			[vim.diagnostic.severity.WARN] = " ", -- Warning sign
			[vim.diagnostic.severity.HINT] = "", -- Hint sign
			[vim.diagnostic.severity.INFO] = " ", -- Info sign
		},
	},
	-- Show diagnostics in a floating window on hover or with a command
	float = {
		-- Configure border, source display, scope, etc.
		source = "always", -- Example: Always show the diagnostic source (e.g., 'eslint', 'tsserver')
		border = "rounded", -- Example border style
		-- focusable = false, -- Example: Prevent the float from taking focus
	},
	-- Update diagnostics on which events (e.g., InsertLeave, TextChanged)
	update_in_insert = true, -- Example: false = Don't update while typing in insert mode
})

--- Sets up the global '*' LSP configuration, including capabilities.
vim.lsp.config("*", {
	-- Global root markers (can be overridden by specific server configs)
	root_markers = { ".git" },

	-- Generate capabilities by merging user requirements onto Neovim's defaults
	capabilities = (function()
		local default_capabilities = vim.lsp.protocol.make_client_capabilities() or {}

		-- Define specific capabilities to ensure/override
		local user_capabilities = {
			textDocument = {
				completion = {
					completionItem = {
						snippetSupport = true, -- Crucial for blink.cmp + LuaSnip
					},
				},
				semanticTokens = {
					multilineTokenSupport = true,
				},
			},
			workspace = {
				fileOperations = {
					didRename = true, -- Support file rename
					willRename = true, -- Support pre-rename
				},
			},
		}

		-- Merge user capabilities onto defaults ('force' means user values win)
		local final_capabilities = vim.tbl_deep_extend("force", default_capabilities, user_capabilities)
		return final_capabilities
	end)(),
})

-- ======================================================
-- Dynamic Enabling Logic
-- ======================================================

--- Loads projectconfig.lua and returns list of LSP server names to enable.
-- @return table: List of server names (strings) or empty table on error.
function M.get_lsp_servers_to_enable()
	local config_root = vim.fn.stdpath("config")
	local project_config_path = config_root .. "/projectconfig.lua"
	-- Change INFO to DEBUG here:
	-- vim.notify("LSP: Loading project config for enabling: " .. project_config_path, vim.log.levels.DEBUG)

	-- Use pcall for safe file execution
	local ok, project_config_data = pcall(dofile, project_config_path)

	if not ok then
		vim.notify(
			"LSP Error loading " .. project_config_path .. ": " .. tostring(project_config_data),
			vim.log.levels.ERROR
		)
		return {} -- Return empty list on error
	end

	-- Validate the data structure
	if
		type(project_config_data) ~= "table"
		or not project_config_data.projecttype
		or type(project_config_data.projecttype) ~= "table"
	then
		vim.notify(
			"LSP Error: Invalid format in " .. project_config_path .. ". Expected table with 'projecttype' table.",
			vim.log.levels.ERROR
		)
		return {} -- Return empty list on error
	end

	-- vim.notify(
	-- 	"LSP: Project types/servers found in config: " .. vim.inspect(project_config_data.projecttype),
	-- 	vim.log.levels.DEBUG
	-- )
	return project_config_data.projecttype -- Return the validated table directly
end

local servers_to_enable = M.get_lsp_servers_to_enable()
if servers_to_enable and #servers_to_enable > 0 then
	local ok, err = pcall(vim.lsp.enable, servers_to_enable)
	if not ok then
		vim.notify("LSP Error calling vim.lsp.enable in init.lua: " .. tostring(err), vim.log.levels.ERROR)
	else
		-- vim.notify("LSP: Enabled servers via init.lua: " .. table.concat(servers_to_enable, ", "), vim.log.levels.DEBUG)
	end
else
	vim.notify("LSP: No servers specified by project config to enable in init.lua.", vim.log.levels.INFO)
end

-- vim.lsp.enable({
-- 		"deno",
-- 	})

-- ======================================================
-- Feature Setup Functions (Exported for LspAttach)
-- ======================================================

-- Helper for augroups (used within setup functions if needed)
local function augroup(name, opts)
	return vim.api.nvim_create_augroup(name, opts or { clear = true })
end

--- Sets up CodeLens refresh triggers and keymap.
function M.setup_codelens(client, bufnr)
	if client:supports_method("textDocument/codeLens") then
		local group = augroup("LspCodeLensRefresh_" .. bufnr) -- Unique group per buffer
		vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
			desc = "Refresh CodeLens on events",
			group = group,
			buffer = bufnr,
			callback = function()
				if vim.api.nvim_buf_is_valid(bufnr) then
					vim.lsp.codelens.refresh({ bufnr = bufnr })
				end
			end,
		})
		vim.keymap.set("n", "<leader>cl", vim.lsp.codelens.run, { buffer = bufnr, desc = "CodeLens Run Action" })
		-- vim.notify("CodeLens setup complete for buffer " .. bufnr, vim.log.levels.DEBUG)
	else
		vim.notify("CodeLens *not* supported by " .. client.name, vim.log.levels.INFO)
	end
end

--- Enables inlay hints if supported by the client.
function M.setup_inlay_hints(client, bufnr)
	if client.server_capabilities.inlayHintProvider and client.server_capabilities.inlayHintProvider ~= false then
		vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
		-- vim.notify("Inlay Hints enabled for buffer " .. bufnr, vim.log.levels.DEBUG)
	else
		vim.notify("Inlay hints *not* supported by: " .. client.name, vim.log.levels.INFO)
	end
end

--- Placeholder for completion setup (no enable/get needed for blink.cmp).
function M.setup_completion(client, bufnr)
	-- No vim.lsp.completion.enable needed if using blink.cmp or nvim-cmp
	if client:supports_method("textDocument/completion") then
		vim.lsp.completion.enable(true, client.id, bufnr, { autotrigger = true })
		vim.keymap.set("i", "<C-Space>", function()
			vim.lsp.completion.get()
		end, { buffer = bufnr, desc = "Trigger LSP Completion" })
		-- vim.notify("Completion setup complete for buffer " .. bufnr, vim.log.levels.DEBUG)
	else
		vim.notify("Completion *not* supported by " .. client.name, vim.log.levels.INFO)
	end
end

--- Sets up signature help keymap.
function M.setup_signature_help(client, bufnr)
	if client:supports_method("textDocument/signatureHelp") then
		vim.notify(
			"LSP: Mapping <C-K> for Signature Help for " .. client.name .. " on buffer " .. bufnr,
			vim.log.levels.DEBUG
		)
		vim.keymap.set("i", "<C-K>", function()
			vim.lsp.buf.signature_help()
		end, { buffer = bufnr, noremap = true, silent = true, desc = "Trigger Signature Help (LSP)" })
	end
end

-- Add other feature setup functions here (e.g., formatting on save) if desired

-- ======================================================
-- Initial Setup Calls (Optional - can be called from init.lua)
-- ======================================================
-- It's often cleaner to call these setup functions from init.lua
-- after requiring this module, but you could call them here too.
-- M.setup_diagnostics()
-- M.setup_global_lsp_config()

return M
