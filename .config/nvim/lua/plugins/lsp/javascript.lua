-- plugins/lsp/javascript.lua
-- JavaScript/TypeScript LSP configuration using consistent keybindings

local M = {}

function M.setup(lspconfig, _)
  -- Get common module
  local common = require('plugins.lsp.common')
  
  -- JavaScript/TypeScript settings
  local settings = {
    -- TypeScript settings
    typescript = {
      inlayHints = {
        includeInlayParameterNameHints = 'all',
        includeInlayParameterNameHintsWhenArgumentMatchesName = false,
        includeInlayFunctionParameterTypeHints = true,
        includeInlayVariableTypeHints = true,
        includeInlayPropertyDeclarationTypeHints = true,
        includeInlayFunctionLikeReturnTypeHints = true,
        includeInlayEnumMemberValueHints = true,
      },
      suggest = {
        completeFunctionCalls = true,
      },
    },
    -- JavaScript settings (same settings)
    javascript = {
      inlayHints = {
        includeInlayParameterNameHints = 'all',
        includeInlayParameterNameHintsWhenArgumentMatchesName = false,
        includeInlayFunctionParameterTypeHints = true,
        includeInlayVariableTypeHints = true,
        includeInlayPropertyDeclarationTypeHints = true,
        includeInlayFunctionLikeReturnTypeHints = true,
        includeInlayEnumMemberValueHints = true,
      },
      suggest = {
        completeFunctionCalls = true,
      },
    },
    -- Diagnostics settings
    diagnostics = {
      enable = true,
      reportUnusedVariable = true,
    },
    -- Code completion settings
    completions = {
      completeFunctionCalls = true,
    },
  }
  
  -- Setup tsserver with consistent configuration
  if lspconfig.tsserver then
    lspconfig.tsserver.setup(common.make_config("tsserver", settings))
    
    -- JavaScript/TypeScript specific settings via FileType autocommand
    vim.api.nvim_create_autocmd("FileType", {
      pattern = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
      callback = function()
        -- Set JS/TS indentation
        vim.bo.tabstop = 2
        vim.bo.shiftwidth = 2
        vim.bo.expandtab = true
        
        -- Check for LSP connection
        vim.defer_fn(function()
          local clients = vim.lsp.get_active_clients({ bufnr = 0 })
          if #clients == 0 then
            print("No LSP clients attached to JS/TS file. Starting tsserver...")
            vim.cmd('LspStart tsserver')
          end
        end, 1000)
      end
    })
  else
    print("TypeScript LSP server not available - Please install with: npm install -g typescript typescript-language-server")
  end
  
  -- Setup eslint language server if available
  if lspconfig.eslint then
    lspconfig.eslint.setup({
      on_attach = function(client, bufnr)
        common.on_attach(client, bufnr)
        
        -- Create autocommand for fixing on save
        vim.api.nvim_create_autocmd("BufWritePre", {
          buffer = bufnr,
          command = "EslintFixAll",
        })
      end,
      settings = {
        workingDirectory = { mode = "auto" },
        format = true,
      },
    })
  end
end

return M
