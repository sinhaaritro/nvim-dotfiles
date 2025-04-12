-- dartls

---@type vim.lsp.Config
return {
	cmd = { "dart", "language-server", "--protocol=lsp" },
	filetypes = { "dart" },
	root_markers = { "pubspec.yaml" },
	init_options = {
		onlyAnalyzeProjectsWithOpenFiles = true,
		suggestFromUnimportedLibraries = true,
		closingLabels = true,
		outline = true,
		flutterOutline = true,
		allowOpenUri = true,
	},
	single_file_support = true,
	settings = {
		dart = {
			completeFunctionCalls = true,
			showTodos = true,
			enableSnippets = true,
			updateImportsOnRename = true,
			flutterUiGuides = true,
			-- Potentially add specific inlay hint settings here if needed,
			-- similar to Deno, check DartLS docs. Example (might not be exact):
			inlayHints = {
				parameterNames = { enabled = "all" },
				variableTypes = { enabled = true },
				--   -- etc...
			},
		},
	},

	-- Optional: Add custom handlers or setup for codelens actions
	-- on_attach = function(client, bufnr)
	-- 	-- Default on_attach mappings (or your custom ones)
	-- 	local function map(mode, lhs, rhs, opts)
	-- 		opts = opts or {}
	-- 		opts.buffer = bufnr
	-- 		vim.keymap.set(mode, lhs, rhs, opts)
	-- 	end
	--
	-- 	-- map("n", "gd", vim.lsp.buf.definition, { desc = "LSP: Go to Definition" })
	-- 	-- map("n", "gr", vim.lsp.buf.references, { desc = "LSP: Go to References" })
	-- 	-- map("n", "gD", vim.lsp.buf.declaration, { desc = "LSP: Go to Declaration" })
	-- 	-- map("n", "gi", vim.lsp.buf.implementation, { desc = "LSP: Go to Implementation" })
	-- 	-- map("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "LSP: Code Action" })
	-- 	-- map("n", "<leader>rn", vim.lsp.buf.rename, { desc = "LSP: Rename" })
	-- 	-- map("n", "K", vim.lsp.buf.hover, { desc = "LSP: Hover" })
	-- 	-- map("n", "<C-k>", vim.lsp.buf.signature_help, { desc = "LSP: Signature Help" })
	-- 	-- map("n", "<leader>lf", function()
	-- 	-- 	vim.lsp.buf.format({ async = true })
	-- 	-- end, { desc = "LSP: Format" })
	-- 	-- map("n", "<leader>ld", vim.diagnostic.open_float, { desc = "LSP: Line Diagnostics" })
	--
	-- 	-- Enable CodeLens related features after attach IF the server supports it
	-- 	if client.server_capabilities.codeLensProvider then
	-- 		-- Automatically refresh codelens (might have performance impact, optional)
	-- 		vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
	-- 			buffer = bufnr,
	-- 			callback = vim.lsp.codelens.refresh,
	-- 		})
	-- 		-- Manual refresh command
	-- 		map("n", "<leader>lr", vim.lsp.codelens.refresh, { desc = "LSP: Refresh CodeLens" })
	-- 		-- Command to run the CodeLens action under the cursor
	-- 		map("n", "<leader>lc", vim.lsp.codelens.run, { desc = "LSP: Run CodeLens" })
	-- 		-- Optional: Auto-run CodeLens refresh on attach to show them initially
	-- 		-- vim.lsp.codelens.refresh()
	-- 	end
	--
	-- 	-- Enable Inlay Hints IF the server supports it (Requires Neovim 0.10+)
	-- 	-- Needs `capabilities.textDocument.inlayHint` set above
	-- 	if client.server_capabilities.inlayHintProvider then
	-- 		vim.lsp.inlay_hint.enable(bufnr, true) -- Enable for the buffer
	-- 		-- You might want a toggle keymap
	-- 		map("n", "<leader>lh", function()
	-- 			vim.lsp.inlay_hint.enable(bufnr, not vim.lsp.inlay_hint.is_enabled(bufnr))
	-- 		end, { desc = "LSP: Toggle Inlay Hints" })
	-- 	end
	-- end,
}
