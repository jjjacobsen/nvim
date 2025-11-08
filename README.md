# jjjacobsen.nvim

<p align="center">
  <img src="screenshots/Screenshot%202025-11-08%20at%2006.42.24.png" alt="Dashboard overview" width="48%" />
  <img src="screenshots/Screenshot%202025-11-08%20at%2006.46.42.png" alt="Editing buffer" width="48%" />
</p>

<p align="center">
  <img src="screenshots/Screenshot%202025-11-08%20at%2006.43.46.png" alt="Telescope picker" width="48%" />
  <img src="screenshots/Screenshot%202025-11-08%20at%2006.48.04.png" alt="ToggleTerm" width="48%" />
</p>

## Installation

Stealing a page from LazyVim for this clean install

- Make a backup of your current Neovim files

```bash
# required
mv ~/.config/nvim{,.bak}

# optional but recommended
mv ~/.local/share/nvim{,.bak}
mv ~/.local/state/nvim{,.bak}
mv ~/.cache/nvim{,.bak}
```

- Clone the repo

```bash
git clone https://github.com/jjjacobsen/nvim.git ~/.config/nvim
```

- Remove the .git folder, so you can add it to your own repo later

```bash
rm -rf ~/.config/nvim/.git
```

- Start Neovim!

```bash
nvim
```
