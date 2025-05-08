-- plugins/lsp/init.lua
-- Main LSP initialization module that loads all language servers

local lspconfig = require('lspconfig')
local common = require('plugins.lsp.common')

-- Setup shared handlers and diagnostics
common.setup_handlers()
common.setup_diagnostics()

-- Get capabilities once for all language servers
local capabilities = common.get_capabilities()

-- Function to safely load and initialize language modules
local function setup_language(module_name)
  local ok, module = pcall(require, module_name)
  if ok and module and type(module.setup) == "function" then
    module.setup(lspconfig, capabilities)
  else
    print("Failed to load LSP module: " .. module_name)
  end
end

-- Setup all language servers
setup_language('plugins.lsp.go')
setup_language('plugins.lsp.javascript')
setup_language('plugins.lsp.php')
setup_language('plugins.lsp.python')
setup_language('plugins.lsp.svelte')
setup_language('plugins.lsp.yaml')

-- Global LSP keymappings that work even when no LSP is attached
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist)

-- Print status information
local servers = lspconfig.util.available_servers()
print("Configured LSP servers: " .. table.concat(servers, ", "))

-- Create a command to restart all running LSP servers
vim.api.nvim_create_user_command("LspRestartAll", function()
  local clients = vim.lsp.get_active_clients()
  for _, client in ipairs(clients) do
    vim.lsp.buf_request(0, "shutdown", {})
    vim.lsp.buf_request(0, "exit", {})
  end
  
  vim.defer_fn(function()
    print("Restarting LSP servers...")
    -- Re-attach LSP for the current buffer
    local filetype = vim.bo.filetype
    if filetype == "python" then
      vim.cmd('LspStart pyright')
    elseif filetype == "javascript" or filetype == "typescript" or filetype == "javascriptreact" or filetype == "typescriptreact" then
      vim.cmd('LspStart tsserver')
    elseif filetype == "php" then
      vim.cmd('LspStart intelephense')
    elseif filetype == "go" then
      vim.cmd('LspStart gopls')
    elseif filetype == "svelte" then
      vim.cmd('LspStart svelte')
    elseif filetype == "yaml" then
      vim.cmd('LspStart yamlls')
    end
  end, 500)
end, {})

-- Create a command to show LSP status information
vim.api.nvim_create_user_command("LspStatus", function()
  local clients = vim.lsp.get_active_clients()
  if #clients == 0 then
    print("No LSP clients running")
    return
  end
  
  for _, client in ipairs(clients) do
    print(string.format("LSP: %s (id: %d) - Attached buffers: %s",
      client.name,
      client.id,
      table.concat(vim.tbl_keys(client.attached_buffers or {}), ", ")
    ))
  end
end, {})

-- Create an autocommand to check LSP status on BufEnter
vim.api.nvim_create_autocmd("BufEnter", {
  callback = function()
    local filetype = vim.bo.filetype
    local lsp_filetypes = {
      ["python"] = "pyright",
      ["javascript"] = "tsserver",
      ["typescript"] = "tsserver",
      ["javascriptreact"] = "tsserver",
      ["typescriptreact"] = "tsserver",
      ["php"] = "intelephense", 
      ["go"] = "gopls",
      ["svelte"] = "svelte",
      ["yaml"] = "yamlls"
    }
    
    if lsp_filetypes[filetype] then
      vim.defer_fn(function()
        local clients = vim.lsp.get_active_clients({ bufnr = 0 })
        if #clients == 0 then
          local server = lsp_filetypes[filetype]
          print("No LSP clients attached. Starting " .. server .. "...")
          vim.cmd('LspStart ' .. server)
        end
      end, 1000)
    end
  end
})

local M = {}

M.setup = function()
  vim.notify("Setting up LSP...", vim.log.levels.INFO)
  
  -- Load language-specific configurations
  require('plugins.lsp.common').setup()
  require('plugins.lsp.go').setup()
  require('plugins.lsp.php').setup()
  require('plugins.lsp.yaml').setup()
  require('plugins.lsp.javascript').setup()
  require('plugins.lsp.python').setup()
  require('plugins.lsp.svelte').setup()
  
  vim.notify("LSP setup complete", vim.log.levels.INFO)
end

return M
