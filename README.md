# jjjacobsen.nvim

<p align="center">
  <img src="screenshots/Screenshot%202025-11-06%20at%2017.15.42.png" alt="Neovim dashboard" width="48%" />
  <img src="screenshots/Screenshot%202025-11-06%20at%2017.17.31.png" alt="Editing session" width="48%" />
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
