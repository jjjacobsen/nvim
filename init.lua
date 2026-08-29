-- vim.opt.guicursor = ""
vim.opt.clipboard = "unnamedplus"
vim.opt.ignorecase = true
vim.opt.smartcase = false
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.signcolumn = "number"
vim.opt.termguicolors = true
vim.opt.undofile = true
vim.opt.sessionoptions = {
	"blank",
	"buffers",
	"curdir",
	"folds",
	"help",
	"tabpages",
	"winsize",
	"winpos",
	"terminal",
	"localoptions",
}

vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2

vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0

require("config.lazy")

vim.keymap.set("n", "<C-k>", "<C-y>k", { desc = "Scroll up with cursor" })
vim.keymap.set("n", "<C-j>", "<C-e>j", { desc = "Scroll down with cursor" })
vim.keymap.set("n", "<C-D>", "<C-D>zz", { desc = "Scroll half page down, keep cursor centered" })
vim.keymap.set("n", "<C-U>", "<C-U>zz", { desc = "Scroll half page up, keep cursor centered" })
vim.keymap.set("n", "Y", "_y$", { desc = "Yank line contents" })
vim.keymap.set("n", "U", "y$", { desc = "Yank from cursor to end of line" })
vim.keymap.set("x", "P", '"_dP', { desc = "Paste without replacing clipboard" })

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

vim.keymap.set("n", "<leader>cc", "<cmd>%y+<cr>", { desc = "Copy file contents to clipboard" })

vim.keymap.set("n", "<leader>mk", function()
	vim.cmd("!mkdir -p %:p:h")
end, { desc = "Create parent directories for file" })

vim.keymap.set("n", "<leader>ts", function()
	vim.cmd("verbose set tabstop? shiftwidth? softtabstop? expandtab? filetype?")
end, { desc = "Show tab settings" })

vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Show diagnostic" })
vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { desc = "LSP rename" })

vim.keymap.set("n", "<leader>bc", function()
	vim.cmd("%bd")
end, { desc = "Clear all buffers" })

vim.keymap.set("n", "<leader>h", function()
	vim.cmd("noh")
end, { desc = "Clear highlights" })

vim.api.nvim_create_autocmd("FileType", {
	pattern = {
		"bash",
		"c",
		"cpp",
		"csv",
		"css",
		"dart",
		"dockerfile",
		"git_config",
		"gitignore",
		"go",
		"html",
		"java",
		"javascript",
		"json",
		"lua",
		"markdown",
		"nginx",
		"passwd",
		"python",
		"regex",
		"ruby",
		"rust",
		"sql",
		"ssh_config",
		"swift",
		"terraform",
		"toml",
		"xml",
		"yaml",
		"zig",
		"zsh",
	},
	callback = function()
		vim.treesitter.start()
	end,
})

-- nvim's pkl ftplugin sets foldmethod=syntax, which folds every {} block
vim.api.nvim_create_autocmd("FileType", {
	pattern = "pkl",
	callback = function()
		vim.wo.foldmethod = "manual"
	end,
})
