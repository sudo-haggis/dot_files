-- lua/plugins/lsp/python.lua
-- Python Language Server Configuration using Pyright


-- Load LSP config and common setup
local utils = require('core.utils')
local lspconfig = utils.safe_require('lspconfig')
local lsp_common = utils.safe_require('plugins.lsp-common')

if not lspconfig or not lsp_common then
    return
end

-- Python/Pyright specific configuration
local python_config = {
    -- Use common LSP setup (keybindings, capabilities, etc.)
    on_attach = lsp_common.on_attach,
    capabilities = lsp_common.capabilities,
    
    -- Pyright specific settings
    settings = {
        python = {
            analysis = {
                -- Type checking mode: "off", "basic", "strict"
                typeCheckingMode = "basic",
                
                -- Auto-import completions
                autoImportCompletions = true,
                
                -- Auto-search paths
                autoSearchPaths = true,
                
                -- Use library code for types
                useLibraryCodeForTypes = true,
                
                -- Diagnostic mode: "workspace" or "openFilesOnly"
                diagnosticMode = "workspace",
                
                -- Additional stub paths (useful for custom packages)
                stubPath = "./typings",
            },
            
            -- Python path configuration
            pythonPath = nil, -- Let pyright auto-detect
            
            -- Virtual environment configuration
            venvPath = nil, -- Auto-detect virtual environments
        }
    },
    
    -- File types to attach to
    filetypes = { "python" },
    
    -- Root directory detection
    root_dir = lspconfig.util.root_pattern(
        "pyproject.toml",
        "setup.py", 
        "setup.cfg",
        "requirements.txt",
        "Pipfile",
        ".git"
    ),
    
    -- Single file support
    single_file_support = true,
}

-- Setup Pyright LSP
lspconfig.pyright.setup(python_config)

-- Python-specific autocommands
local python_group = vim.api.nvim_create_augroup("PythonLSP", { clear = true })

-- Auto-format on save (optional - can be disabled if using separate formatter)
vim.api.nvim_create_autocmd("BufWritePre", {
    group = python_group,
    pattern = "*.py",
    callback = function()
        -- Only format if LSP is active and supports formatting
        local clients = vim.lsp.get_active_clients({ bufnr = 0 })
        for _, client in ipairs(clients) do
            if client.name == "pyright" and client.server_capabilities.documentFormattingProvider then
                vim.lsp.buf.format({ async = false })
            end
        end
    end,
})

-- Enhanced Python-specific keybindings (in addition to common LSP ones)
vim.api.nvim_create_autocmd("FileType", {
    group = python_group,
    pattern = "python",
    callback = function()
        local opts = { noremap = true, silent = true, buffer = true }
        
        -- Python-specific mappings
        vim.keymap.set('n', '<leader>po', ':PyrightOrganizeImports<CR>', 
            vim.tbl_extend('force', opts, { desc = 'Organize Python imports' }))
    end,
})

-- Diagnostic configuration for Python
vim.diagnostic.config({
    virtual_text = {
        prefix = '●',
        source = "if_many",
    },
    signs = true,
    underline = true,
    update_in_insert = false,
    severity_sort = true,
    float = {
        source = "always",
        border = "rounded",
    },
}, vim.api.nvim_create_namespace("python_diagnostics"))

-- Success notification
vim.notify("Python LSP (Pyright) configured successfully! 🐍", vim.log.levels.INFO)
