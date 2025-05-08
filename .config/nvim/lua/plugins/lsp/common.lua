-- plugins/lsp/common.lua
-- Central shared LSP functionality with consistent keybindings across all languages

local M = {}

-- Get standardized capabilities for all language servers
function M.get_capabilities()
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  
  -- Enhance with nvim-cmp capabilities if available
  local has_cmp, cmp_nvim_lsp = pcall(require, 'cmp_nvim_lsp')
  if has_cmp then
    capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
  end
  
  -- Ensure completion capabilities explicitly enabled
  capabilities.textDocument.completion.completionItem.snippetSupport = true
  capabilities.textDocument.completion.completionItem.resolveSupport = {
    properties = {
      'documentation',
      'detail',
      'additionalTextEdits',
    }
  }
  
  return capabilities
end

-- Common on_attach function for all language servers with consistent keybindings
function M.on_attach(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
  
  -- CONSISTENT KEYBINDINGS FOR ALL LANGUAGES
  local opts = { noremap = true, silent = true, buffer = bufnr }
  
  -- Documentation and information
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)                       -- Hover documentation
  vim.keymap.set('i', '<C-k>', vim.lsp.buf.signature_help, opts)          -- Signature help in insert mode
  
  -- Navigation
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)                 -- Go to definition
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)                 -- Find references
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)             -- Go to implementation
  vim.keymap.set('n', 'gt', vim.lsp.buf.type_definition, opts)            -- Go to type definition
  
  -- Refactoring and editing
  vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)             -- Rename symbol
  vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)        -- Code actions
  vim.keymap.set('n', '<leader>f', function() 
    vim.lsp.buf.format({ async = true }) 
  end, opts)                                                              -- Format document
  
  -- Diagnostics
  vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)               -- Previous diagnostic
  vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)               -- Next diagnostic
  vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, opts)       -- Show diagnostic in float window
  vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, opts)       -- Add diagnostics to location list
  
  -- Workspace
  vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, opts)     -- Add workspace folder
  vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, opts)  -- Remove workspace folder
  vim.keymap.set('n', '<leader>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, opts)                                                               -- List workspace folders
  
  -- Set formatting on save if the client supports it
  if client.server_capabilities.documentFormattingProvider then
    vim.api.nvim_create_autocmd("BufWritePre", {
      buffer = bufnr,
      callback = function() 
        vim.lsp.buf.format({ bufnr = bufnr }) 
      end,
    })
  end
  
  -- Print confirmation
  print(client.name .. " attached to buffer " .. bufnr)
end

-- Setup diagnostic display (shared across all LSPs)
function M.setup_diagnostics()
  vim.diagnostic.config({
    virtual_text = true,
    signs = true,
    underline = true,
    update_in_insert = false,
    severity_sort = true,
    float = {
      border = "rounded",
      source = "always",
    },
  })
  
  -- Set diagnostic signs
  local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
  for type, icon in pairs(signs) do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
  end
end

-- Setup handlers (shared across all LSPs)
function M.setup_handlers()
  -- Nicer hover window
  vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
    vim.lsp.handlers.hover, {
      border = "rounded",
      width = 60
    }
  )
  
  -- Nicer signature help
  vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
    vim.lsp.handlers.signature_help, {
      border = "rounded",
      width = 60
    }
  )
end

-- Helper to create language-specific server setup with consistent base
function M.make_config(server_name, extra_settings)
  -- Get standard capabilities
  local capabilities = M.get_capabilities()
  
  -- Base configuration all servers should have
  local config = {
    capabilities = capabilities,
    flags = {
      debounce_text_changes = 150,
    },
    on_attach = M.on_attach  -- Consistent keybindings for all languages
  }
  
  -- Merge in any extra settings
  if extra_settings then
    config.settings = extra_settings
  end
  
  return config
end

return M
