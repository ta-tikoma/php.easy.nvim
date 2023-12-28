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

return M
