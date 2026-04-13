return {
  {
    'nvim-treesitter/nvim-treesitter',
    enabled = not Hvim.is_mini(),
    version = false,
    build = ':TSUpdate',
    event = 'LazyFile',
    lazy = vim.fn.argc(-1) == 0, -- load treesitter early when opening a file from the cmdline
    config = function(_, _opts)
      local ts = require('nvim-treesitter')

      local parsers = {
        'bash', 'diff', 'go', 'html', 'javascript', 'jsdoc', 'json', 'jsonc',
        'lua', 'luadoc', 'markdown', 'markdown_inline', 'printf', 'python',
        'query', 'regex', 'toml', 'tsx', 'typescript', 'vim', 'vimdoc', 'xml',
        'yaml',
      }

      for _, parser in ipairs(parsers) do
        ts.install(parser)
      end

      local patterns = {}
      for _, parser in ipairs(parsers) do
        local parser_patterns = vim.treesitter.language.get_filetypes(parser)
        for _, pp in pairs(parser_patterns) do
          table.insert(patterns, pp)
        end
      end

      vim.wo[0][0].foldexpr = "v:lua.vim.treesitter.foldexpr()"
      vim.wo[0][0].foldmethod = "expr"

      vim.api.nvim_create_autocmd('FileType', {
        pattern = patterns,
        callback = function()
          vim.treesitter.start()
        end,
      })
    end,
  },
}
