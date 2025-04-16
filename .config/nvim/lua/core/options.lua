-- Basic Settings
vim.opt.number = true             -- Show line numbers
vim.opt.relativenumber = true     -- Show relative line numbers
vim.opt.mouse = 'a'               -- Enable mouse support
vim.opt.ignorecase = true         -- Case insensitive searching
vim.opt.smartcase = true          -- Case sensitive if caps used
vim.opt.wrap = false              -- Don't wrap lines
vim.opt.tabstop = 4               -- Tab width
vim.opt.shiftwidth = 4            -- Indent width
vim.opt.expandtab = true          -- Use spaces instead of tabs
vim.opt.clipboard = 'unnamedplus' -- Use system clipboard
vim.opt.termguicolors = true      -- Enable true color support
vim.opt.completeopt = 'menu,menuone,noselect'  -- Required for LSP

-- Set leader key to space
vim.g.mapleader = ' '

-- Arduino file detection
vim.api.nvim_create_autocmd({"BufNewFile", "BufRead"}, {
  pattern = "*.ino",
  callback = function()
    vim.bo.filetype = "arduino"
  end
})
