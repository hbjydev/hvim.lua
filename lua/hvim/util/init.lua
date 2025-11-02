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

function M.has(plugin)
  return M.get_plugin(plugin) ~= nil
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

function M.set_default(option, value)
  local l = vim.api.nvim_get_option_value(option, { scope = "local" })
  local g = vim.api.nvim_get_option_value(option, { scope = "global" })

  _defaults[("%s=%s"):format(option, value)] = true
  local key = ("%s=%s"):format(option, l)

  local source = ""
  if l ~= g and not _defaults[key] then
    -- Option does not match global and is not a default value
    -- Check if it was set by a script in $VIMRUNTIME
    local info = vim.api.nvim_get_option_info2(option, { scope = "local" })
    ---@param e vim.fn.getscriptinfo.ret
    local scriptinfo = vim.tbl_filter(function(e)
      return e.sid == info.last_set_sid
    end, vim.fn.getscriptinfo())
    source = scriptinfo[1] and scriptinfo[1].name or ""
    local by_rtp = #scriptinfo == 1 and vim.startswith(scriptinfo[1].name, vim.fn.expand("$VIMRUNTIME"))
    if not by_rtp then
      return false
    end
  end

  vim.api.nvim_set_option_value(option, value, { scope = "local" })
  return true
end

return M
