local M = {}

function M.docBlock()
    local line = vim.fn.getline('.')
    local variable = string.match(line, '($%a+)')

    local types = {}
    for t in string.gmatch(line, '(%a+)::') do
        table.insert(types, t)
    end

    local type = ''
    if vim.tbl_count(types) > 0 then
        type = types[1]
    end

    vim.cmd('normal! O/** @var ' .. type .. ' ' .. variable .. ' */')

    if vim.tbl_count(types) == 0 then
        vim.cmd([[
            normal! ^fr2l
            startinsert
        ]])
    end
end

return M
