-- Basic Settings
vim.opt.number = true             -- Show line numbers
vim.opt.relativenumber = true     -- Show relative line numbers
vim.opt.mouse = 'a'               -- Enable mouse support
vim.opt.ignorecase = true         -- Case insensitive searching
vim.opt.smartcase = true          -- Case sensitive if caps used
vim.opt.wrap = false              -- Don't wrap lines
vim.opt.tabstop = 4               -- Tab width
vim.opt.shiftwidth = 4            -- Indent width
vim.opt.expandtab = true          -- Use spaces instead of tabs
vim.opt.clipboard = 'unnamedplus' -- Use system clipboard
vim.opt.termguicolors = true      -- Enable true color support
vim.opt.completeopt = 'menu,menuone,noselect'  -- Required for LSP

-- Set leader key to space
vim.g.mapleader = ' '

-- Bootstrap packer if not installed
local fn = vim.fn
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'

if fn.empty(fn.glob(install_path)) > 0 then
  fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
  print "Installing packer.nvim..."
  vim.cmd [[packadd packer.nvim]]
end

-- Initialize packer
vim.cmd [[packadd packer.nvim]]

-- Use protected require for Packer
local status_ok, packer = pcall(require, 'packer')
if not status_ok then
  print("Packer not found!")
  return
end

-- Plugin configuration
packer.startup(function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'
 
  -- Add vim-tmux-navigator
  use 'christoomey/vim-tmux-navigator'
  
  -- Theme
  use {
    'folke/tokyonight.nvim',
    config = function()
      vim.cmd[[colorscheme tokyonight-storm]]
    end
  }
  
  -- LSP and completion plugins - pinned to compatible version
  use {
    'neovim/nvim-lspconfig',
    tag = 'v0.1.7',  -- Pin to a specific version tag that works with your Neovim
    requires = {
      'hrsh7th/nvim-cmp',  -- Autocompletion plugin
      'hrsh7th/cmp-nvim-lsp', -- LSP source for nvim-cmp
    }
  }
  use 'hrsh7th/cmp-buffer'  -- Buffer completions
  use 'hrsh7th/cmp-path'    -- Path completions
  use 'L3MON4D3/LuaSnip'    -- Snippet engine
  use 'saadparwaiz1/cmp_luasnip' -- Snippet completions
  
  -- Go specific plugins
  use 'ray-x/go.nvim'
  use 'ray-x/guihua.lua' -- recommended for go.nvim
  
  -- Treesitter for better syntax highlighting
  use {
    'nvim-treesitter/nvim-treesitter',
    run = function()
      pcall(require('nvim-treesitter.install').update { with_sync = true })
    end,
  }
end)

-- Explicitly configure vim-tmux-navigator
vim.g.tmux_navigator_no_mappings = 1

-- Set explicit mappings for tmux navigation
vim.api.nvim_set_keymap('n', '<C-h>', '<cmd>TmuxNavigateLeft<CR>', { silent = true, noremap = true })
vim.api.nvim_set_keymap('n', '<C-j>', '<cmd>TmuxNavigateDown<CR>', { silent = true, noremap = true })
vim.api.nvim_set_keymap('n', '<C-k>', '<cmd>TmuxNavigateUp<CR>', { silent = true, noremap = true })
vim.api.nvim_set_keymap('n', '<C-l>', '<cmd>TmuxNavigateRight<CR>', { silent = true, noremap = true })
vim.api.nvim_set_keymap('n', '<C-\\>', '<cmd>TmuxNavigatePrevious<CR>', { silent = true, noremap = true })

-- Set up LSP and completion SAFELY with protected calls
local function setup_lsp_and_completion()
  -- Set up nvim-cmp
  local cmp_ok, cmp = pcall(require, 'cmp')
  if not cmp_ok then
    print("nvim-cmp not available")
    return
  end
  
  local luasnip_ok, luasnip = pcall(require, 'luasnip')
  if not luasnip_ok then
    print("LuaSnip not available")
    return
  end
  
  cmp.setup({
    snippet = {
      expand = function(args)
        luasnip.lsp_expand(args.body)
      end,
    },
    mapping = cmp.mapping.preset.insert({
      ['<C-b>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<C-e>'] = cmp.mapping.abort(),
      ['<CR>'] = cmp.mapping.confirm({ select = true }),
    }),
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      { name = 'luasnip' },
      { name = 'buffer' },
      { name = 'path' },
    })
  })
  
  -- Setup LSP
  local lspconfig_ok, lspconfig = pcall(require, 'lspconfig')
  if not lspconfig_ok then
    print("nvim-lspconfig not available")
    return
  end
  
  -- Make sure cmp_nvim_lsp is available before setting capabilities
  local capabilities
  local cmp_lsp_ok, cmp_nvim_lsp = pcall(require, 'cmp_nvim_lsp')
  if cmp_lsp_ok then
    capabilities = cmp_nvim_lsp.default_capabilities()
  end
  
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
  
  -- Set up gopls if available
  pcall(function()
    lspconfig.gopls.setup{
      capabilities = capabilities,
    }
  end)
end

-- Try to set up LSP and completion
pcall(setup_lsp_and_completion)

-- Set up go.nvim if available
pcall(function()
  require('go').setup()
end)

-- Set up treesitter if available
pcall(function()
  require('nvim-treesitter.configs').setup {
    ensure_installed = { "lua", "vim", "go", "php", "yaml", "json" },
    auto_install = true,
    highlight = {
      enable = true,
    },
  }
end)

-- Set up hover handler safely
pcall(function()
  vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
    border = "rounded",
  })
end)

-- The Go autocmd
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'go',
  callback = function()
    -- Start LSP if not running
    local bufnr = vim.api.nvim_get_current_buf()
    local clients = vim.lsp.get_active_clients({ bufnr = bufnr })
    if #clients == 0 then
      vim.defer_fn(function()
        pcall(vim.cmd, 'LspStart gopls')
      end, 100)
    end
    
    -- Set keybindings specific to Go
    vim.api.nvim_buf_set_keymap(0, 'n', '<leader>gt', '<cmd>lua vim.lsp.buf.type_definition()<CR>', { noremap = true, silent = true })
    vim.api.nvim_buf_set_keymap(0, 'n', '<leader>gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', { noremap = true, silent = true })
  end
})

-- The Arduino autocmd
vim.api.nvim_create_autocmd('FileType', {
  pattern = "arduino",
  callback = function()
    vim.api.nvim_set_keymap('n', '<F5>', ':!arduino-cli compile --fqbn arduino:avr:uno %:p<CR>', { noremap = true, silent = false })
    vim.api.nvim_set_keymap('n', '<F6>', ':!arduino-cli upload -p /dev/ttyACM0 --fqbn arduino:avr:uno %:p<CR>', { noremap = true, silent = false })
  end
})

vim.api.nvim_create_autocmd({"BufNewFile", "BufRead"}, {
  pattern = "*.ino",
  callback = function()
    vim.bo.filetype = "arduino"
  end
})

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
