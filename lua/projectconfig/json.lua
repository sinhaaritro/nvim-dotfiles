-- lua/projectconfig/json.lua

return {
	filetypes = { "json" },
	lsp = {
		server = "biome",
		settings = {
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
		},
	},
	formatter = {
		formatters = { "biome" }, -- Use Biome for formatting JSON
	},
	linter = { "biome" }, -- Use Biome for linting JSON
	dap = {},
	test = {
		adapter = nil, -- No standard test adapter for JSON; leave as nil or customize
	},
}
