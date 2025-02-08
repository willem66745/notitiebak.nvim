local M = {}

-- Returns the todays date in YYYY-MM_DD format
---@return string
function M.todays_date()
  return vim.fn.strftime('%Y-%m-%d')
end

-- Return the activate branch name
---@return string
function M.branch_name()
  return vim.fn.systemlist('git branch --show-current')[1]
end

return M
