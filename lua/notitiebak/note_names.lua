local M = {}

-- Returns the todays date in YYYY-MM_DD format
---@return string
function M.todays_date()
  return vim.fn.strftime('%Y-%m-%d')
end

-- Return the activate branch name
---@return string
function M.branch_name()
  local branch = vim.fn.systemlist('git branch --show-current')[1]
  local code = vim.v.shell_error
  if code == 0 then
    return branch
  else
    return 'general_note'
  end
end

return M
