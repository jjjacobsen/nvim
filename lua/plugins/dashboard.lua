local header = {
	"",
	[[      .                 .                 .           ]],
	[[  .x88888x.         .x88888x.         .x88888x.       ]],
	[[ :8**888888X.  :>  :8**888888X.  :>  :8**888888X.  :> ]],
	[[ f    `888888x./   f    `888888x./   f    `888888x./  ]],
	[['       `*88888~  '       `*88888~  '       `*88888~  ]],
	[[ \.    .  `?)X.    \.    .  `?)X.    \.    .  `?)X.   ]],
	[[  `~=-^   X88> ~    `~=-^   X88> ~    `~=-^   X88> ~  ]],
	[[         X8888  ~          X8888  ~          X8888  ~ ]],
	[[         488888            488888            488888   ]],
	[[ .xx.     88888X   .xx.     88888X   .xx.     88888X  ]],
	[['*8888.   '88888> '*8888.   '88888> '*8888.   '88888> ]],
	[[  88888    '8888>   88888    '8888>   88888    '8888> ]],
	[[  `8888>    `888    `8888>    `888    `8888>    `888  ]],
	[[   "8888     8%      "8888     8%      "8888     8%   ]],
	[[    `"888x:-"         `"888x:-"         `"888x:-"     ]],
	"",
}

return {
	"nvimdev/dashboard-nvim",
	event = "VimEnter",
	config = function()
		require("dashboard").setup({
			config = {
				header = header,
				project = { enable = false },
				shortcut = {},
				footer = {},
				mru = { enable = false },
			},
		})
	end,
	dependencies = { { "nvim-tree/nvim-web-devicons" } },
}
