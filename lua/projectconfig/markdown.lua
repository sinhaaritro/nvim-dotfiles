-- lua/projectconfig/markdown.lua

return {
	filetypes = { "markdown" },
	lsp = {
		server = "marksman",
		settings = {
			cmd = { "marksman", "server" },
			filetypes = { "markdown" },
			settings = {}, -- Marksman has minimal settings, adjust if needed
		},
	},
	formatter = {
		formatters = { "markdownlint-cli2" }, -- Use markdownlint-cli2 for formatting
	},
	linter = { "markdownlint-cli2" }, -- Use markdownlint-cli2 for linting
	dap = {},
	test = {
		adapter = nil, -- No standard test adapter for Markdown; leave as nil or customize
	},
}
