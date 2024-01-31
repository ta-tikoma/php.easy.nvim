local Config = require('php-easy-nvim.any.config')
local Helper = require('php-easy-nvim.any.helper')

local M = {}

local function SelectMethod()
    vim.cmd([[normal! j]])
    vim.fn.search(Config.regex.method, 'b')
    -- go to docBlock
    vim.cmd([[normal! k]])
    Helper.goToCommentStart()

    vim.cmd([[normal! V]])
    vim.fn.search(Config.regex.methodEnd, 'e')
end

function M.docBlock()
    vim.cmd([[normal! k]])

    if Helper.currentLineMatch(Config.regex.commentEnd) then
        vim.cmd([[
            normal! O
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

function M.replica()
    M.copy()

    vim.fn.search(Config.regex.methodEnd, 'e')
    vim.cmd([[
        normal! o
        normal! pzz
    ]])
    vim.fn.search(Config.regex.method, 'e')
    vim.cmd([[
        normal! wdw
        startinsert
    ]])
end

function M.copy()
    SelectMethod()
    vim.cmd([[normal! y]])
end

function M.delete()
    SelectMethod()
    vim.cmd([[normal! d]])
end

function M.construct()
    vim.cmd([[normal! gg]])

    -- check exists construct
    if vim.fn.search(Config.regex.construct, 'ew') == 0 then
        -- check exists eny method
        if vim.fn.search(Config.regex.method) == 0 then
            vim.cmd([[normal G]])
        else
            vim.cmd([[normal! k]])
            if Helper.currentLineMatch(Config.regex.commentEnd) then
                vim.fn.search(Config.regex.comment, 'b')
            else
                vim.cmd([[normal! j]])
            end
        end

        -- add constant
        vim.cmd([[
            normal! Opublic function __construct()
            normal! o{
            normal! o}
        ]])

        vim.fn.search('public function __construct(', 'ew')
    end

    local argument = require('php-easy-nvim.any.entities.argument')
    argument.insert()
end

function M.append()
    vim.cmd([[normal G]])
    if vim.fn.search(Config.regex.methodEnd, 'b') == 0 then
        vim.fn.search('^}')
        vim.cmd([[
            normal! O
            normal! o
            normal! o
            normal! k
        ]])
    else
        vim.cmd([[
            normal! o
            normal! o
        ]])
    end

    vim.fn.setreg('p', Config.regex.tab .. Config.onAppend.putTemplate.method)
    vim.cmd([[
        normal "pP
        startinsert!
    ]])
end

return M
