---@class notitiebak.Config
---@field notes_directory? string Your notes directory
---@field default_note? string | fun(): string Your first note
local defaults = {
  notes_directory = '~/notes',
  default_note = require('notitiebak.note_names').todays_date,
}

local M = {}

---@type notitiebak.Config
M.config = defaults

---@param args notitiebak.Config?
function M.setup(args)
  M.config = vim.tbl_deep_extend('force', M.config, args or {})
end

return setmetatable(M, {
  __index = function(_, k)
    return M.config[k]
  end,
})
