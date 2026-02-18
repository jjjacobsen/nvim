# jjjacobsen.nvim

Minimal, effective, and stylish Neovim config for people who want their editor to stay out of the way.

<p align="center">
  <img src="screenshots/Screenshot%202025-11-08%20at%2006.42.24.png" alt="Dashboard overview" width="48%" />
  <img src="screenshots/Screenshot%202025-11-08%20at%2006.46.42.png" alt="Editing buffer" width="48%" />
</p>

<p align="center">
  <img src="screenshots/Screenshot%202025-11-08%20at%2006.43.46.png" alt="Telescope picker" width="48%" />
  <img src="screenshots/Screenshot%202025-11-08%20at%2006.48.04.png" alt="ToggleTerm" width="48%" />
</p>

## Philosophy

Minimal, effective, and stylistic neovim setup. In a world of VSCode clones, there are those who cry out for a minimal alternative. This setup has no file tabs, no file trees, no autocomplete, no debuggers, and no AI. This setup does have fast and fluid text editing capabilities, powerful file finding capacity (telescope), and smooth git integration (lazygit) with a stylistic touch. Stop letting your tools think for you, and instead equip a double-edged sword. A sword that will amplify _your_ skills.

## Plugins

- lazy.nvim
- Dependencies
  - nvim-web-devicons
  - plenary.nvim
  - nvim-treesitter
- Comment.nvim
- oil.nvim
- tokyonight.nvim
- dashboard-nvim
- auto-session
- lualine.nvim
- lazygit.nvim
- gitsigns.nvim
- telescope.nvim
  - telescope-fzf-native.nvim
- flash.nvim
- lspconfig
- nvim-surround
- peek.nvim
- indent-blankline.nvim

## Installation

1. Install system dependencies with homebrew

```bash
brew install --cask font-hack-nerd-font
brew install ripgrep fd tree-sitter tree-sitter-cli pyright jdtls typescript-language-server dart-sdk rust-analyzer deno lazygit
```

2. Back up your current Neovim files

```bash
# required
mv ~/.config/nvim{,.bak}

# optional but recommended
mv ~/.local/share/nvim{,.bak}
mv ~/.local/state/nvim{,.bak}
mv ~/.cache/nvim{,.bak}
```

(Optional) Completely remove all previous config. ‼️ Dangerous ‼️

```bash
rm -rf ~/.config/nvim ~/.local/share/nvim ~/.local/state/nvim ~/.cache/nvim
```

3. Clone this repo

```bash
git clone https://github.com/jjjacobsen/nvim.git ~/.config/nvim
```

4. Launch Neovim

```bash
nvim
```

### Secondary LazyVim Install

I like to have LazyVim installed on the side under `lvim` that I check every so often to see if I want to add some plugins. This is how to install it without affecting the main nvim config

1. Clone LazyVim to separate directory

```bash
git clone https://github.com/LazyVim/starter ~/.config/lvim
```

2. Create file at `~/.local/bin/lvim` with the following content

```bash
#!/usr/bin/env bash
export NVIM_APPNAME=lvim
exec nvim "$@"
```

3. Make executable

```bash
chmod +x ~/.local/bin/lvim
```

4. Launch LazyVim

```bash
lvim
```

## Notes

- Install LSP servers via brew. This is the simplest way to understand and maintain them
- For Python LSP (pyright), add this to `pyproject.toml` and point it at the project venv so the LSP sources the environment:

  ```toml
  [tool.pyright]
  venvPath = "."
  venv = ".venv"
  ```

- This mental model helps a lot to understand how neovim works:
  Neovim has three layers
  ```
  ┌─────────────────────────────┐
  │ Your config & plugins       │  ← init.lua, plugins, keymaps
  │ (Lua you write)             │
  ├─────────────────────────────┤
  │ vim.* Lua API               │  ← what you're seeing in :checkhealth
  │ (stable public interface)   │
  ├─────────────────────────────┤
  │ Neovim core (C / Rust / msg)│
  │ buffers, windows, UI, etc   │
  └─────────────────────────────┘
  ```
  You live in layer 1. You talk to layer 3 through layer 2 (vim.\*)
- This is a good analogy to understand the difference between treesitter and LSP:

#### Tree-sitter is a grammar checker

It knows sentence structure:

- Nouns
- Verbs
- Clauses

#### LSP is a subject-matter expert

It knows:

- Whether the sentence is _true_
- Whether it makes sense in context
- Whether it contradicts other documents

Grammar ≠ meaning.

## Maintenance

- Check the health of the installation with

```bash
# General
:checkhealth
```

- Update packages every so often with:
  - Treesitter parsers with `:TSUpdate`
  - Lazy (open with `<leader>la` and then press `U`)
