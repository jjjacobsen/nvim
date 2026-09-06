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
- nvim-treesitter
- oil.nvim
  - nvim-web-devicons (shared)
- Omarchy theme synchronization
  - Uses the active Omarchy theme and follows theme changes on Omarchy
  - Uses tokyonight.nvim as the fallback on other systems
- dashboard-nvim
  - nvim-web-devicons (shared)
- auto-session
- lazygit.nvim
  - plenary.nvim (shared)
- gitsigns.nvim
- fff
- telescope.nvim
  - plenary.nvim (shared)
  - telescope-fzf-native.nvim
- flash.nvim
- nvim-lspconfig
- nvim-surround
- peek.nvim
- indent-blankline.nvim
- baleia.nvim
  - Renders ANSI colors in buffers read from standard input

## Installation

### 1. Install system dependencies

Omarchy already includes Neovim and the required command-line tools. To install or repair them:

```bash
omarchy pkg add base-devel fd lazygit ripgrep tree-sitter-cli
```

Neovim includes Tree-sitter integration and a small set of parsers, but `nvim-treesitter` still needs the CLI and a C compiler to install the additional parsers in this config. See [Tree-sitter dependencies](docs/treesitter.md) for details

### 2. Install global editor tools with mise

These editor tools are shared across projects:

```bash
mise use -g \
  deno@latest \
  npm:pyright@latest \
  npm:bash-language-server@latest \
  npm:yaml-language-server@latest \
  npm:@postgres-language-server/cli@latest \
  npm:typescript@latest \
  marksman@latest \
  taplo@latest
```

The TypeScript 7 compiler provides the native language server through `tsc --lsp`, so a separate TypeScript language server is not needed

Deno is required to build and run Peek, so install it before the first Neovim launch. Pin project-specific language toolchains and their tightly coupled servers in each project. This includes Dart, Rust and `rust-analyzer`, Deno, Zig and ZLS, Ruby and `ruby-lsp`, Java, project TypeScript, and Python virtual environments

### 3. Back up the current Neovim files

```bash
# required
mv ~/.config/nvim{,.bak}

# optional but recommended
mv ~/.local/share/nvim{,.bak}
mv ~/.local/state/nvim{,.bak}
mv ~/.cache/nvim{,.bak}
```

To start completely fresh instead:

```bash
rm -rf ~/.config/nvim ~/.local/share/nvim ~/.local/state/nvim ~/.cache/nvim
```

### 4. Clone this repo

```bash
git clone git@github.com:jjjacobsen/nvim.git ~/.config/nvim
```

### 5. Launch Neovim

```bash
nvim
```

lazy.nvim installs and builds the plugins on the first launch. If Peek was installed before Deno, rebuild it with `:Lazy build peek.nvim`. On Omarchy, Neovim follows the active Omarchy theme and keeps it transparent. On other systems, it uses the transparent Tokyo Night fallback. SSH, tmux, and Herdr sessions use OSC 52 clipboard forwarding

### 6. Optional development dependencies

```bash
mise use -g stylua@latest
mise install
```

## Notes

- Install shared language servers globally with mise, but keep language runtimes, compilers, and version-sensitive servers in each project
- For Python LSP (pyright), add this to `pyproject.toml` and point it at the project venv so the LSP sources the environment:

  ```toml
  [tool.pyright]
  venvPath = "."
  venv = ".venv"
  ```

- Add `postgres-language-server.jsonc` to a workspace when the Postgres LSP needs project-specific settings
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
