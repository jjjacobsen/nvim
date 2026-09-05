return {
	"m00qek/baleia.nvim",
	event = "StdinReadPost",
	config = function()
		local buffer = vim.api.nvim_get_current_buf()
		require("baleia").setup({ async = false }).once(buffer)
		vim.bo[buffer].modified = false
	end,
}
