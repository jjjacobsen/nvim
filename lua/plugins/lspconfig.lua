return {
	"neovim/nvim-lspconfig",
	config = function()
		-- Neovim 0.11+ recommended pattern
		vim.lsp.enable("pyright")
	end,
}
