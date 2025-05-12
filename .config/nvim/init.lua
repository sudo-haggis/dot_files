-- Minimal init.lua that loads core modules
local function safe_require(module)
  local status, result = pcall(require, module)
  if not status then
    print("Could not load module: " .. module)
    return nil
  end
  return result
end

-- Load only core modules for Phase 1
safe_require('core.options')  -- Basic Vim options:w

safe_require('core.keymaps')  -- Global keymaps:w

-- Phase 2: Add plugin manager
safe_require('core.plugins')  -- Plugin definitions with Packer
