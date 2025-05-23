vim.g.mapleader = ' '

vim.keymap.set('n', 'Y', 'yg$')
vim.keymap.set('n', 'J', 'mzJ`z')
vim.keymap.set('n', '<C-d>', '<C-d>zz')
vim.keymap.set('n', '<C-u>', '<C-u>zz')
vim.keymap.set('n', 'n', 'nzzzv')
vim.keymap.set('n', 'N', 'Nzzzv')
vim.keymap.set('n', '<leader>b]', '<cmd>bn<cr>')
vim.keymap.set('n', '<leader>b[', '<cmd>bp<cr>')
vim.keymap.set('n', '<leader>bd', '<cmd>bd<cr>')
vim.keymap.set('n', '<leader>bd', '<cmd>bd<cr>')

-- copy-paste
vim.keymap.set('x', '<leader>p', '"_dP')
vim.keymap.set('n', '<leader>Y', '"+Y')
vim.keymap.set({ 'n', 'v' }, '<leader>y', '"+y')

vim.keymap.set({ 'n', 'v' }, '<leader>d', '"_d')

vim.keymap.set('i', '<C-c>', '<Esc>')

vim.keymap.set('n', 'Q', '<Nop>')

vim.keymap.set('n', '<C-k>', '<cmd>cnext<CR>zz')
vim.keymap.set('n', '<C-j>', '<cmd>cprev<CR>zz')
vim.keymap.set('n', '<leader>j', '<cmd>lnext<CR>zz')
vim.keymap.set('n', '<leader>k', '<cmd>lprev<CR>zz')

if vim.g.vscode then
  local code = require('vscode')
  local actionbind = function(mode, bind, action)
    vim.keymap.set(mode, bind, function ()
      code.action(action)
    end)
  end

  actionbind('n', ']d', 'editor.action.marker.prev')
  actionbind('n', ']d', 'editor.action.marker.next')
end
