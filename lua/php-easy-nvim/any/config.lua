local M = {}

M.regex = {}
M.onAppend = {}

local function getOrDefault(conf, key, default)
    local value = vim.tbl_get(conf, key)
    if value == nil then
        return default
    else
        return value
    end
end

local function buildRegex(conf)
    local tab = getOrDefault(conf, 'tab', '    ')
    local startTab = getOrDefault(conf, 'startTab', '^' .. tab)
    local visibility = getOrDefault(conf, 'visibility', startTab .. '\\(public\\|protected\\|private\\|\\)\\s\\{1}')
    local static = getOrDefault(conf, 'static', '\\(static\\s\\|\\)')
    local constant = getOrDefault(conf, 'constant', visibility .. 'const ')
    local property = getOrDefault(conf, 'property', visibility .. static .. '\\(?*\\w\\+\\s\\|\\)\\$')
    local method = getOrDefault(conf, 'method', visibility .. static .. 'function')
    local construct = getOrDefault(conf, 'construct', method .. ' __construct(')
    local methodEnd = getOrDefault(conf, 'methodEnd', startTab .. '}')
    local comment = getOrDefault(conf, 'comment', startTab .. '\\/')
    local commentMiddle = getOrDefault(conf, 'commentMiddle', startTab .. '\\*')
    local commentEnd = getOrDefault(conf, 'commentEnd', startTab .. '\\s\\*')
    local any = getOrDefault(conf, 'any', startTab .. '[p}]\\{1}')
    local variable = getOrDefault(conf, 'variable', '\\(' .. tab .. '\\)\\+\\$\\w\\+\\s\\{1}=\\s\\{1}')
    local object = getOrDefault(conf, 'object', '^\\(final class\\|abstract class\\|class\\|interface\\|trait\\|enum\\)\\s\\{1}')

    return {
         tab = tab,
         startTab = startTab,
         visibility = visibility,
         static = static,
         constant = constant,
         property = property,
         method = method,
         construct = construct,
         methodEnd = methodEnd,
         comment = comment,
         commentMiddle = commentMiddle,
         commentEnd = commentEnd,
         any = any,
         variable = variable,
         object = object
    }
end

function M.setup(conf)
    M.regex = buildRegex(getOrDefault(conf, 'regex', {}))

    local onSave = {removeUnusedUses = true} 
    onSave = vim.tbl_extend('force', onSave, conf.onSave or onSave)
    if onSave.removeUnusedUses == true then
        vim.api.nvim_create_autocmd('BufWritePre', {
            pattern = {'*.php'},
            callback = function()
                local formatter = require('php-easy-nvim.any.formatter')
                formatter.removeUnusedUses()
            end
        })
    end

    M.onAppend = {putTemplate = {
        constant = 'private const ;',
        method = 'private function \n' .. M.regex.tab .. '{\n' .. M.regex.tab .. '\n' .. M.regex.tab .. '}',
        property = 'private $;'
    }}
    M.onAppend = vim.tbl_extend('force', M.onAppend, conf.onAppend or M.onAppend)
end

return M
