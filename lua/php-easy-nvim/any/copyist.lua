local M = {}

M.uses = {}

local function extract_name(s)
    local last_bs = s:match(".*()[ \\\\]")
    if not last_bs then return nil end
    local semipos = s:find(";", last_bs)
    if not semipos or semipos <= last_bs then return nil end
    return s:sub(last_bs + 1, semipos - 1)
end

local function find_names(s)
    local res = {}
    for word in s:gmatch("%f[%a][A-Z][A-Za-z0-9]*%f[%A]") do
        table.insert(res, word)
    end
    return res
end

local function find_uses()
    local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
    local uses = {}
    local last = 0;
    for i, line in ipairs(lines) do
        if line:match("^use%s.*;$") then
            local name = extract_name(line)
            if name then
                uses[name] = line;
                last = i
            end
        end
    end

    return uses, last
end

function M.setup()
    vim.api.nvim_create_autocmd("TextYankPost", {
        pattern = "*.php",
        callback = function(ev)
            M.uses = find_uses()
        end,
    })
end

function M.paste(command)
    local names = find_names(vim.fn.getreg('"'))

    command = command or 'normal! p'
    vim.cmd(command)

    local uses, last = find_uses()
    for i, name in ipairs(names) do
        if uses[name] == nil then
            if M.uses[name] ~= nil then
                vim.api.nvim_buf_set_lines(0, last, last, false, { M.uses[name] })
            end
        end
    end

    M.uses = {}
end

return M
