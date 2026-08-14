# Papercuts

## 2026-08-13

- `ts_ls` failed with "Could not find a valid TypeScript installation" after brew upgraded `typescript` to 7.0.2 (native Go compiler, ships no `tsserver.js`), breaking typescript-language-server's bundled fallback
- Fixed by moving typescript@6.0.3 and typescript-language-server@5.3.0 to mise (`mise use -g npm:...`)
- New gotcha: mise's npm backend generates an "aube" bin shim that unconditionally overrides `NODE_PATH` with its own isolated paths, so setting `cmd_env.NODE_PATH` alone does nothing
- Workaround: ts_ls config launches the server directly via `node <mise cli.mjs> --stdio` with `NODE_PATH` pointing at the mise typescript install, both resolved at config load with `mise where`
