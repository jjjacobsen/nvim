return {
	"stevearc/oil.nvim",
	---@module 'oil'
	---@type oil.SetupOpts
	opts = {
		keymaps = {
			["."] = "actions.toggle_hidden",
		},
	},
	config = function(_, opts)
		local util = require("oil.util")
		local original_hide_cursor = util.hide_cursor
		util.hide_cursor = function()
			if vim.go.guicursor == "" then
				return function() end
			end
			return original_hide_cursor()
		end
		require("oil").setup(opts)
	end,
	-- Optional dependencies
	-- dependencies = { { "nvim-mini/mini.icons", opts = {} } },
	dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if you prefer nvim-web-devicons
	-- Lazy loading is not recommended because it is very tricky to make it work correctly in all situations.
	lazy = false,
}
