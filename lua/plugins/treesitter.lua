return {
	"nvim-treesitter/nvim-treesitter",
	lazy = false,
	branch = "main",
	build = ":TSUpdate",
	config = function()
		local ts = require("nvim-treesitter")
		local languages = {
			"bash",
			"c",
			"dart",
			"dockerfile",
			"go",
			"hjson",
			"html",
			"java",
			"javascript",
			"json",
			"lua",
			"markdown",
			"markdown_inline",
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
		}
		ts.setup({ install_dir = vim.fn.stdpath("data") .. "/site" })
		ts.install(languages)
		vim.api.nvim_create_autocmd("FileType", {
			callback = function(args)
				pcall(vim.treesitter.start, args.buf)
				vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
			end,
		})
	end,
}
