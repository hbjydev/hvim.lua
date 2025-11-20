return {
  {
    'lewis6991/gitsigns.nvim',
    event = 'LazyFile',
    dependencies = { 'sindrets/diffview.nvim' },
    opts = function()
      local M = {
        signs = {
          add = { text = '▎' },
          change = { text = '▎' },
          delete = { text = '' },
          topdelete = { text = '' },
          changedelete = { text = '▎' },
          untracked = { text = '▎' },
        },
        signs_staged = {
          add = { text = '▎' },
          change = { text = '▎' },
          delete = { text = '' },
          topdelete = { text = '' },
          changedelete = { text = '▎' },
        },

        on_attach = function(bufnr)
          local gs = package.loaded.gitsigns

          local function map(mode, l, r, desc)
            vim.keymap.set(mode, l, r, { buffer = bufnr, desc = desc })
          end

          map('n', '<leader>cs', gs.stage_hunk, 'Stage hunk')
          map('n', '<leader>cr', gs.reset_hunk, 'Reset hunk')
          map('n', '<leader>cS', gs.stage_buffer, 'Stage buffer')
          map('n', '<leader>cR', gs.reset_buffer, 'Reset buffer')
          map('n', '<leader>cd', gs.diffthis, 'Diff this')
          map('n', ']c', function()
            gs.nav_hunk('next')
          end, 'Next hunk')
          map('n', '[c', function()
            gs.nav_hunk('prev')
          end, 'Previous hunk')
        end,
      }

      Snacks.toggle({
        name = 'Git Signs',
        get = function()
          return require('gitsigns.config').config.signcolumn
        end,
        set = function(state)
          require('gitsigns').toggle_signs(state)
        end,
      }):map('<leader>uG')

      return M
    end,

    config = function(_, opts)
      require('gitsigns').setup(opts)
      local oxc = require('oxocarbon').oxocarbon
      vim.api.nvim_set_hl(0, 'DiffAdd', { fg = oxc.base13, bg = oxc.none })
      vim.api.nvim_set_hl(0, 'DiffAdded', { fg = oxc.base13, bg = oxc.none })
      vim.api.nvim_set_hl(0, 'DiffChange', { fg = oxc.base14, bg = oxc.none })
      vim.api.nvim_set_hl(0, 'DiffChanged', { fg = oxc.base14, bg = oxc.none })
      vim.api.nvim_set_hl(0, 'DiffDelete', { fg = oxc.base10, bg = oxc.none })
      vim.api.nvim_set_hl(0, 'DiffRemoved', { fg = oxc.base10, bg = oxc.none })
      vim.api.nvim_set_hl(0, 'DiffText', { fg = oxc.base02, bg = oxc.none })
    end,
  },
}
