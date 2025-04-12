-- lua/projectconfig/markdown.lua

return {
	filetypes = { "markdown" },
	formatter = {
		formatters = { "markdownlint-cli2" }, -- Use markdownlint-cli2 for formatting
	},
	linter = { "markdownlint-cli2" }, -- Use markdownlint-cli2 for linting
	dap = {},
	test = {
		adapter = nil, -- No standard test adapter for Markdown; leave as nil or customize
	},
}
