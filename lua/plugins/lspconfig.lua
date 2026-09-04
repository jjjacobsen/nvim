return {
	"neovim/nvim-lspconfig",
	config = function()
		vim.lsp.enable("pyright")
		vim.lsp.enable("jdtls")
		vim.lsp.enable("tsc")
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
		vim.lsp.enable("ruby_lsp")
	end,
}
