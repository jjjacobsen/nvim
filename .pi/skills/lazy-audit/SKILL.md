---
name: lazy-audit
description: Security review of installed lazy.nvim plugins and their upstream versions. Use before running `:Lazy update` or `:Lazy update <plugin>`, or whenever the user asks to audit, scan, review, or verify the safety of their nvim plugins. Checks installed plugin source for data exfiltration, credential theft, obfuscation, build scripts, and telemetry, then diffs installed commits against the latest upstream commit before deciding whether an update is safe. Accepts optional plugin-name arguments to audit only those plugins instead of all installed ones.
metadata:
  author: jonah
  version: "1.0.0"
---

# Lazy.nvim Plugin Audit

Audit lazy.nvim plugins, compare each against its latest upstream commit, and give a verdict on whether updating them is safe. By default audits every installed plugin; with plugin-name arguments it audits only those

## Setup

- Installed plugins live in `~/.local/share/nvim/lazy/` (lazy.nvim's install dir, `stdpath("data") .. "/lazy"`). lazy.nvim itself is installed there too as `lazy/lazy.nvim`
- Plugin specs live in `lua/plugins/*.lua` in the nvim config repo, imported by the `{ import = "plugins" }` spec in `lua/config/lazy.lua`
- The installed commit of every plugin is recorded in `lazy-lock.json` at the repo root, keyed by plugin name with `branch` and `commit`
- `dev = true` specs point at local directories instead of git remotes, they cannot be updated and are skipped by the upstream check

## Pinning

- A `commit = "<sha>"` in the spec pins the plugin exactly, `:Lazy update` skips it
- `version = "x.y.z"` or a tag pins to that tag, `version = "*"` tracks the latest tag
- Everything else tracks the branch recorded in `lazy-lock.json` and WILL be moved to the latest commit by `:Lazy update`
- `build` is an install/update script the user opted into via the spec (e.g. `make`, `:TSUpdate`), the audit verifies what that script actually runs

## Scope

This skill takes optional plugin-name arguments, e.g. `/skill:lazy-audit telescope.nvim gitsigns.nvim`. When the user provides plugin names, audit ONLY those and skip everything else:

1. Resolve each name against `lazy-lock.json` (and the spec files), then locate it in `~/.local/share/nvim/lazy/`
2. If an argument is not installed, fetch and scan its latest source instead of skipping it. Fetch it as in Step 3, scan it with the Step 2 checklist, and report the verdict as answering "is it safe to install?"
3. If an argument is absent from lazy-lock.json but IS installed, still audit it

With no arguments, audit all installed plugins as described below

## Step 1: Enumerate

1. Read `lazy-lock.json` and list every plugin with its branch and commit
2. Cross-reference `lua/plugins/*.lua` specs: confirm each is installed, note the pinned ones (`commit`, `version`, `tag`) and the ones tracking a branch
3. Note the `build` field for every spec, it is the install/update script for that plugin

## Step 2: Scan installed source

For each plugin, run these checks against its installed files in `~/.local/share/nvim/lazy/<plugin>`, or against the fetched source for plugins that are not installed yet. Skip `doc/`, `.git/`, `node_modules/`, and treesitter parser C sources

1. Outbound network
   - `grep -rnoE 'https?://[a-zA-Z0-9._/-]+' --include='*.lua' --include='*.vim' --include='*.js' --include='*.ts' <plugin-dir>`
   - Classify every host as expected (github.com for updates, provider APIs the user configured) or unknown
   - For every `vim.fn.system` / `vim.fn.jobstart` / `curl` call, read the surrounding code and determine what data is in the request body or URL
   - Flag anything that sends session content, buffer content, file contents, environment variables, or tokens anywhere other than a host the user configured
2. Credential and sensitive file access
   - Grep for `.ssh`, `.netrc`, `.aws`, `credentials`, `cookie`, `.env`, `keychain`, `auth.json`, `id_rsa`, `id_ed25519`
   - Any read of `~/.ssh/` private keys, `~/.netrc`, or `~/.aws/` credentials is a red flag. Plugins that shell out to `git` or `lazygit` are fine, the credential access happens inside those tools, not the plugin
3. Process execution
   - Grep for `vim.fn.system`, `vim.fn.jobstart`, `vim.fn.jobwait`, `io.popen`, `os.execute`, `uv.spawn`, `plenary.job`, `eval(`, `loadstring`, `load(`
   - `git` spawns are normal for git tooling and lazy.nvim itself. Anything else needs a full read of the surrounding code
4. Build scripts
   - For every `build =` in the specs, read the Makefile, install script, or command it invokes. `make` for a native dependency (e.g. telescope-fzf-native) and `:TSUpdate` for treesitter are normal, anything that curls a script or writes outside the plugin dir is not
5. Obfuscation
   - Flag source lines over 2000 chars, long base64 blobs, hex-encoded strings, or minified JS entry points that are not clearly a build artifact
6. Telemetry
   - Grep case-insensitively for `posthog`, `segment`, `sentry`, `amplitude`, `mixpanel`, `telemetry`, `analytics`
7. Dependencies
   - Check for git submodules (`.gitmodules`) and the `rocks` field in specs, skim any bundled dependency names for typosquats of well-known packages

Read the plugin entry point in full for every plugin (the file its `config` requires, or `plugin/*.lua`). Also read any file that showed a hit above. Grep output alone is not a verdict, the actual code is

## Step 3: Check upstreams

For each plugin, compare the installed commit against the latest upstream:

```bash
git ls-remote https://github.com/<owner>/<repo> <branch from lazy-lock.json>
```

Compare the returned commit against the `commit` in `lazy-lock.json`. For `version = "*"` or tag-pinned plugins, list tags instead:

```bash
git ls-remote --tags https://github.com/<owner>/<repo>
```

When installed differs from latest, or the plugin is not installed yet, fetch the source:

1. Clone the repo to a temp dir and check out the lockfile commit:
   ```bash
   git clone https://github.com/<owner>/<repo> /tmp/lazy-audit/<plugin>
   git -C /tmp/lazy-audit/<plugin> checkout <lockfile commit>
   ```
2. Check out the latest branch commit (or tag) in a second worktree, or `git fetch` and diff the tree: `git -C /tmp/lazy-audit/<plugin> diff <lockfile commit> <latest>`
3. Review with the same checklist as Step 2. This is the code an update would bring, so pay extra attention to newly added files, new outbound hosts, new build steps, and new dependencies

## Step 4: Report

Output a report with this structure:

```
## Verdict: safe to run :Lazy update?  YES / CAUTION / NO

Per plugin:
- name (installed -> latest)
  - network: <hosts and what data goes where>
  - sensitive reads: <none or details>
  - exec: <none or details>
  - build: <none or details>
  - verdict: CLEAN / NOTE / FLAG
```

- CLEAN means no concerns found
- NOTE means expected behavior worth mentioning, such as shelling out to git or fetching parsers from github
- FLAG means anything that sends data to an unexpected host, reads credentials, obfuscates code, or ships suspicious build steps
- Any FLAG makes the verdict NO. Any unresolved NOTE that touches data leaving the machine makes it CAUTION
- Verdict is YES only when every plugin is CLEAN or has only trivial NOTES

End with a recommendation: either safe to run `:Lazy update` now, or update one plugin at a time and re-audit each one. For a scoped audit, recommend `:Lazy update <plugin>` for the audited plugins instead of the full update. For not-installed plugins, the verdict is whether it is safe to install them, and the recommendation is to add the spec and run `:Lazy install` when clean

## After updating

If the user runs an update after this audit, re-run Step 2 on the newly installed code to verify what actually landed. The upstream diff in Step 3 is a preview, the installed code is the truth
