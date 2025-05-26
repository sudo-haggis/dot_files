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

-- ============================================================================
-- LSP Keymaps Reference (conditionally set in plugins/lsp-common.lua)
-- ============================================================================
-- These keymaps are only active when an LSP server is attached to a buffer
-- 
-- Navigation:
--   gd          - Go to definition
--   gr          - Find references  
--   gi          - Go to implementation
--   K           - Hover documentation
--
-- Leader mappings:
--   <leader>ca  - Code actions
--   <leader>rn  - Rename symbol
--   <leader>f   - Format document
--   <leader>e   - Show diagnostic details
--
-- Diagnostics:
--   [d          - Previous diagnostic
--   ]d          - Next diagnostic
--
-- Note: Check for conflicts with existing keymaps using :map <key>
-- ============================================================================
