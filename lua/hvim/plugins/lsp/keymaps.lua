local M = {}

M._keys = nil

function M.get()
  if M._keys then
    return M._keys
  end

  -- stylua: ignore
  M._keys =  {
    -- Diagnostics
    { '<leader>do', vim.diagnostic.open_float, desc = 'Show diagnostics' },
    { '[d', vim.diagnostic.goto_prev, desc = 'Previous diagnostic' },
    { ']d', vim.diagnostic.goto_next, desc = 'Next diagnostic' },

    -- LSP Buffer
    { 'gd', vim.lsp.buf.definition, desc = 'Go to definition', has = 'definition' },
    { 'gt', vim.lsp.buf.type_definition, desc = 'Go to type definition', has = 'definition' },
    { 'K', function() return vim.lsp.buf.hover() end, desc = 'Open hover dialog', has = 'signatureHelp' },
    { '<leader>ca', vim.lsp.buf.code_action, desc = 'Open hover dialog', has = 'codeAction' },
    { '<leader>rn', vim.lsp.buf.rename, desc = 'Rename', has = 'rename' },
  }

  return M._keys
end

---@param method string|string[]
function M.has(buffer, method)
  if type(method) == 'table' then
    for _, m in ipairs(method) do
      if M.has(buffer, m) then
        return true
      end
    end
    return false
  end
  method = method:find('/') and method or 'textDocument/' .. method
  local clients = Hvim.lsp.get_clients({ bufnr = buffer })
  for _, client in ipairs(clients) do
    if client.supports_method(method) then
      return true
    end
  end
  return false
end

function M.resolve(buffer)
  local Keys = require('lazy.core.handler.keys')
  if not Keys.resolve then
    return {}
  end
  local spec = vim.tbl_extend('force', {}, M.get())
  local opts = Hvim.opts('nvim-lspconfig')
  local clients = Hvim.lsp.get_clients({ bufnr = buffer })
  for _, client in ipairs(clients) do
    local maps = opts.servers[client.name] and opts.servers[client.name].keys or {}
    vim.list_extend(spec, maps)
  end
  return Keys.resolve(spec)
end

function M.on_attach(client, buffer)
  local Keys = require('lazy.core.handler.keys')
  local keymaps = M.resolve(buffer)

  for _, keys in pairs(keymaps) do
    local has = not keys.has or M.has(buffer, keys.has)
    local cond = not (keys.cond == false or ((type(keys.cond) == 'function') and not keys.cond()))

    if has and cond then
      local opts = Keys.opts(keys)
      opts.cond = nil
      opts.has = nil
      opts.silent = opts.silent ~= false
      opts.buffer = buffer
      vim.keymap.set(keys.mode or 'n', keys.lhs, keys.rhs, opts)
    end
  end
end

return M
