-- Plugin configuration with Packer
-- Phase 2: Basic plugin manager setup

-- Bootstrap packer if not installed
local fn = vim.fn
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'

if fn.empty(fn.glob(install_path)) > 0 then
  fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
  print "Installing packer.nvim..."
  vim.cmd [[packadd packer.nvim]]
end

-- Initialize packer explicitly
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
  
  -- add vim-tmux-navigator for seamless navigation vim <> tmux
  use 'christoomey/vim-tmux-navigator'

  --breakbad vim habits with HardTimeVIM
  use 'takac/vim-hardtime'

  --show handy keybindings
  use 'folke/which-key.nvim'

  --Completion Engine 
  use 'hrsh7th/nvim-cmp'         -- Autocompletion plugin
  use 'hrsh7th/cmp-nvim-lsp'     -- LSP source for nvim-cmp
  use 'hrsh7th/cmp-buffer'       -- Buffer completions
  use 'hrsh7th/cmp-path'         -- Path completions
  use 'hrsh7th/cmp-cmdline'      -- Command line completions
  use 'saadparwaiz1/cmp_luasnip' -- Snippet completions
  use 'L3MON4D3/LuaSnip'         -- Snippet engine

end)

-- Register Packer commands
vim.cmd([[
  command! PackerCompile lua require('packer').compile()
  command! PackerInstall lua require('packer').install() 
  command! PackerUpdate lua require('packer').update()
  command! PackerSync lua require('packer').sync()
  command! PackerClean lua require('packer').clean()
]])
