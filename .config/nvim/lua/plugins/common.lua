

-- Main Neovim configuration entry point

-- Load core modules
require('core.options')      -- Basic Vim options
require('core.keymaps')      -- Global keymaps 
require('core.plugins')      -- Plugin definitions with Packer

-- Load plugin configurations
require('plugins.completion') -- Completion setup
require('plugins.lsp')       -- LSP configurations
require('plugins.treesitter') -- Treesitter configuration
require('plugins.go')        -- Go-specific config
require('plugins.fzf')       --adding fuzzeehh
