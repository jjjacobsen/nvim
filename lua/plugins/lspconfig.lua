return {
	"neovim/nvim-lspconfig",
	config = function()
		vim.lsp.enable("pyright")
		vim.lsp.enable("jdtls")
		vim.lsp.config("ts_ls", {
			filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
			-- mise installs each npm tool in an isolated node_modules and its shim
			-- overrides NODE_PATH, so launch the server directly and point
			-- NODE_PATH at the mise typescript install. Project-local typescript
			-- still wins when present since NODE_PATH is only a fallback
			cmd = {
				"node",
				vim.fn.system("mise where npm:typescript-language-server"):gsub("\n", "")
					.. "/node_modules/typescript-language-server/lib/cli.mjs",
				"--stdio",
			},
			cmd_env = {
				NODE_PATH = vim.fn.system("mise where npm:typescript"):gsub("\n", "") .. "/node_modules",
			},
		})
		vim.lsp.enable("ts_ls")
		vim.lsp.enable("dartls")
		vim.lsp.enable("rust_analyzer")
		vim.lsp.enable("postgres_lsp")
		vim.lsp.enable("bashls")
		vim.lsp.config("yamlls", {
			filetypes = { "yaml" },
		})
		vim.lsp.enable("yamlls")
		vim.lsp.enable("denols")
		vim.lsp.config("marksman", {
			filetypes = { "markdown" },
		})
		vim.lsp.enable("marksman")
		vim.lsp.enable("taplo")
		vim.lsp.enable("zls")
	end,
}
