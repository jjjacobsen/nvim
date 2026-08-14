# jjjacobsen.nvim

Minimal, effective, and stylish Neovim config for people who want their editor to stay out of the way

| Dashboard                                                             | Telescope                                                             |
| --------------------------------------------------------------------- | --------------------------------------------------------------------- |
| ![Dashboard](screenshots/Screenshot%202025-11-08%20at%2006.42.24.png) | ![Telescope](screenshots/Screenshot%202025-11-08%20at%2006.46.42.png) |

| Normal Buffer                                                             | Lazygit                                                             |
| ------------------------------------------------------------------------- | ------------------------------------------------------------------- |
| ![Normal Buffer](screenshots/Screenshot%202025-11-08%20at%2006.43.46.png) | ![Lazygit](screenshots/Screenshot%202025-11-08%20at%2006.48.04.png) |

## Philosophy

Minimal, effective, and stylistic neovim setup. In a world of VSCode clones, there are those who cry out for a minimal alternative. This setup has no file tabs, no file trees, no autocomplete, no debuggers, and no AI. This setup does have fast and fluid text editing capabilities, powerful file finding capacity (telescope), and smooth git integration (lazygit) with a stylistic touch. Stop letting your tools think for you, and instead equip a double-edged sword. A sword that will amplify _your_ skills

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
brew install \
  ripgrep \
  fd \
  lazygit \
  tree-sitter \
  tree-sitter-cli \
  pyright \
  jdtls \
  dart-sdk \
  rust-analyzer \
  deno \
  postgres-language-server \
  bash-language-server \
  yaml-language-server \
  marksman \
  taplo
mise use -g zls
mise use -g npm:typescript@6.0.3
mise use -g npm:typescript-language-server@5.3.0
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

5. (Optional) Dev Dependencies

```bash
brew install stylua
mise use hk
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

- Install most LSP servers via brew, JS/TS tooling via mise. This is the simplest way to understand and maintain them
- For Python LSP (pyright), add this to `pyproject.toml` and point it at the project venv so the LSP sources the environment:

  ```toml
  [tool.pyright]
  venvPath = "."
  venv = ".venv"
  ```

- The postgres LSP requires a `postgres-language-server.jsonc` file in the workspace in order to load
- Replace a text pattern across the repo with the live grep + quickfix flow:

  1. `<leader>fg` to live grep for the pattern
  2. `<C-q>` in the picker to send the matches to the quickfix list
  3. `:copen` to review the matches first if you want
  4. `:cfdo %s/pattern/replacement/ge | update`

  `cfdo` runs once per file in the quickfix list, `cdo` runs once per match line, and `argdo` is the same for the arglist (populate with `:args **/*.ext`). `g` replaces every occurrence per line, `e` skips files with no match, `update` writes changed buffers. Undo per file with `u`

  The same flow works when the quickfix list comes from `:grep` or `:vimgrep` instead of Telescope

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

## Goal

- Zero dependence on third-party lazy.nvim extensions; everything here is built in house, piece by piece
