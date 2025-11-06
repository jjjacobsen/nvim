# jjjacobsen.nvim
I use neovim btw

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
