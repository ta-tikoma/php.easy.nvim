local M = {}

function M.removeUnusedUses()
    local bufnr = 0
    local diagnostics = vim.diagnostic.get(bufnr)
    local lines = {}
    -- remember position
    local row, col = unpack(vim.api.nvim_win_get_cursor(0))

    -- collect from diagnostics
    for key, diagnostic in pairs(diagnostics) do
        if diagnostic.severity == vim.diagnostic.severity.HINT and diagnostic.code == 'P1003' then
            if vim.fn.getline(diagnostic.lnum + 1):sub(1, 3) == 'use' then
                table.insert(lines, diagnostic.lnum)
            end
        end
    end

    -- from down to up
    table.sort(lines, function(a, b) return a > b end)

    -- remove
    for key, line in pairs(lines) do
        if row <= line then
            row = row - 1
        end
        vim.cmd(':' .. (line + 1) .. 'd')
    end

    -- restore position
    vim.api.nvim_win_set_cursor(0, {row, col})
end

return M
