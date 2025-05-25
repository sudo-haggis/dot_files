-- ==============================
-- TMUX NAvigation keymaps 
-- ==============================

--disable deafult tmux navigator mappings
vim.g.tmux_navigator_no_mappings = 1


-- explicit mappings for TMUX navigfation of the code seas
vim.api.nvim_set_keymap('n', '<C-h>', '<cmd>TmuxNavigateLeft<CR>', { silent = true, noremap = true })
vim.api.nvim_set_keymap('n', '<C-j>', '<cmd>TmuxNavigateDown<CR>', { silent = true, noremap = true })
vim.api.nvim_set_keymap('n', '<C-k>', '<cmd>TmuxNavigateUp<CR>', { silent = true, noremap = true })
vim.api.nvim_set_keymap('n', '<C-l>', '<cmd>TmuxNavigateRight<CR>', { silent = true, noremap = true })
vim.api.nvim_set_keymap('n', '<C-\\>', '<cmd>TmuxNavigatePrevious<CR>', { silent = true, noremap = true })
