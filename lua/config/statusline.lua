local M = {}

local modes = {
	n = "NORMAL",
	i = "INSERT",
	v = "VISUAL",
	V = "V-LINE",
	["\22"] = "V-BLOCK",
	R = "REPLACE",
	c = "COMMAND",
	r = "PROMPT",
	["!"] = "SHELL",
	s = "SELECT",
	S = "S-LINE",
	["\19"] = "S-BLOCK",
	t = "TERMINAL",
}

function M.mode()
	return modes[vim.fn.mode()]
end

vim.opt.statusline = "%#ModeMsg# %{v:lua.require('config.statusline').mode()} %* %<%t %m"

return M
