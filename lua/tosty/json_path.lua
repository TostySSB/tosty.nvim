-- Put this in (for example) lua/json_path.lua
local M = {}

-- Decide which node types represent array elements
local value_node_types = {
  object = true,
  array  = true,
  string = true,
  number = true,
  ["true"]  = true,
  ["false"] = true,
  ["null"]  = true,
}

-- Extract raw text (e.g. "first_name") from a string node: `"first_name"`
local function strip_json_string_quotes(s)
  return (s:gsub('^"%s*', ''):gsub('%s*"$', ''))
end

local function is_identifier_key(key)
  return key:match('^[A-Za-z_][A-Za-z0-9_]*$') ~= nil
end

local function build_path(node, bufnr)
  local parts = {}

  while node do
    local type_ = node:type()

    if type_ == 'pair' then
      -- pair := string ':' value
      local key_node = node:child(0)
      if key_node and key_node:type() == 'string' then
        local key_text = vim.treesitter.get_node_text(key_node, bufnr)
        key_text = strip_json_string_quotes(key_text)
        if is_identifier_key(key_text) then
          table.insert(parts, 1, '.' .. key_text)
        else
          table.insert(parts, 1, string.format('["%s"]', key_text:gsub('"','\\"')))
        end
      end
    elseif value_node_types[type_] then
      local parent = node:parent()
      if parent and parent:type() == 'array' then
        -- Need index of this value among siblings
        local idx = 0
        local child = parent:child(0)
        while child and child:id() ~= node:id() do
          if value_node_types[child:type()] then
            idx = idx + 1
          end
          child = child:next_sibling()
        end
        table.insert(parts, 1, string.format('[%d]', idx))
      end
    end

    node = node:parent()
  end

  local path = table.concat(parts)
  -- Remove any leading dot so we return plain path without '$'
  path = path:gsub('^%.', '')
  return path -- root becomes empty string
end

function M.copy()
  if vim.bo.filetype ~= 'json' and vim.bo.filetype ~= 'jsonc' then
    vim.notify('Not a JSON buffer', vim.log.levels.WARN)
    return
  end

  local node = vim.treesitter.get_node()
  if not node then
    vim.notify('No Tree-sitter node at cursor', vim.log.levels.WARN)
    return
  end

  local bufnr = vim.api.nvim_get_current_buf()
  local path = build_path(node, bufnr)
  vim.fn.setreg('+', path)
  vim.fn.setreg('"', path)
  vim.notify('Copied JSON path: ' .. (path == '' and '<root>' or path))
end

return M
