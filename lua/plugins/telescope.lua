return {
	"nvim-telescope/telescope.nvim",
	tag = "0.1.8",
	dependencies = {
		"nvim-lua/plenary.nvim",
		{
			"nvim-telescope/telescope-fzf-native.nvim",
			build = "make",
		},
	},
	config = function()
		local telescope = require("telescope")
		local actions = require("telescope.actions")

		telescope.setup({
			defaults = {
				mappings = {
					i = {
						["<C-j>"] = actions.move_selection_next,
						["<C-k>"] = actions.move_selection_previous,
					},
					n = {
						["<C-j>"] = actions.move_selection_next,
						["<C-k>"] = actions.move_selection_previous,
						["q"] = actions.close,
					},
				},
			},
			pickers = {
				buffers = {
					mappings = {
						i = {
							["<C-w>"] = actions.delete_buffer,
						},
						n = {
							["dd"] = actions.delete_buffer,
						},
					},
				},
			},
		})
		if not pcall(telescope.load_extension, "fzf") then
			vim.notify(
				"telescope-fzf-native.nvim not built; run :Lazy build telescope-fzf-native.nvim",
				vim.log.levels.WARN
			)
		end

		local builtin = require("telescope.builtin")
		vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Telescope find files" })
		vim.keymap.set("n", "<leader>fa", function()
			builtin.find_files({ hidden = true, no_ignore = true, file_ignore_patterns = { ".git/" } })
		end, { desc = "Telescope find all files" })
		vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Telescope live grep" })
		vim.keymap.set("n", "<leader>ga", function()
			builtin.live_grep({
				additional_args = function()
					return { "--hidden", "--no-ignore" }
				end,
				file_ignore_patterns = {
					".git/",
					"%.lock$",
					".cache/",
					"node_modules/",
					"package%-lock%.json",
					"pnpm%-lock%.yaml",
					"yarn%.lock",
					"vendor/",
					".bundle/",
					"Pods/",
					"__pycache__/",
					"%.pyc$",
					".mypy_cache/",
					".pytest_cache/",
					"%.DS_Store$",
					"Thumbs%.db$",
					".idea/",
					".vscode/",
					"%.iml$",
				},
			})
		end, { desc = "Telescope live grep all" })
		vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Telescope buffers" })
		vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Telescope help tags" })
		vim.keymap.set("n", "<leader>`", "<cmd>b#<cr>", { desc = "Switch to alternate buffer" })
	end,
}
