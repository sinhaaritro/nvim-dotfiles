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

### Debugging Workflow

This Neovim configuration uses nvim-dap for debugging, integrated with project-specific settings from lua/projectconfig/, automatic adapter installation via mason-nvim-dap, and a UI provided by nvim-dap-ui. Here’s how to debug your code:

#### Open a File

- Open the file you want to debug (e.g., index.js for JavaScript).

#### Set Breakpoints

- <leader>db: Toggle a breakpoint on the current line.
- <leader>dB: Set a conditional breakpoint (prompts for a condition, e.g., x > 5).

#### Start Debugging

- <leader>dc: Start or continue the debug session.
            If a launch.json exists, it’s loaded automatically from <project_root>/.vscode/.
            If no session exists, select a configuration (from launch.json or project config).
- <leader>da: Start with custom arguments (prompts for args, e.g., --flag value).

#### Control Execution

- <leader>di: Step into a function.
- <leader>dO: Step over a line.
- <leader>do: Step out of the current function.
- <leader>dC: Run to the cursor position.
- <leader>dg: Jump to a specific line without executing (prompts for line number).
- <leader>dP: Pause the running session.
- <leader>dt: Terminate the session.

#### Inspect State

- <leader>du: Toggle the DAP UI (shows variables, watches, call stack, breakpoints).
- <leader>de: Evaluate an expression under the cursor (works in normal or visual mode).
- <leader>dw: Hover over a variable to see its value.
- <leader>dr: Toggle the REPL for interactive debugging.
        Virtual text (via nvim-dap-virtual-text) shows variable values inline.

#### Navigate Stack

- <leader>dj: Move down the call stack.
- <leader>dk: Move up the call stack.

#### Reuse Sessions

- <leader>dl: Rerun the last debug session.
- <leader>ds: Show the current session details.

### Testing Workflow

This Neovim configuration uses nvim-neotest to run tests, with adapters dynamically loaded based on project types defined in lua/projectconfig/ (e.g., neotest-vitest for JavaScript/TypeScript). Here’s how to run and manage your tests:

Testing Workflow

#### Open a Test File

- Open a file with tests (e.g., tests/example.test.js for Vitest).

#### Run Tests

- <leader>tr: Run the nearest test under the cursor.
- <leader>tt: Run all tests in the current file.
- <leader>tT: Run all test files in the project (from the current working directory).

#### Debug Tests

- <leader>td: Debug the nearest test using nvim-dap (requires DAP setup for your language, e.g., pwa-node for JS/TS).

#### View Results

- <leader>ts: Toggle the test summary panel (shows passed/failed tests).
- <leader>to: Open the output for the last run test (auto-closes after viewing).
- <leader>tO: Toggle the output panel for persistent test output.

#### Manage Execution

- <leader>tS: Stop the currently running test(s).
- <leader>tl: Rerun the last test command.
- <leader>tw: Toggle watch mode for the current file (reruns tests on changes).
