-- lua/core/utils.lua
-- Central utility functions for all Neovim configuration

local M = {}

-- Safe require function - prevents crashes if modules aren't available
function M.safe_require(module)
    local success, result = pcall(require, module)
    if not success then
        vim.notify("Failed to load " .. module .. ": " .. result, vim.log.levels.ERROR)
        return nil
    end
    return result
end

-- Check if a plugin is loaded
function M.is_plugin_loaded(plugin_name)
    return pcall(require, plugin_name)
end

-- Safe setup function - calls setup only if module loads successfully
function M.safe_setup(module_name, setup_function)
    local module = M.safe_require(module_name)
    if module and setup_function then
        local success, err = pcall(setup_function, module)
        if not success then
            vim.notify("Failed to setup " .. module_name .. ": " .. err, vim.log.levels.ERROR)
        end
        return success
    end
    return false
end

return M
