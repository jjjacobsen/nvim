return {
	"numToStr/Comment.nvim",
	config = function()
		require("Comment").setup()

		vim.api.nvim_create_autocmd("FileType", {
			pattern = "hjson",
			callback = function()
				vim.bo.commentstring = "# %s"
			end,
		})
	end,
}
