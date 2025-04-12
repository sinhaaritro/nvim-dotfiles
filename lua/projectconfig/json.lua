-- lua/projectconfig/json.lua

return {
	filetypes = { "json" },
	formatter = {
		formatters = { "biome" }, -- Use Biome for formatting JSON
	},
	linter = { "biome" }, -- Use Biome for linting JSON
	dap = {},
	test = {
		adapter = nil, -- No standard test adapter for JSON; leave as nil or customize
	},
}
