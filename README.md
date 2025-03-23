# Neovim Config

My neovim config.
Also works with DevPod to load dotfiles

## Features

- lazy.nvim plugin manager
- mason.nvim for LSP server, DAP server, linters and formatters
- LSP server
- Linter
- Formatter
- Autocomplete
- DAP server
- Testing
- Snippets
- Fuzzy Finder
- File Explorer
- Git Integration
- Terminal
- Multibuffer layout
- AI-Assistant Coding

## Folder Structure

``` text
~/.config/nvim/
├── init.lua                # Main entry point (Neovim official, used by Lazy.nvim)
├── lua/                    # Lua modules (Neovim official, expanded by Lazy.nvim)
│   ├── plugins/            # Lazy.nvim plugin definitions (Lazy.nvim convention)
│   │   ├── init.lua        # Main plugin spec for Lazy.nvim
│   │   ├── lsp.lua         # LSP plugins (e.g., mason, nvim-lspconfig)
│   │   ├── ui.lua          # UI plugins (e.g., lualine, bufferline)
│   │   ├── completion.lua  # Completion plugins (e.g., nvim-cmp)
│   │   ├── navigation.lua  # Navigation plugins (e.g., telescope)
│   │   └── treesitter.lua  # Treesitter plugins
│   ├── config/             # General config modules (Lazy.nvim suggestion)
│   │   ├── options.lua     # Neovim options
│   │   ├── keymaps.lua     # Custom keybindings
│   │   └── autocmds.lua    # Autocommands
│   └── utils/              # Utility functions (Lazy.nvim suggestion)
│       └── project.lua     # Helper scripts (e.g., project detection)
├── plugin/                 # Plugin-specific scripts (Neovim official)
│   └── *.lua               # General-purpose Lua scripts post-plugin load
├── after/                  # Overrides/extensions (Neovim official)
│   ├── ftplugin/           # Filetype-specific settings
│   │   └── *.lua           # e.g., python.lua for Python LSP
│   └── plugin/             # Post-plugin scripts
│       └── *.lua           # e.g., lsp.lua for dynamic LSP tweaks
├── ftplugin/               # Pre-plugin filetype settings (Neovim official)
│   └── *.lua               # e.g., python.lua for buffer-local options
├── syntax/                 # Custom syntax rules (Neovim official)
│   └── *.vim               # Rarely used with Treesitter
├── autoload/               # Autoloaded Vim functions (Neovim official)
│   └── *.vim               # Legacy Vim script support
```

## Plugins

## Optimizations

## Todo

- [ ] Version Control Information
- [ ] Syntax Highlighting
- [ ] Buffer UI Setup

## Notes

### NeoVim Notification Messages

```lua
vim.api.notify("Info: Lazy.nvim is set up!\n", vim.log.levels.INFO) -- Informational
vim.api.notify("Error: Testing an error message", vim.log.levels.ERROR) -- Error
vim.notify("Warning: This is a test warning", vim.log.levels.WARN) -- Warning
vim.notify("Trace: Detailed step", vim.log.levels.TRACE) -- Trace level (verbose logging)
vim.api.nvim_echo({
  { "This is a styled message\n", "Normal" },
  { "Error part", "ErrorMsg" },
  { "\nWarning part", "WarningMsg" },
}, true, {}) -- Styled echo for multiline message
vim.fn.input("Press Enter to continue...") -- Using vim.fn.input for a simple prompt
```

### NeoVim stdpath

```lua
print("config: " .. vim.fn.stdpath("config")) -- The primary directory for user configuration files (e.g., init.lua).
print("config_dirs: " .. vim.inspect(vim.fn.stdpath("config_dirs"))) -- A list of additional directories searched for configuration files (beyond config). This supports system-wide or multi-source configs.
print("data: " .. vim.fn.stdpath("data")) -- The directory for user-specific data files, such as plugins, swap files, or session data.
print("cache: " .. vim.fn.stdpath("cache")) -- The directory for temporary or cached files that can be safely deleted.
print("state: " .. vim.fn.stdpath("state")) -- The directory for state files that persist between sessions but aren’t critical data (introduced in Neovim 0.8+).
```
