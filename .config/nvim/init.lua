

-- LSP Configuration
local lspconfig = require('lspconfig')

-- Get capabilities from cmp_nvim_lsp if available
local capabilities = vim.lsp.protocol.make_client_capabilities()
local has_cmp_lsp, cmp_lsp = pcall(require, 'cmp_nvim_lsp')
if has_cmp_lsp then
  capabilities = cmp_lsp.default_capabilities()
end

-- Load language-specific configurations
require('plugins.lsp.go').setup(lspconfig, capabilities)
require('plugins.lsp.javascript').setup(lspconfig, capabilities)
require('plugins.lsp.php').setup(lspconfig, capabilities)
require('plugins.lsp.python').setup(lspconfig, capabilities)  -- Add this line
require('plugins.lsp.svelte').setup(lspconfig, capabilities)
require('plugins.lsp.yaml').setup(lspconfig, capabilities)

-- Global LSP key mappings and handlers
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist)

-- LSP handlers configuration
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
  vim.lsp.handlers.hover, {
    border = "rounded",
    width = 60
  }
)

vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
  vim.lsp.handlers.signature_help, {
    border = "rounded",
    width = 60
  }
)

-- Display icons in diagnostic signs
local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

-- Configure diagnostic display
vim.diagnostic.config({
  virtual_text = true,
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
  float = {
    border = "rounded",
    source = "always",
    header = "",
    prefix = "",
  },
})
