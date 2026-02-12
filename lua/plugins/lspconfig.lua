return {
	"neovim/nvim-lspconfig",
	config = function()
		vim.lsp.enable("pyright")
		vim.lsp.enable("jdtls")
		vim.lsp.config("ts_ls", {
			filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
		})
		vim.lsp.enable("ts_ls")
		vim.lsp.enable("dartls")
	end,
}
