# Tree-sitter dependencies

Neovim includes the Tree-sitter runtime and parsers for C, Diff, Lua, Markdown, Vimscript, Vim documentation, and Tree-sitter queries

This config also uses `nvim-treesitter` to install parsers for many other languages. Parser installation and `:TSUpdate` require:

- Neovim 0.12 or later
- `tree-sitter-cli` 0.26.1 or later
- A C compiler
- `tar`
- `curl`

The separate Tree-sitter library package is not required by this Neovim config

## macOS

Install the Command Line Tools if needed, then install the CLI with Homebrew:

```bash
xcode-select --install
brew install tree-sitter-cli
```

The separate `tree-sitter` Homebrew formula is not needed

## Arch Linux

Install the CLI and standard build tools from the official repositories

```bash
sudo pacman -S tree-sitter-cli base-devel
```

After a new installation, start Neovim and run:

```vim
:TSUpdate
```

The `tree-sitter-cli` package provides the `tree-sitter` executable. Neovim uses that executable to build the extra parsers managed by `nvim-treesitter`
