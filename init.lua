vim.opt.guicursor = ""
vim.opt.clipboard = "unnamedplus"
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.termguicolors = true

vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0

require("config.lazy")

vim.keymap.set("n", "<leader>cp", function()
	vim.fn.setreg("+", vim.fn.expand("%:p"))
	print("Copied path: " .. vim.fn.expand("%:p"))
end, { desc = "Copy full file path to clipboard" })

vim.keymap.set("n", "<leader>cf", function()
	vim.fn.setreg("+", vim.fn.expand("%:t"))
	print("Copied filename: " .. vim.fn.expand("%:t"))
end, { desc = "Copy filename to clipboard" })
