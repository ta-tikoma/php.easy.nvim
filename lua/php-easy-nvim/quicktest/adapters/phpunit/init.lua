local Job = require("plenary.job")

---@class PHPUnitAdapterOptions
---@field command string Example: phpunit

local M = {
  name = "PHPUnit",
  ---@type PHPUnitAdapterOptions
  options = {}
}

---@class PHPUnitRunParams
---@field args string[]
---@field bufnr integer
---@field cursor_pos integer[]

--- Optional:
--- Builds parameters for running tests based on buffer number and cursor position.
--- This function should be customized to extract necessary information from the buffer.
---@param bufnr integer
---@param cursor_pos integer[]
---@return PHPUnitRunParams, nil | string
M.build_line_run_params = function(bufnr, cursor_pos)
  local buffer_name = vim.api.nvim_buf_get_name(bufnr)
  local path = vim.fn.fnamemodify(buffer_name, ":~:.")

  local Config = require('php-easy-nvim.any.config')
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  local regex = vim.regex(Config.regex.method)

  for i = 0, row - 1 do
    local s1, e1 = regex:match_line(bufnr, row - i)
    if s1 then
      local line = vim.api.nvim_buf_get_lines(bufnr, row - i, row - i + 1, false)[1]
      local s2, e2 = vim.regex('('):match_str(line)
      if s2 then
        local fn = string.sub(line, e1 + 2, s2)
        return {
          bufnr = bufnr,
          cursor_pos = cursor_pos,
          args = { '--filter', fn, path }
        }, nil
      end
    end
  end

  return nil, "No tests to run"
end

--- Optional:
---@param bufnr integer
---@param cursor_pos integer[]
---@return PHPUnitRunParams, nil | string
M.build_file_run_params = function(bufnr, cursor_pos)
  local buffer_name = vim.api.nvim_buf_get_name(bufnr)
  local path = vim.fn.fnamemodify(buffer_name, ":~:.")

  return {
    bufnr = bufnr,
    cursor_pos = cursor_pos,
    args = { path }
  }, nil
end

--- Optional:
---@param bufnr integer
---@param cursor_pos integer[]
---@return PHPUnitRunParams, nil | string
M.build_dir_run_params = function(bufnr, cursor_pos)
  local buffer_name = vim.api.nvim_buf_get_name(bufnr)
  local path = vim.fn.fnamemodify(buffer_name, ":.:h")

  return {
    bufnr = bufnr,
    cursor_pos = cursor_pos,
    args = { path }
  }, nil
end

--- Optional:
---@param bufnr integer
---@param cursor_pos integer[]
---@return PHPUnitRunParams, nil | string
M.build_all_run_params = function(bufnr, cursor_pos)
  return {
    bufnr = bufnr,
    cursor_pos = cursor_pos,
    args = {}
  }, nil
end

--- Executes the test with the given parameters.
---@param params PHPUnitRunParams
---@param send fun(data: any)
---@return integer
M.run = function(params, send)
  -- print(vim.inspect(params))

  local job = Job:new({
    command = M.options.command,
    args = params.args,
    on_stdout = function(_, data)
      send({ type = "stdout", output = data })
    end,
    on_stderr = function(_, data)
      send({ type = "stderr", output = data })
    end,
    on_exit = function(_, return_val)
      send({ type = "exit", code = return_val })
    end,
  })

  job:start()

  return job.pid
end

--- Optional: title of the test run
---@param params PHPUnitRunParams
-- M.title = function(params)
--   return "Running test"
-- end

--- Optional: handles actions to take after the test run, based on the results.
---@param params any
---@param results any
-- M.after_run = function(params, results)
--   -- Implement actions based on the results, such as updating UI or handling errors
-- end

--- Checks if the adapter is enabled for the given buffer.
---@param bufnr integer
---@return boolean
M.is_enabled = function(bufnr)
  local bufname = vim.api.nvim_buf_get_name(bufnr)
  return vim.endswith(bufname, "Test.php")
end

--- Adapter options.
setmetatable(M, {
  ---@param opts GoAdapterOptions
  __call = function(_, opts)
    M.options = opts

    return M
  end,
})

return M
