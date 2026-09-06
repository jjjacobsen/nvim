# Papercuts

## 2026-08-19

- `fff` (dmtrKovalenko/fff) cannot be exercised headlessly: `nvim --headless +"lua require('fff').file_search(...)"` returns "timeout waiting for index scan" even though the filesystem walk completes in <1ms per the Rust log
- The picker's initial-scan readiness signal is only delivered while nvim's main loop runs; a headless `-c`/defer call blocks before it arrives, and tracing output on abrupt exit is unreliable
- Unblocked by verifying in a real terminal via tmux (`nvim` in a pane, `<space>ff` / `<space>fg` drove the picker end-to-end). The plugin works fine interactively
- `:TSUpdate <lang>` run headlessly as `nvim --headless "+TSUpdate swift" +qa` exits before the async compile job finishes: the parser is never rebuilt and the command exits 0 with no error, leaving a stale parser silently installed (parser-info/*.revision unchanged)
- Unblocked by adding `"+sleep 15"` (or `+sleep 30` for large parsers) before `+qa` and then verifying `~/.local/share/nvim/site/parser-info/<lang>.revision` matches the pinned revision in nvim-treesitter's lua/nvim-treesitter/parsers.lua

## 2026-08-29

- Flash search labels became stale after `/` incremental search scrolled the window on Neovim 0.12, so a displayed label could jump to the wrong match
- This is upstream flash.nvim issue #480. Updating to the latest main commit does not include a fix
- Open pull request #488 forces a redraw and improves label rendering, but the same workaround did not make off-screen label jumps reliable in this config, so the workaround was removed while waiting for an upstream fix

## 2026-09-02

- `mise x -- hk check --all` failed outside the repo because mise did not load the repo tools. Running it from the repo loaded hk, but hk then failed on a sparse tracked path and missing `stylua`
- `:Lazy sync` updated existing plugins while recording the new theme plugins. Restored the existing lock entries and plugin checkouts, and kept only the new theme lock entries

## 2026-09-03

- After replacing a mise tool version, the current shell kept the old install directory in `PATH`, so the first native TypeScript LSP check found TypeScript 6 instead of 7
- Unblocked by running the check through `mise x`, which rebuilt `PATH` from the updated global config. New shells also use the updated path
- Peek's default webview silently exited because `webview_deno` requires `libwebkit2gtk-4.0.so.37`, while this system provides WebKitGTK 4.1
- The Peek log only showed exit code 1. Running its bundled `public/webview.js` directly exposed the missing library, and setting Peek's `app` to `chromium` bypassed the incompatible webview

## 2026-09-04

- A headless Neovim check falsely showed that auto-session still did not restore after fixing plugin priority because auto-session intentionally skips restoration without an attached UI
- Unblocked by starting Neovim in a detached tmux session with `--listen`, then checking `v:this_session`, `getcwd()`, and the active buffer through `--remote-expr`
- `mise x -- hk check --all` used the global environment and could not resolve the project-pinned `hk` because the command started outside this repository
- Unblocked by changing to the repository before running the check
- `omarchy-launch-tui` remained attached while its Ghostty window was open, so a combined launch-and-inspect command timed out before it reached the assertions
- Unblocked by inspecting the Neovim server and Hyprland client in a separate command. Background the launcher for future automated checks

## 2026-09-05

- A malformed parallel tool call put the Bash command under an empty object key, so schema validation rejected the command before execution
- Unblocked by sending the Bash command with the required top-level `command` and `timeout` fields
- Baleia's `version = "*"` install cloned `main` and then failed while switching to the latest tag because Git could not reset the repository's changed submodule layout, which left a mixed worktree
- Unblocked by tracking Baleia's default branch directly, then removing the broken plugin checkout and reinstalling it
- The first headless Baleia check rendered colors correctly but timed out because stripping ANSI codes marked the read-only stdin buffer as modified, so `:q` refused to exit
- Unblocked by processing the small stdin buffer synchronously and clearing its modified flag after Baleia finishes
- The first `mise x -- hk check --all` ran from `/home/jonah/Work` instead of the Neovim repository, so mise could not resolve the project-pinned hk version
- Unblocked by changing to `~/.config/nvim` before running the check
