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

function M.attribute()
    vim.fn.setreg('p', Config.regex.tab .. '#[]\n')
    vim.cmd([[
        normal "pP^ll
        startinsert
    ]])
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

        -- add construct
        if Config.onAppend.engine == 'default' then
            vim.cmd([[
                normal! Opublic function __construct()
                normal! o{
                normal! o}
            ]])
            vim.fn.search('public function __construct(', 'ew')

            local argument = require('php-easy-nvim.any.entities.argument')
            argument.insert()
        elseif Config.onAppend.engine == 'LuaSnip' then
            local ls = require("luasnip")
            local s = ls.snippet
            local t = ls.text_node
            local i = ls.insert_node
            ls.snip_expand(s('construct', {
                t("\tpublic function __construct("), i(1), t(')'),
                t({'', "\t{", "\t\t"}),
                i(2),
                t({'', "\t}", ''})
            }))
        end
    else
        local argument = require('php-easy-nvim.any.entities.argument')
        argument.insert()
    end
end

function M.invoke()
    vim.cmd([[normal! gg]])

    -- check exists invoke
    if vim.fn.search(Config.regex.invoke, 'ew') == 0 then
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

        -- add invoke
        if Config.onAppend.engine == 'default' then
            vim.cmd([[
                normal! Opublic function __invoke()
                normal! o{
                normal! o}
            ]])
            vim.fn.search('public function __invoke(', 'ew')

            local argument = require('php-easy-nvim.any.entities.argument')
            argument.insert()
        elseif Config.onAppend.engine == 'LuaSnip' then
            local ls = require("luasnip")
            local s = ls.snippet
            local t = ls.text_node
            local i = ls.insert_node
            ls.snip_expand(s('invoke', {
                t("\tpublic function __invoke("), i(1), t(')'),
                t({'', "\t{", "\t\t"}),
                i(2),
                t({'', "\t}", ''})
            }))
        end
    else
        local argument = require('php-easy-nvim.any.entities.argument')
        argument.insert()
    end
end

function M.append()
    local selected = Helper.getFirstSelectedText()

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

    if Config.onAppend.engine == 'default' then
        if selected == nil then
            vim.fn.setreg('p', Config.regex.tab .. 'private function \n' .. Config.regex.tab .. '{\n' .. Config.regex.tab .. '\n' .. Config.regex.tab .. '}')
        else
            vim.fn.setreg('p', Config.regex.tab .. 'private function ' .. selected .. '\n' .. Config.regex.tab .. '{\n' .. Config.regex.tab .. '\n' .. Config.regex.tab .. '}')
        end

        vim.cmd([[
            normal "pP
            startinsert!
        ]])
    elseif Config.onAppend.engine == 'LuaSnip' then
        local ls = require("luasnip")
        local s = ls.snippet
        local t = ls.text_node
        local i = ls.insert_node
        local c = ls.choice_node

        if selected == nil then
            ls.snip_expand(s('function', {
                t('\t'), c(1, {
                    t('public'), 
                    t('protected'),
                    t('private')
                }), t(' function '), i(2), t('('), i(3), t('): '), i(4, 'void'),
                t({'', '\t{', '\t\t'}),
                i(5),
                t({'', '\t}', ''})
            }))
        else
            ls.snip_expand(s('function', {
                t('\t'), c(1, {
                    t('private'), 
                    t('protected'),
                    t('public')
                }), t(' function ' .. selected .. '('), i(2), t('): '), i(3, 'void'),
                t({'', '\t{', '\t\t'}),
                i(4),
                t({'', '\t}', ''})
            }))
        end
    end
end

return M
