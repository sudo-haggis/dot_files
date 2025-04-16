-- PHP-specific LSP configuration

local M = {}

function M.setup(lspconfig, capabilities)
  -- PHP Language Server setup
  pcall(function()
    lspconfig.intelephense.setup{
      capabilities = capabilities,
      settings = {
        intelephense = {
          stubs = {
            "bcmath", "bz2", "calendar", "Core", "curl", "date", 
            "dba", "dom", "enchant", "fileinfo", "filter", "ftp", 
            "gd", "gettext", "hash", "iconv", "imap", "intl", 
            "json", "ldap", "libxml", "mbstring", "mysqli", "mysqlnd", 
            "oci8", "openssl", "pcntl", "pcre", "PDO", "pdo_mysql", 
            "pdo_pgsql", "pdo_sqlite", "pgsql", "Phar", "posix", 
            "pspell", "readline", "Reflection", "session", "shmop", 
            "SimpleXML", "snmp", "soap", "sockets", "sodium", "SPL", 
            "sqlite3", "standard", "superglobals", "sysvmsg", "sysvsem", 
            "sysvshm", "tidy", "tokenizer", "xml", "xmlreader", 
            "xmlrpc", "xmlwriter", "xsl", "Zend OPcache", "zip", "zlib"
          },
          stubsLocation = vim.fn.expand('~/.config/intelephense/stubs'),
          files = {
            maxSize = 5000000
          },
          environment = {
            phpVersion = "8.2.0"  -- Set to your version of PHP
          },
          completion = {
            insertUseDeclaration = true,
            fullyQualifyGlobalConstantsAndFunctions = false,
            maxItems = 100
          },
          format = {
            enable = true
          },
          telemetry = {
            enable = false
          },
          diagnostics = {
            enable = true,
            undefinedTypes = false,
            undefinedFunctions = false,
            undefinedConstants = false,
            undefinedMethods = false
          }
        }
      },
      init_options = {
        licenceKey = nil,
        showFunctionSignatures = true,
        showDocumentationInSignatureHelp = true
      }
    }
  end)
  
  -- PHP-specific autocommand
  vim.api.nvim_create_autocmd('FileType', {
    pattern = 'php',
    callback = function()
      -- Set keybindings
      vim.api.nvim_buf_set_keymap(0, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', { noremap = true, silent = true })
      vim.api.nvim_buf_set_keymap(0, 'n', '<leader>pd', '<cmd>lua vim.lsp.buf.definition()<CR>', { noremap = true, silent = true })
      vim.api.nvim_buf_set_keymap(0, 'n', '<leader>pr', '<cmd>lua vim.lsp.buf.references()<CR>', { noremap = true, silent = true })
      vim.api.nvim_buf_set_keymap(0, 'i', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', { noremap = true, silent = true })
      
      -- Start LSP if not running
      local bufnr = vim.api.nvim_get_current_buf()
      local clients = vim.lsp.get_active_clients({ bufnr = bufnr })
      if #clients == 0 then
        vim.defer_fn(function()
          pcall(vim.cmd, 'LspStart intelephense')
        end, 100)
      end
    end
  })
end

return M
