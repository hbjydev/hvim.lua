return {
  {
    'nyoom-engineering/oxocarbon.nvim',
    init = function()
      local oxc = require('oxocarbon').oxocarbon

      -- Set the color scheme
      vim.cmd.colorscheme('oxocarbon')

      -- Set highlight overrides
      vim.api.nvim_set_hl(0, 'Normal', { bg = oxc.none })
      vim.api.nvim_set_hl(0, 'NormalNC', { bg = oxc.none })
      vim.api.nvim_set_hl(0, 'NormalFloat', { bg = oxc.none })
      vim.api.nvim_set_hl(0, 'LineNr', { fg = oxc.base03, bg = oxc.none })
      vim.api.nvim_set_hl(0, 'SignColumn', { fg = oxc.base02, bg = oxc.none })
      vim.api.nvim_set_hl(0, 'FloatBorder', { fg = oxc.base02, bg = oxc.none })
      vim.api.nvim_set_hl(0, 'VertSplit', { fg = oxc.base01, bg = oxc.none })
    end,
  },
}
