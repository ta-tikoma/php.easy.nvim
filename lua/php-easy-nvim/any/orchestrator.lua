local Type = require('php-easy-nvim.any.type')
local Config = require('php-easy-nvim.any.config')
local Helper = require('php-easy-nvim.any.helper')

local M = {}

M.entities = {
    [Type.VARIABLE] = require('php-easy-nvim.any.entities.variable'),
    [Type.PROPERTY] = require('php-easy-nvim.any.entities.property'),
    [Type.CONSTANT] = require('php-easy-nvim.any.entities.constant'),
    [Type.OBJECT]   = require('php-easy-nvim.any.entities.object'),
    [Type.METHOD]   = require('php-easy-nvim.any.entities.method')
}

function M.itIs(options)
    local patterns = {
        [Config.regex.method]    = Type.METHOD,
        [Config.regex.methodEnd] = Type.METHOD,
        [Config.regex.constant]  = Type.CONSTANT,
        [Config.regex.property]  = Type.PROPERTY,
        [Config.regex.variable]  = Type.VARIABLE,
        [Config.regex.object]    = Type.OBJECT
    }

    -- if we on docblock go to end
    if Helper.currentLineMatch(Config.regex.commentMiddle) then
        vim.fn.search(Config.regex.commentEnd)
    end

    local positions = {}
    local currentPosition = vim.fn.line('.')

    -- find near entity
    for regex, type in pairs(patterns) do
        if vim.tbl_contains(options, type) then
            local position = vim.fn.search(regex, 'cnW')
            if position ~= 0 then
                positions[math.abs(position - currentPosition)] = {
                    type = type,
                    position = position
                }
            end

            local position = vim.fn.search(regex, 'bcnW')
            if position ~= 0 then
                positions[math.abs(position - currentPosition)] = {
                    type = type,
                    position = position
                }
            end
        end
    end

    local result = positions[math.min(unpack(vim.tbl_keys(positions)))]
    vim.fn.cursor(result.position, 0)
    
    return result.type
end

function M.attribute()
    local entity = M.itIs({
        Type.METHOD,
        Type.PROPERTY,
        Type.OBJECT
    })

    M.entities[entity].attribute(M.entities)
end

function M.docBlock()
    local entity = M.itIs({
        Type.METHOD,
        Type.CONSTANT,
        Type.PROPERTY,
        Type.VARIABLE,
        Type.OBJECT
    })

    M.entities[entity].docBlock(M.entities)
end

function M.copy()
    local entity = M.itIs({
        Type.METHOD,
        Type.CONSTANT,
        Type.PROPERTY,
    })

    M.entities[entity].copy(M.entities)
end

function M.replica()
    local entity = M.itIs({
        Type.METHOD,
        Type.CONSTANT,
        Type.PROPERTY,
    })

    M.entities[entity].replica(M.entities)
end

function M.delete()
    local entity = M.itIs({
        Type.METHOD,
        Type.CONSTANT,
        Type.PROPERTY,
    })

    M.entities[entity].delete(M.entities)
end

return M
