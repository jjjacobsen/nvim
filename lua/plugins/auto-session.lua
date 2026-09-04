local function open_start_file()
	local file = vim.env.NVIM_START_FILE
	if file then
		vim.cmd.edit(vim.fn.fnameescape(file))
	end
end

return {
	"rmagatti/auto-session",
	lazy = false,
	priority = 100,

	---enables autocomplete for opts
	---@module "auto-session"
	---@type AutoSession.Config
	opts = {
		suppressed_dirs = { "~/", "~/Projects", "~/Downloads", "/" },
		post_restore_cmds = {
			open_start_file,
			function()
				local buf = vim.api.nvim_get_current_buf()
				local filetype = vim.bo[buf].filetype
				local first_line = vim.api.nvim_buf_get_lines(buf, 0, 1, false)[1]
				local name = vim.api.nvim_buf_get_name(buf)
				local should_open_dashboard = name == ""
					and (filetype == "" or filetype == "dashboard")
					and first_line == ""
				if should_open_dashboard then
					vim.schedule(function()
						if vim.api.nvim_buf_is_valid(buf) then
							vim.bo[buf].modifiable = true
						end
						require("lazy").load({ plugins = { "dashboard-nvim" } })
						vim.cmd("Dashboard")
					end)
				end
			end,
		},
		no_restore_cmds = { open_start_file },
		-- log_level = 'debug',
	},
}
