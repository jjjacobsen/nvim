return {
	"toppair/peek.nvim",
	event = { "VeryLazy" },
	build = "deno task --quiet build:fast",
	config = function()
		local validate = vim.validate
		vim.validate = function(name, ...)
			if type(name) == "table" and select("#", ...) == 0 then
				for key, value in pairs(name) do
					validate(key, value[1], value[2], value[3], value[4])
				end
				return
			end
			return validate(name, ...)
		end
		require("peek").setup()
		vim.validate = validate
		vim.api.nvim_create_user_command("PeekOpen", require("peek").open, {})
		vim.api.nvim_create_user_command("PeekClose", require("peek").close, {})
		if vim.fn.maparg("<leader>po", "n") == "" then
			vim.keymap.set("n", "<leader>po", "<cmd>PeekOpen<cr>", { desc = "Peek open" })
		end
		if vim.fn.maparg("<leader>pc", "n") == "" then
			vim.keymap.set("n", "<leader>pc", "<cmd>PeekClose<cr>", { desc = "Peek close" })
		end
	end,
}
