--Global Keymappings

-- TMUX navigation configuration
-- Set this to 1 to disable default mappings and use our explicit ones below
vim.g.tmux_navigator_no_mappings = 1

-- Set explicit mappings for tmux navigation
vim.api.nvim_set_keymap('n', '<C-h>', '<cmd>TmuxNavigateLeft<CR>', { silent = true, noremap = true })
vim.api.nvim_set_keymap('n', '<C-j>', '<cmd>TmuxNavigateDown<CR>', { silent = true, noremap = true })
vim.api.nvim_set_keymap('n', '<C-k>', '<cmd>TmuxNavigateUp<CR>', { silent = true, noremap = true })
vim.api.nvim_set_keymap('n', '<C-l>', '<cmd>TmuxNavigateRight<CR>', { silent = true, noremap = true })
vim.api.nvim_set_keymap('n', '<C-\\>', '<cmd>TmuxNavigatePrevious<CR>', { silent = true, noremap = true })

-- Add a command to check LSP status
vim.api.nvim_set_keymap('n', '<leader>ls', '<cmd>LspInfo<CR>', { noremap = true, silent = true })


-- The Arduino autocmd (separate call)
vim.api.nvim_create_autocmd('FileType', {
  pattern = "arduino",
  callback = function()
    vim.api.nvim_set_keymap('n', '<F5>', ':!arduino-cli compile --fqbn arduino:avr:uno %:p<CR>', { noremap = true, silent = false })
    vim.api.nvim_set_keymap('n', '<F6>', ':!arduino-cli upload -p /dev/ttyACM0 --fqbn arduino:avr:uno %:p<CR>', { noremap = true, silent = false })
  end
})

-- General LSP keybindings (available in all LSP enabled buffers)
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    local bufnr = args.buf
    -- Set keybindings
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', { noremap = true, silent = true })
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', { noremap = true, silent = true })
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', { noremap = true, silent = true })
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', { noremap = true, silent = true })
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', { noremap = true, silent = true })
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', { noremap = true, silent = true })
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', { noremap = true, silent = true })
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', { noremap = true, silent = true })
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', { noremap = true, silent = true })
  end,
})
