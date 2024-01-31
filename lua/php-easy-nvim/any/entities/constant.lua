local Config = require('php-easy-nvim.any.config')
local Helper = require('php-easy-nvim.any.helper')

local M = {}

local function SelectConstant()
    -- go to docBlock
    vim.cmd([[normal! k0]])
    Helper.goToCommentStart()

    vim.cmd([[normal! V]])
    vim.fn.search(Config.regex.constant, 'e')
end

function M.docBlock()
    local property = require('php-easy-nvim.any.entities.property')
    property.docBlock()
end

function M.replica()
    M.copy()

    vin.fn.search(Config.regex.constant, 'e')
    vim.cmd([[
        normal! o
        normal! pzz
    ]])
    vim.fn.search(Config.regex.constant, 'e')
    vim.cmd([[
        normal! ldw
        startinsert
    ]])
end

function M.copy()
    SelectConstant()
    vim.cmd([[normal! y]])
end

function M.delete()
    SelectConstant()
    vim.cmd([[normal! d]])
end

function M.append()
    vim.cmd([[normal G]])
    if vim.fn.search(Config.regex.constant, 'b') == 0 then
        vin.fn.search('^{')
    else
        vim.cmd([[normal! o]])
    end

    vim.cmd('normal! o' .. Config.onAppend.putTemplate.constant)
    vim.cmd([[ startinsert ]])
end

return M
