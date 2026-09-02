local fallback = {
	plugin = {
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
				hl.StatusLine.bg = c.none
				hl.StatusLineNC.bg = c.none
			end,
		},
		config = function(_, opts)
			require("tokyonight").setup(opts)
			vim.cmd.colorscheme("tokyonight")
		end,
	},
}

local omarchy_current = vim.fn.expand("~/.local/state/omarchy/current")
local omarchy_theme = omarchy_current .. "/theme/neovim.lua"
local omarchy_theme_name = omarchy_current .. "/theme.name"

if vim.fn.filereadable(omarchy_theme) == 0 then
	return { fallback.plugin }
end

local function read_omarchy_theme()
	local plugin
	local colorscheme

	for _, spec in ipairs(dofile(omarchy_theme)) do
		if spec[1] == "LazyVim/LazyVim" then
			colorscheme = spec.opts.colorscheme
		else
			plugin = spec
		end
	end

	return assert(plugin, "Omarchy theme has no Neovim plugin"), assert(colorscheme, "Omarchy theme has no colorscheme")
end

local function plugin_name(spec)
	return spec.name or spec[1]:match("([^/]+)$")
end

local specs = {}
local plugins = {}

local function add_plugin(spec)
	local name = plugin_name(spec)
	if plugins[name] then
		return
	end

	plugins[name] = true
	specs[#specs + 1] = {
		spec[1],
		name = spec.name,
		branch = spec.branch,
		dependencies = spec.dependencies,
		lazy = true,
		priority = 1000,
	}
end

local theme_files = vim.fn.glob("/usr/share/omarchy/themes/*/neovim.lua", false, true)
table.insert(theme_files, "/usr/share/omarchy/default/themed/neovim.lua.tpl")
table.insert(theme_files, omarchy_theme)

for _, path in ipairs(theme_files) do
	for _, spec in ipairs(dofile(path)) do
		if spec[1] ~= "LazyVim/LazyVim" then
			add_plugin(spec)
		end
	end
end

specs[#specs + 1] = {
	name = "omarchy-theme",
	dir = vim.fn.stdpath("config"),
	lazy = false,
	priority = 999,
	config = function()
		local function apply_theme()
			local spec, colorscheme = read_omarchy_theme()
			local name = plugin_name(spec)

			require("lazy").load({ plugins = { name } })

			if spec.opts then
				local plugin = assert(require("lazy.core.config").plugins[name])
				local main = assert(require("lazy.core.loader").get_main(plugin))
				require(main).setup(spec.opts)
			end

			vim.cmd.colorscheme(colorscheme)
		end

		apply_theme()

		local watcher = assert(vim.uv.new_fs_event())
		local timer = assert(vim.uv.new_timer())

		assert(watcher:start(omarchy_theme_name, {}, function(error)
			assert(not error, error)
			timer:stop()
			timer:start(100, 0, vim.schedule_wrap(apply_theme))
		end))

		vim.api.nvim_create_autocmd("VimLeavePre", {
			once = true,
			callback = function()
				watcher:stop()
				watcher:close()
				timer:stop()
				timer:close()
			end,
		})
	end,
}

return specs
