# Papercuts

## 2026-08-13

- `ts_ls` failed with "Could not find a valid TypeScript installation" after brew upgraded `typescript` to 7.0.2 (native Go compiler, ships no `tsserver.js`), breaking typescript-language-server's bundled fallback
- Fixed by moving typescript@6.0.3 and typescript-language-server@5.3.0 to mise (`mise use -g npm:...`)
- New gotcha: mise's npm backend generates an "aube" bin shim that unconditionally overrides `NODE_PATH` with its own isolated paths, so setting `cmd_env.NODE_PATH` alone does nothing
- Workaround: ts_ls config launches the server directly via `node <mise cli.mjs> --stdio` with `NODE_PATH` pointing at the mise typescript install, both resolved at config load with `mise where`

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

- A macOS fallback check set `HOME` and `XDG_DATA_HOME` in one command, so the shell expanded `XDG_DATA_HOME` from the original home and Lazy used the active plugin directory
- Unblocked by checking the printed fallback colorscheme directly. Set the temporary home in a separate command before deriving XDG paths in future isolated checks
- `mise x -- hk check --all` failed outside the repo because mise did not load the repo tools. Running it from the repo loaded hk, but hk then failed on a sparse tracked path and missing `stylua`
- `:Lazy sync` updated existing plugins while recording the new theme plugins. Restored the existing lock entries and plugin checkouts, and kept only the new theme lock entries
- Mise's `ubi:eclipse-jdtls/eclipse.jdt.ls` backend found JDTLS 1.60.0 but tried a nonexistent GitHub release URL. JDTLS publishes its archive through Eclipse instead, and mise has no first-party registry entry, so it was left for an AUR or project-specific installation

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
