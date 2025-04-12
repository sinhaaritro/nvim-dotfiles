-- biome

---@type vim.lsp.Config
return {
	cmd = { "biome", "lsp-proxy" },
	filetypes = { "json" },
	settings = {
		biome = {
			enabled = true,
			formatter = {
				enabled = true,
				indentStyle = "space",
				indentWidth = 2,
				lineWidth = 80,
			},
			linter = {
				enabled = true,
				rules = {
					recommended = true,
					correctness = "error",
				},
			},
			json = {
				parser = {
					allowComments = true, -- For JSONC-like files
					allowTrailingCommas = true,
				},
			},
		},
	},
}
