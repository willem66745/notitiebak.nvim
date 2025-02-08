local M = {}

---@param opts notitiebak.Config?
function M.setup(opts)
  require('notitiebak.config').setup(opts)
end

return M
