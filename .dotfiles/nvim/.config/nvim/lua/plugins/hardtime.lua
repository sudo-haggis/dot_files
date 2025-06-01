--hard time configuration

local M = {}

function M.setup()
    vim.g.hardtime_default_on = 1   --enabled by deault 
    vim.g.hardtime_showmsg = 1      --show the warning message
    vim.g.hardtime_allow_different_key = 1  --allow different keys
    vim.g.hardtime_maxcount = 2     -- Max repetitions before blockin'
end

M.setup()

return M
    
