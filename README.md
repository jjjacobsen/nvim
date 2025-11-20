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

Minimal, effective, and stylistic neovim setup. In a world of VSCode clones, there are those who cry out for a minimal alternative. This setup has no file tabs, no file trees, no LSPs, no autocomplete, no debuggers, and no AI. This setup does have fast and fluid text editing capabilities, powerful file finding capacity (telescope), and smooth git integration (lazygit) with a stylistic touch. Stop letting your tools think for you, and instead equip a double-edged sword. A sword that will amplify _your_ skills.

## Plugins

- Comment.nvim
- auto-session
- dashboard-nvim
- flash.nvim
- gitsigns.nvim
- lazy.nvim
- lazygit.nvim
- lualine.nvim
- oil.nvim
- nvim-treesitter
- nvim-web-devicons
- plenary.nvim
- telescope-fzf-native.nvim
- telescope.nvim
- tokyonight.nvim
- git-blame.nvim

## Installation

1. Back up your current Neovim files

```bash
# required
mv ~/.config/nvim{,.bak}

# optional but recommended
mv ~/.local/share/nvim{,.bak}
mv ~/.local/state/nvim{,.bak}
mv ~/.cache/nvim{,.bak}
```

2. Clone this repo

```bash
git clone https://github.com/jjjacobsen/nvim.git ~/.config/nvim
```

3. (Optional) Remove the .git folder so you can version your fork later

```bash
rm -rf ~/.config/nvim/.git
```

4. Launch Neovim

```bash
nvim
```
