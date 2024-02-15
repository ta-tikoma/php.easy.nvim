local Config = require('php-easy-nvim.any.config')

local M = {}

function M.currentLineMatch(regex)
    return vim.fn.match(vim.fn.getline('.'), regex) ~= -1
end

function M.goToCommentStart()
    if M.currentLineMatch(Config.regex.commentEnd) then
        vim.fn.search(Config.regex.comment, 'b')
    else
        vim.cmd([[normal! j]])
    end
end

function M.getFirstSelectedText()
    if vim.fn.mode() ~= 'v' then
        return nil
    end

    local curpos = vim.fn.getcurpos() 
    local one = { row = curpos[2] - 1, col = curpos[3] } 
    local two = { row = vim.fn.line('v') - 1, col = vim.fn.col('v') - 1 }

    vim.cmd([[normal! v]])

    if one.row == two.row then
        if one.col < two.col then
            return vim.api.nvim_buf_get_text(0, one.row, one.col, two.row, two.col, {})[1]
        elseif one.col > two.col then
            return vim.api.nvim_buf_get_text(0, two.row, two.col, one.row, one.col, {})[1]
        end
    elseif one.row < two.row then
        return vim.api.nvim_buf_get_text(0, one.row, one.col, two.row, two.col, {})[1]
    elseif one.row > two.row then
        return vim.api.nvim_buf_get_text(0, two.row, two.col, one.row, one.col, {})[1]
    end
end

return M
