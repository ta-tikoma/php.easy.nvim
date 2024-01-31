local Config = require('php-easy-nvim.any.config')
local Helper = require('php-easy-nvim.any.helper')

local M = {}

local function SelectProperty()
    -- go to docBlock
    vim.cmd([[normal! k0]])
    Helper.goToCommentStart()

    vim.cmd([[normal! V]])
    vim.fn.search(Config.regex.property, 'e')
end

function M.docBlock()
    vim.cmd([[normal! k]])

    if Helper.currentLineMatch(Config.regex.commentEnd) then
        vim.cmd([[
            normal! o
            startinsert!
        ]])
    else
        vim.cmd([[normal! j]])
        vim.fn.setreg('p', Config.regex.tab .. '/**\n' .. Config.regex.tab .. ' * \n' .. Config.regex.tab .. ' */\n')
        vim.cmd([[
            normal "pPj
            startinsert!
        ]])
    end
end

function M.copy()
    SelectProperty()
    vim.cmd([[normal! y]])
end

function M.delete()
    SelectProperty()
    vim.cmd([[normal! d]])
end

function M.append()
    vim.cmd([[normal G]])
    if vim.fn.search(Config.regex.property, 'b') == 0 then
        vim.fn.search('^{')
    else
        vim.cmd([[normal! o]])
    end

    if Config.onAppend.putTemplate then
        vim.cmd([[
            normal! oprivate $;
            startinsert
        ]])
    else
        vim.cmd([[
            normal! o
            startinsert
        ]])
    end
end

return M
