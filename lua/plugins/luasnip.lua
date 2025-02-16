return {
	{
		"L3MON4D3/LuaSnip",
		-- follow latest release.
		version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
		dependencies = {
			"rafamadriz/friendly-snippets",
		},
		-- install jsregexp (optional!).
		build = (function()
			-- Build Step is needed for regex support in snippets.
			-- This step is not supported in many windows environments.
			-- Remove the below condition to re-enable on windows.
			if vim.fn.has("win32") == 1 or vim.fn.executable("make") == 0 then
				return
			end
			return "make install_jsregexp"
		end)(),
	},
}
