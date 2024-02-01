local Helper = require('php-easy-nvim.any.helper')
local Config = require('php-easy-nvim.any.config')

local M = {}

function M.insert()
    local close = vim.fn.search(')')
    local open = vim.fn.match(vim.fn.getline('.'), '(')
    if open ~= -1 then -- one line
        vim.cmd([[startinsert]])
    else -- multiline
        vim.cmd([[normal! k]])

        if not Helper.currentLineMatch(',') then
            vim.cmd([[normal! A,]])
        end

        vim.cmd([[
            normal o 
            startinsert
        ]])
    end
end

function M.append()
    vim.fn.search(Config.regex.method, 'bew')
    M.insert()
end

return M
