-- File: plugins/fzf.lua
-- FZF and ripgrep configuration

-- Configure ripgrep as the default search tool
if vim.fn.executable('rg') == 1 then
  -- Set ripgrep as the default grep program
  vim.o.grepprg = 'rg --vimgrep --smart-case'
  -- Use ripgrep for fzf file finding
  vim.env.FZF_DEFAULT_COMMAND = 'rg --files --hidden --follow --glob "!.git/*"'
end

-- Better fzf layout with a popup window
vim.g.fzf_layout = {
  window = {
    width = 0.9,
    height = 0.8,
    border = 'rounded'
  }
}

-- Preview window settings
vim.g.fzf_preview_window = {'right:50%', 'ctrl-/'}

-- Create RgFzf command (similar to our shell function)
vim.cmd[[
command! -bang -nargs=* RgFzf
  \ call fzf#vim#grep(
  \   'rg --column --line-number --no-heading --color=always --smart-case -- '.shellescape(<q-args>), 1,
  \   fzf#vim#with_preview({
  \     'options': '--delimiter : --nth 4..',
  \     'window': {'width': 0.9, 'height': 0.6},
  \     'preview-window': 'up:60%'
  \   }), <bang>0)
]]

-- Key mappings - using different keys to avoid conflicts with LSP mappings
local opts = { noremap = true, silent = true }
vim.keymap.set('n', '<leader>ff', ':Files<CR>', opts)      -- "find files"
vim.keymap.set('n', '<leader>fg', ':RgFzf<CR>', opts)      -- "find grep"
vim.keymap.set('n', '<leader>fb', ':Buffers<CR>', opts)    -- "find buffers" 
vim.keymap.set('n', '<leader>fh', ':History<CR>', opts)    -- "find history"
