-- plugins/colorizer.lua
-- NvChad colorizer configuration (the working one!)

local utils = require("core.utils")

-- The NvChad version uses a different setup
local ok, colorizer = pcall(require, "colorizer")

if not ok then
	vim.notify("Colorizer plugin not found!", vim.log.levels.ERROR)
	return
end

-- NvChad colorizer setup
colorizer.setup({
	filetypes = {
		"css",
		"html",
		"javascript",
		"lua",
		"vim",
		"tmux",
	},
	user_default_options = {
		RGB = true, -- #RGB hex codes
		RRGGBB = true, -- #RRGGBB hex codes
		names = true, -- "Name" codes like Blue
		RRGGBBAA = false,
		rgb_fn = true, -- CSS rgb() and rgba() functions
		hsl_fn = true, -- CSS hsl() and hsla() functions
		css = true, -- Enable all CSS features
		css_fn = true, -- Enable all CSS *functions*
		mode = "background",
		tailwind = false,
		sass = { enable = false, parsers = { css = true } },
		virtualtext = "■",
	},
	buftypes = {},
})

vim.notify("NvChad Colorizer loaded! 🌈", vim.log.levels.INFO)
