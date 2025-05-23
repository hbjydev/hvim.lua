local LazyUtil = require('lazy.core.util')

local M = {}

setmetatable(M, {
  __index = function(t, k)
    if LazyUtil[k] then
      return LazyUtil[k]
    end

    ---@diagnostic disable-next-line: no-unknown
    t[k] = require('hvim.util.' .. k)
    return t[k]
  end,
})

---@param name string
function M.get_plugin(name)
  return require('lazy.core.config').spec.plugins[name]
end

function M.is_mini()
  local config_dir = vim.fn.stdpath('config')
  return vim.uv.fs_stat(config_dir .. "/mini")
end

function M.is_vscode()
  return vim.g.vscode
end

---@param name string
function M.opts(name)
  local plugin = M.get_plugin(name)
  if not plugin then
    return {}
  end
  local Plugin = require('lazy.core.plugin')
  return Plugin.values(plugin, 'opts', false)
end

return M
