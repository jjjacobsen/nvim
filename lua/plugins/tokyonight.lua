return {
	"folke/tokyonight.nvim",
	lazy = false,
	priority = 1000,
	opts = {
		style = "night",
		transparent = true,
		styles = {
			sidebars = "transparent",
			floats = "transparent",
		},
		on_highlights = function(hl, c)
			hl.Comment = { fg = c.blue1, italic = true }
			hl["@comment"] = hl.Comment
			hl.LineNr = { fg = c.fg }
			hl.LineNrAbove = { fg = c.fg }
			hl.LineNrBelow = { fg = c.fg }
			hl.CursorLineNr = { fg = c.blue, bold = true }
		end,
	},
	config = function(_, opts)
		require("tokyonight").setup(opts)
		vim.cmd.colorscheme("tokyonight")
	end,
}
