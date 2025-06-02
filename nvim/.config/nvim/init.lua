-- Minimal init.lua that loads core modules
local function safe_require(module)
	local status, result = pcall(require, module)
	if not status then
		print("Could not load module: " .. module)
		return nil
	end
	return result
end

-- Load only core modules for Phase 1
safe_require("core.options") -- Basic Vim options:w

safe_require("core.keymaps") -- Global keymaps:w

-- Phase 2: Add plugin manager
safe_require("core.plugins") -- Plugin definitions with Packer

-- Phase 3: Add UI and theme settings
safe_require("core.theme") -- UI and theme settings

-- EXTRA add hardtime to make vim harde... adn me better eh?
safe_require("plugins.hardtime")

-- EXTRA add which key for bindings remindings matey!
safe_require("plugins.whichkey")

-- Phase 5 Completion Engine ENGAGE!!!
safe_require("plugins.completion")

-- Phase 6 add LSP - common
safe_require("plugins.lsp-common")
-- add python LSP
safe_require("plugins.lsp.python")
-- add lua LSP
--safe_require("plugins.lsp.lua")

-- Phase 7 add TreesSitter configuration
safe_require("plugins.treesitter")

-- Multi language formatting tool, conform.
safe_require("plugins.formatting")
-- linting support - Ruff
-- safe_require('plugins.linting')
