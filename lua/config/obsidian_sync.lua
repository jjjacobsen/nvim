local M = {}

if vim.fn.has("linux") == 0 or vim.fn.executable("systemctl") == 0 or vim.fn.executable("journalctl") == 0 then
	function M.status()
		return ""
	end
	return M
end

local available = true
local vault = vim.fn.expand("~/Documents/obsidian/")
local service = "obsidian-headless-sync.service"
local session
local state = "unknown"
local timer
local frame = 1
local frames = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }

local function is_vault(buf)
	return vim.bo[buf].buftype == "" and vim.api.nvim_buf_get_name(buf):sub(1, #vault) == vault
end

local function animate()
	local visible = false
	for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
		if is_vault(vim.api.nvim_win_get_buf(win)) then
			visible = true
			break
		end
	end
	if state == "syncing" and visible then
		if not timer then
			timer = assert(vim.uv.new_timer())
			timer:start(
				120,
				120,
				vim.schedule_wrap(function()
					if timer then
						frame = frame % #frames + 1
						vim.cmd.redrawstatus()
					end
				end)
			)
		end
	elseif timer then
		timer:stop()
		timer:close()
		timer = nil
	end
end

local function update(value)
	state = value
	animate()
	vim.cmd.redrawstatus()
end

-- Stable systemd message IDs, independent of the service description and locale
local lifecycle = {
	["7d4958e842da4a758f6c1cdc7b36dcc5"] = "syncing", -- starting
	["39f53479d3a045ac8e11786248231fbf"] = "syncing", -- started
	["de5b426a63be47a7b6ac3eaac82e2f6f"] = "error", -- stopping
	["9d1aaa27d60140bd96365438aad20286"] = "error", -- stopped
	["be02cf6855d2428ba40df7e9d022f03d"] = "error", -- start failed
	["7ad2d189f7e94e70a38c781354912448"] = "error", -- deactivated
	["d9b373ed55a64feb8242e02dbe79a49c"] = "error", -- failed
	["98e322203f7a4ed290d09fe03c09fe15"] = "error", -- process exited
}

local function consume(entry, current)
	if entry.USER_UNIT == service then
		local value = lifecycle[entry.MESSAGE_ID]
		if value then
			current.running = value == "syncing"
			current.invocation = entry.USER_INVOCATION_ID
			update(value)
		end
		return
	end
	if not current.running or not current.invocation or entry._SYSTEMD_INVOCATION_ID ~= current.invocation then
		return
	end
	local message = entry.MESSAGE or ""
	if message == "Fully synced" then
		for _, buf in ipairs(vim.api.nvim_list_bufs()) do
			if vim.api.nvim_buf_is_loaded(buf) and is_vault(buf) and not vim.bo[buf].modified then
				vim.cmd("checktime " .. buf)
			end
		end
		update("synced")
	elseif
		message:match("^Error:")
		or message:match("^Sync error:")
		or message == "Disconnected from server"
		or message == "Waiting to connect to server"
		or message == "The connection to the server has encountered an error."
	then
		update("error")
	elseif
		message:match("^Uploading file ")
		or message:match("^Upload complete ")
		or message:match("^Downloading ")
		or message:match("^Downloaded ")
		or message == "Connecting..."
		or message == "Connection successful. Detecting changes..."
	then
		update("syncing")
	end
end

local function start()
	local seconds, micros = vim.uv.gettimeofday()
	local current = {}
	session = current
	-- Replay only events since this observation began, never an older invocation's health
	local since = string.format("@%d.%06d", seconds, micros)
	current.show = vim.system(
		{ "systemctl", "--user", "show", service, "--property=InvocationID,ActiveState,LoadState" },
		{
			text = true,
			timeout = 5000,
		},
		vim.schedule_wrap(function(result)
			if session ~= current then
				return
			end
			current.show = nil
			if result.stdout:match("LoadState=not%-found") then
				available = false
				update("unknown")
				return
			end
			if result.code == 0 then
				current.invocation = result.stdout:match("InvocationID=([%x]+)")
				local active = result.stdout:match("ActiveState=(%a+)")
				current.running = active == "active" or active == "activating" or active == "reloading"
				update(current.running and "unknown" or "error")
			end
			local pending = ""
			current.journal = vim.fn.jobstart({
				"journalctl",
				"--user",
				"-u",
				service,
				"-b",
				"-f",
				"-o",
				"json",
				"--since",
				since,
				"--no-tail",
				"--no-pager",
			}, {
				on_stdout = function(_, data)
					if session ~= current then
						return
					end
					data[1] = pending .. data[1]
					pending = data[#data]
					for i = 1, #data - 1 do
						if data[i] ~= "" then
							consume(vim.json.decode(data[i]), current)
						end
					end
				end,
				on_exit = function()
					if session == current then
						current.journal = nil
						update("unknown")
					end
				end,
			})
			if current.journal <= 0 then
				current.journal = nil
				update("unknown")
			end
		end)
	)
end

local function stop()
	local current = session
	session = nil
	if current then
		if current.show then
			current.show:kill(15)
		end
		if current.journal then
			vim.fn.jobstop(current.journal)
		end
	end
	update("unknown")
end

local function refresh()
	local loaded = false
	for _, buf in ipairs(vim.api.nvim_list_bufs()) do
		if vim.api.nvim_buf_is_loaded(buf) and is_vault(buf) then
			loaded = true
			break
		end
	end
	if available and loaded and not session then
		start()
	elseif not loaded and session then
		stop()
	end
	animate()
end

function M.status()
	local win = vim.g.statusline_winid or vim.api.nvim_get_current_win()
	if not available or not is_vault(vim.api.nvim_win_get_buf(win)) then
		return ""
	end
	local icons = { syncing = frames[frame], synced = "✓", error = "⚠", unknown = "·" }
	return "%=%#ObsidianSync_" .. state .. "# " .. icons[state] .. " %*"
end

local function highlights()
	for name, color in pairs({
		syncing = vim.g.terminal_color_5 or "#bb9af7",
		synced = vim.g.terminal_color_2 or "#9ece6a",
		error = vim.g.terminal_color_1 or "#f7768e",
		unknown = vim.g.terminal_color_8 or "#808080",
	}) do
		vim.api.nvim_set_hl(0, "ObsidianSync_" .. name, { fg = color })
	end
end

local group = vim.api.nvim_create_augroup("ObsidianSync", { clear = true })
vim.api.nvim_create_autocmd("ColorScheme", { group = group, callback = highlights })
vim.api.nvim_create_autocmd({
	"BufReadPost",
	"BufNewFile",
	"BufFilePost",
	"BufUnload",
	"BufWipeout",
	"BufEnter",
	"WinEnter",
	"WinClosed",
	"TabEnter",
}, {
	group = group,
	callback = function()
		vim.schedule(refresh)
	end,
})
vim.api.nvim_create_autocmd("VimLeavePre", { group = group, callback = stop })
highlights()
vim.schedule(refresh)

return M
