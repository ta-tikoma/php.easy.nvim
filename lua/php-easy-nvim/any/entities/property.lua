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

function M.attribute()
    vim.fn.setreg('p', Config.regex.tab .. '#[]\n')
    vim.cmd([[
        normal "pP^ll
        startinsert
    ]])
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
    local selected = Helper.getFirstSelectedText()

    vim.cmd([[normal G]])
    if vim.fn.search(Config.regex.property, 'b') == 0 then
        vim.fn.search('^{')
    else
        vim.cmd([[normal! o]])
    end
 
    if Config.onAppend.engine == 'default' then
        if selected == nil then
            vim.cmd('normal! oprivate $;')
        else
            vim.cmd('normal! oprivate $' .. selected .. ';')
        end

        vim.cmd([[ startinsert ]])
    elseif Config.onAppend.engine == 'LuaSnip' then
        vim.cmd('normal! o')

        local ls = require("luasnip")
        local s = ls.snippet
        local t = ls.text_node
        local i = ls.insert_node
        local c = ls.choice_node

        if selected == nil then
            ls.snip_expand(s('property', {
                t('\t'), c(1, {
                    t('private'), 
                    t('protected'),
                    t('public')
                }), t(' '), i(2), t('$'), i(3), i(4, ' = '), i(5), t(';')
            }))
        else
            ls.snip_expand(s('property', {
                t('\t'), c(1, {
                    t('private'), 
                    t('protected'),
                    t('public')
                }), t(' '),  i(2), t('$' .. selected), i(3, ' = '), i(4), t(';')
            }))
        end
    end
end

return M
