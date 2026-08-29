return {
	"dmtrKovalenko/fff",
	build = function()
		-- downloads a prebuilt binary or falls back to cargo build
		require("fff.download").download_or_build_binary()
	end,
	lazy = false, -- the plugin lazy-initialises itself
	opts = {
		layout = {
			height = 0.8,
			width = 0.8,
			prompt_position = "bottom",
			preview_position = "right",
			preview_size = 0.5,
		},
		keymaps = {
			move_up = { "<Up>", "<C-p>", "<C-k>" },
			move_down = { "<Down>", "<C-n>", "<C-j>" },
		},
	},
	keys = {
		{
			"<leader>ff",
			function()
				require("fff").find_files()
			end,
			desc = "FFF find files",
		},
		{
			"<leader>fg",
			function()
				require("fff").live_grep()
			end,
			desc = "FFF live grep",
		},
	},
}
