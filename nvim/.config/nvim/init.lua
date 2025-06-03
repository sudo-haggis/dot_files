-- Minimal init.lua that loads core modules
local utils = require("core.utils")

-- Load only core modules for Phase 1
utils.safe_require("core.options") -- Basic Vim options:w

utils.safe_require("core.keymaps") -- Global keymaps:w

-- Phase 2: Add plugin manager
utils.safe_require("core.plugins") -- Plugin definitions with Packer

-- Phase 3: Add UI and theme settings
utils.safe_require("core.theme") -- UI and theme settings

-- EXTRA add hardtime to make vim harde... adn me better eh?
utils.safe_require("plugins.hardtime")

-- EXTRA add which key for bindings remindings matey!
utils.safe_require("plugins.whichkey")

-- Phase 5 Completion Engine ENGAGE!!!
utils.safe_require("plugins.completion")

-- Phase 6 add LSP - common
utils.safe_require("plugins.lsp-common")
-- add python LSP
utils.safe_require("plugins.lsp.python")
-- add lua LSP
--utils.safe_require("plugins.lsp.lua")
-- add GO LSP
utils.safe_require("plugins.lsp.go")
-- add YAML LSP
utils.safe_require("plugins.lsp.yaml")

-- Phase 7 add TreesSitter configuration
utils.safe_require("plugins.treesitter")

-- Multi language formatting tool, conform.
utils.safe_require("plugins.formatting")
-- linting support - Ruff
-- utils.safe_require('plugins.linting')
