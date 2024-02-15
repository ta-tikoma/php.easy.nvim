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

    vim.fn.search(Config.regex.constant, 'e')
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
    local selected = Helper.getFirstSelectedText()

    vim.cmd([[normal G]])
    if vim.fn.search(Config.regex.constant, 'b') == 0 then
        vim.fn.search('^{')
    else
        vim.cmd([[normal! o]])
    end

    if Config.onAppend.engine == 'default' then
        if selected == nil then
            vim.cmd('normal! oprivate const ;')
        else
            vim.cmd('normal! oprivate const ' .. selected .. '= ;')
        end

        vim.cmd([[startinsert]])
    elseif Config.onAppend.engine == 'LuaSnip' then
        vim.cmd('normal! o')

        local ls = require("luasnip")
        local s = ls.snippet
        local t = ls.text_node
        local i = ls.insert_node
        local c = ls.choice_node

        if selected == nil then
            ls.snip_expand(s('constant', {
                t('\t'), c(1, {
                    t('private'), 
                    t('protected'),
                    t('public')
                }),
                t(' const '),  i(2), t(' = ') , i(3), t(';')
            }))
        else
            ls.snip_expand(s('constant', {
                t('\t'), c(1, {
                    t('private'), 
                    t('protected'),
                    t('public')
                }),
                t(' const ' .. selected .. ' = ') , i(2), t(';')
            }))
        end
    end
end

return M
