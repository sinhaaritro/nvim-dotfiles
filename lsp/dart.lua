-- dartls

---@type vim.lsp.Config
return {
	cmd = { "dart", "language-server", "--protocol=lsp" },
	filetypes = { "dart" },
	init_options = {
		closingLabels = true,
		flutterOutline = true,
		onlyAnalyzeProjectsWithOpenFiles = true,
		outline = true,
		suggestFromUnimportedLibraries = true,
	},
	root_markers = { "pubspec.yaml" },
	single_file_support = true,
	settings = {
		dart = {
			completeFunctionCalls = true,
			showTodos = true,
			enableSnippets = true,
			updateImportsOnRename = true,
		},
	},
}
