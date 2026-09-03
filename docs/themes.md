# Themes

On Omarchy, the config reads the active Neovim theme from:

```text
~/.local/state/omarchy/current/theme/neovim.lua
```

The config registers the theme plugins supplied by Omarchy without loading LazyVim. It watches Omarchy's `theme.name` state file and applies theme changes to a running Neovim process

After each theme change, `plugin/after/transparency.lua` removes interface background colors so the terminal background remains visible

On systems without the Omarchy theme file, such as macOS, the config uses its original transparent Tokyo Night setup
