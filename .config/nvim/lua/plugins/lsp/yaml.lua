-- YAML-specific LSP configuration

local M = {}

function M.setup(lspconfig, capabilities)
  -- YAML Language Server setup
  pcall(function()
    lspconfig.yamlls.setup{
      capabilities = capabilities,
      settings = {
        yaml = {
          schemas = {
            [vim.fn.expand("~/.config/schemas/docker-compose-schema.json")] = "/*docker-compose*.{yml,yaml}",
            ["https:--json.schemastore.org/github-workflow.json"] = "/.github/workflows/*",
          },
        },
      }
    }
  end)
end

return M
