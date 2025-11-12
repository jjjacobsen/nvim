vim.opt.guicursor = ""
vim.opt.clipboard = "unnamedplus"
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.termguicolors = true

vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2

vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0

require("config.lazy")

vim.keymap.set("n", "<leader>cp", function()
	vim.fn.setreg("+", vim.fn.expand("%:p"))
	print("Copied path: " .. vim.fn.expand("%:p"))
end, { desc = "Copy full file path to clipboard" })

vim.keymap.set("n", "<leader>cr", function()
	local path = vim.fn.expand("%:.")
	vim.fn.setreg("+", path)
	print("Copied relative path: " .. path)
end, { desc = "Copy relative file path to clipboard" })

vim.keymap.set("n", "<leader>cf", function()
	vim.fn.setreg("+", vim.fn.expand("%:t"))
	print("Copied filename: " .. vim.fn.expand("%:t"))
end, { desc = "Copy filename to clipboard" })

vim.keymap.set("n", "<leader>mk", function()
	vim.cmd("!mkdir -p %:p:h")
end, { desc = "Create parent directories for file" })

vim.keymap.set("n", "<leader>ts", function()
	vim.cmd("verbose set tabstop? shiftwidth? softtabstop? expandtab? filetype?")
end, { desc = "Show tab settings" })

vim.api.nvim_create_autocmd("FileType", {
	pattern = { "lua", "cpp", "hjson" },
	callback = function()
		vim.opt_local.tabstop = 4
		vim.opt_local.shiftwidth = 4
		vim.opt_local.softtabstop = 4
	end,
})
