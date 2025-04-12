-- denols

---@type vim.lsp.Config
return {
	cmd = { "deno", "lsp" },
	filetypes = { "javascript", "typescript", "javascriptreact", "typescriptreact" },
	root_markers = { "deno.json", "deno.jsonc" },
	settings = {
		deno = {
			enable = true,
			inlayHints = {
				parameterNames = {
					enabled = "all", -- Or "literals" or "none"
					-- suppressWhenArgumentMatchesName = true, -- Optional: hide hint if arg name matches param
				},
				parameterTypes = { enabled = false }, -- Usually not needed if you have types in signature
				variableTypes = { enabled = true }, -- <<--- THIS IS LIKELY THE ONE YOU NEED
				propertyDeclarationTypes = { enabled = true },
				functionLikeReturnTypes = { enabled = true },
				enumMemberValues = { enabled = false },
			},
			suggest = {
				imports = {
					hosts = {
						["https://deno.land"] = true,
					},
				},
			},
		},
	},
	-- Incase Inlay Hints are turned of at some other part of the code
	-- on_attach = function(client, bufnr) ... vim.lsp.inlay_hint.enable(true, {bufnr=bufnr}) ... end,
}
