-- Plugin configuration with Packer

-- Bootstrap packer if not installed
local fn = vim.fn
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'

if fn.empty(fn.glob(install_path)) > 0 then
  fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
  print "Installing packer.nvim..."
  vim.cmd [[packadd packer.nvim]]
end

-- Initialize packer
vim.cmd [[packadd packer.nvim]]

-- Use protected require for Packer
local status_ok, packer = pcall(require, 'packer')
if not status_ok then
  print("Packer not found!")
  return
end

-- Plugin configuration
packer.startup(function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'
 
  -- Add vim-tmux-navigator
  use 'christoomey/vim-tmux-navigator'
  
  -- Theme
  use {
    'folke/tokyonight.nvim',
    config = function()
      vim.cmd[[colorscheme tokyonight-storm]]
    end
  }
  
  -- LSP and completion plugins
  use {
    'neovim/nvim-lspconfig',
    tag = 'v0.1.7',  -- Pin to a specific version tag that works with your Neovim
  }
  
  -- Completion framework
  use 'hrsh7th/nvim-cmp'  -- Autocompletion plugin
  use 'hrsh7th/cmp-nvim-lsp' -- LSP source for nvim-cmp
  use 'hrsh7th/cmp-buffer'  -- Buffer completions
  use 'hrsh7th/cmp-path'    -- Path completions
  use 'L3MON4D3/LuaSnip'    -- Snippet engine
  use 'saadparwaiz1/cmp_luasnip' -- Snippet completions
  
  -- Go specific plugins
  use 'ray-x/go.nvim'
  use 'ray-x/guihua.lua' -- recommended for go.nvim
  
  -- JavaScript/TypeScript support
  use 'jose-elias-alvarez/null-ls.nvim'  -- Additional diagnostics
  use 'jose-elias-alvarez/typescript.nvim'  -- TypeScript enhancements
  
  -- Svelte support
  use 'evanleck/vim-svelte'  -- Svelte syntax highlighting and indentation
  use {
    'leafOfTree/vim-svelte-plugin',
    ft = 'svelte'  -- Only load for Svelte files
  }
  
  -- Treesitter for better syntax highlighting
  use {
    'nvim-treesitter/nvim-treesitter',
    run = function()
      pcall(require('nvim-treesitter.install').update { with_sync = true })
    end,
  }
end)
