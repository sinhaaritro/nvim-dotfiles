-- marksman

---@type vim.lsp.Config
return {
	cmd = { "marksman", "server" },
	filetypes = { "markdown" },
	settings = {}, -- Marksman has minimal settings, adjust if needed
}
