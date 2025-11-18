# Neovim Configuration

This is a modern Neovim configuration using Lua and lazy.nvim for plugin management.

## Features

- **Plugin Manager**: lazy.nvim for fast startup and lazy loading
- **LSP Support**: Full language server protocol support with mason.nvim
- **Completion**: nvim-cmp with LSP, snippets, and path completion
- **File Navigation**: Telescope for fuzzy finding and Neo-tree for file exploration
- **Git Integration**: Fugitive and Gitsigns
- **Syntax Highlighting**: Tree-sitter for better syntax highlighting
- **UI**: Tokyo Night theme with lualine statusline

## Structure

```
~/.config/nvim/
├── init.lua                 # Main configuration file
├── lua/
│   ├── config/
│   │   ├── autocmds.lua   # Auto commands
│   │   ├── keymaps.lua    # Key mappings
│   │   └── options.lua    # Neovim options
│   └── plugins/
│       ├── coding.lua     # LSP, completion, formatters
│       ├── editor.lua     # Editor enhancements
│       ├── telescope.lua  # Fuzzy finder
│       └── ui.lua         # UI plugins
```

## Key Mappings

### General
- `<Space>` - Leader key
- `<C-s>` - Save file
- `<C-h/j/k/l>` - Navigate windows

### File Navigation
- `<C-e>` - Toggle file explorer (Neo-tree)
- `<leader>ff` - Find files
- `<leader>fg` - Find git files
- `<leader>fr` - Recent files
- `<leader>fb` - Find buffers
- `<C-p>` - Recent files (alternative)

### Search
- `<leader>sg` - Live grep
- `<leader>sw` - Search word under cursor
- `<leader>sh` - Search help
- `<leader>sk` - Search keymaps

### LSP
- `gd` - Go to definition
- `gr` - Find references
- `gI` - Go to implementation
- `K` - Show hover documentation
- `<leader>ca` - Code action
- `<leader>rn` - Rename symbol
- `<leader>cf` - Format buffer

### Git
- `<leader>gs` - Git status
- `<leader>gc` - Git commits
- `<leader>gb` - Git branches
- `]h` - Next git hunk
- `[h` - Previous git hunk
- `<leader>hs` - Stage hunk
- `<leader>hr` - Reset hunk
- `<leader>hp` - Preview hunk

### Buffers
- `]b` - Next buffer
- `[b` - Previous buffer
- `<leader>bp` - Pin buffer
- `<leader>bP` - Close non-pinned buffers

## Language Support

The configuration includes support for:
- Python (pyright, ruff-lsp, black)
- Go (gopls, gofmt)
- Ruby (solargraph, rubocop)
- Rust (rust-analyzer, rustfmt)
- JavaScript/TypeScript (ts_ls, prettier)
- Lua (lua_ls, stylua)

## First Time Setup

1. Install Neovim (0.9.0 or later)
2. Run the setup script: `~/.local/share/chezmoi/run_once_setup-nvim.sh`
3. Open Neovim: `nvim`
4. Lazy.nvim will automatically install all plugins
5. Mason will automatically install configured LSP servers
6. Restart Neovim

## Customization

To add or modify plugins, edit the files in `~/.config/nvim/lua/plugins/`.
Each file returns a table of plugin specifications that lazy.nvim will load.

## Troubleshooting

- Run `:checkhealth` to diagnose issues
- Run `:Lazy` to manage plugins
- Run `:Mason` to manage LSP servers and tools
- Run `:LspInfo` to check LSP status
