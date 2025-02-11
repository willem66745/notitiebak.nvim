local config = require('notitiebak.config')

local M = {}

-- Store and close note
---@param buffer integer
local function close_note(buffer)
  vim.api.nvim_buf_call(buffer, function()
    vim.api.nvim_command('write')
  end)
  vim.api.nvim_buf_delete(buffer, { force = true })
end

-- Create a new note
---@param name string
---@param path string
local function create_note(name, path)
  local dir = vim.fn.expand(config.notes_directory)
  if vim.fn.isdirectory(dir) == 0 then
    vim.fn.mkdir(dir, 'p')
  end

  local buf = vim.api.nvim_create_buf(true, false)
  vim.fn.setbufline(buf, 1, '# ' .. name)
  vim.fn.setbufline(buf, 2, '')
  local win = vim.api.nvim_get_current_win()
  vim.api.nvim_win_set_buf(win, buf)
  vim.api.nvim_win_set_cursor(win, { 2, 0 })

  local template = vim.fn.expand(config.template)
  if vim.fn.filereadable(template) == 1 then
    vim.fn.execute('read ' .. config.template)
  end

  vim.api.nvim_command('write ' .. path)
end

-- Open an existing note
---@param path string
local function open_note(path)
  vim.api.nvim_command('edit ' .. path)
  M.bak_buffer = vim.api.nvim_get_current_buf()
  local lines = vim.api.nvim_buf_line_count(M.bak_buffer)
  vim.api.nvim_win_set_cursor(0, { lines, 0 })
end

-- Convert a name to a potential filename
--- @param name string
--- @return string
local function to_filename(name)
  local _name = vim.fn.substitute(name, '[. ]', '-', 'g')
  _name = vim.fn.substitute(_name, '[\\/]', '_', 'g')
  return _name
end

--  Returns both the name and related note filename
--- @return string, string
local function general_note_filename()
  ---@type string
  local dir = vim.fn.expand(config.notes_directory)
  if not vim.fn.isdirectory(dir) then
    vim.fn.mkdir(dir, 'p')
  end

  ---@type string | fun() : string
  local name = config.default_note
  if type(name) == 'function' then
    name = name()
  elseif type(name) == 'string' then
    local funs = require('notitiebak.note_names')
    if funs[name] ~= nil then
      name = funs[name]()
    end
  else
    error('unsupported type provided to option "default_note": ' .. type(name))
  end
  local file = to_filename(name)

  if not vim.endswith(file, '.md') then
    file = file .. '.md'
  end

  return name, vim.fs.joinpath(dir, file)
end

-- Search in all buffers whether the default note has been opened
--- @param filename string
--- @return integer? buffer
local function search_note_buffer(filename)
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.fn.expand(vim.api.nvim_buf_get_name(buf)) == vim.fn.expand(filename) then
      if vim.fn.buflisted(buf) == 1 then
        return buf
      end
    end
  end
end

--  Toggle the note
function M.toggle()
  local name, filename = general_note_filename()
  local buf = search_note_buffer(filename)

  if buf then
    close_note(buf)
  else
    if vim.fn.filereadable(filename) == 0 then
      create_note(name, filename)
    else
      open_note(filename)
    end
  end
end

return M
