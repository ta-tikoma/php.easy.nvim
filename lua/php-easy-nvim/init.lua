local M = {}

function M.setup(conf)
    local Config = require('php-easy-nvim.any.config')
    Config.setup(conf)

    local orchestrator = require('php-easy-nvim.any.orchestrator')
    local object = require('php-easy-nvim.any.entities.object')
    local method = require('php-easy-nvim.any.entities.method')
    local argument = require('php-easy-nvim.any.entities.argument')
    local constant = require('php-easy-nvim.any.entities.constant')
    local property = require('php-easy-nvim.any.entities.property')
    local formatter = require('php-easy-nvim.any.formatter')

    vim.api.nvim_create_user_command('PHPEasyDocBlock', function() orchestrator.docBlock() end, {})
    vim.api.nvim_create_user_command('PHPEasyReplica', function() orchestrator.replica() end, {})
    vim.api.nvim_create_user_command('PHPEasyCopy', function() orchestrator.copy() end, {})
    vim.api.nvim_create_user_command('PHPEasyDelete', function() orchestrator.delete() end, {})

    vim.api.nvim_create_user_command('PHPEasyInitInterface', function() object.initInterface() end, {})
    vim.api.nvim_create_user_command('PHPEasyInitClass', function() object.initClass() end, {})
    vim.api.nvim_create_user_command('PHPEasyInitAbstractClass', function() object.initAbstractClass() end, {})
    vim.api.nvim_create_user_command('PHPEasyInitTrait', function() object.initTrait() end, {})
    vim.api.nvim_create_user_command('PHPEasyInitEnum', function() object.initEnum() end, {})
    vim.api.nvim_create_user_command('PHPEasyRemoveUnusedUses', function() formatter.removeUnusedUses() end, {})
    vim.api.nvim_create_user_command('PHPEasyImplements', function() object.implements() end, {})
    vim.api.nvim_create_user_command('PHPEasyExtends', function() object.extends() end, {})

    vim.api.nvim_create_user_command('PHPEasyAppendConstruct', function() method.construct() end, {})
    vim.api.nvim_create_user_command('PHPEasyAppendInvoke', function() method.invoke() end, {})

    vim.api.nvim_create_user_command('PHPEasyAppendConstant', function() constant.append() end, {})
    vim.api.nvim_create_user_command('PHPEasyAppendProperty', function() property.append() end, {})
    vim.api.nvim_create_user_command('PHPEasyAppendMethod', function() method.append() end, {})
    vim.api.nvim_create_user_command('PHPEasyAppendArgument', function() argument.append() end, {})
end

return M
