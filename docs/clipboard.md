# Clipboard

Neovim uses the normal system clipboard in local sessions

Inside tmux, SSH, or Herdr, `lua/config/remote_clipboard.lua` sends copies through OSC 52 so they can reach the terminal on the local computer. On Wayland, copies also go to `wl-copy`, and pastes use `wl-paste`

Set this before startup to stop OSC 52 copies while keeping the other behavior:

```lua
vim.g.omarchy_remote_clipboard_osc52 = false
```
