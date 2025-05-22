return {
  {
    'stevearc/conform.nvim',
    enabled = not Hvim.is_mini() and not Hvim.is_vscode(),
    dependencies = { 'mason.nvim' },
    cmd = 'Format',
    keys = {
      {
        '<leader>F',
        function()
          require('conform').format({ timeout_ms = 3000 })
        end,
        mode = { 'n', 'v' },
        desc = 'Format injected languages',
      },
    },

    ---@module 'conform'
    ---@type conform.setupOpts
    opts = {
      default_format_opts = {
        timeout_ms = 3000,
        async = false,
        quiet = false,
        lsp_format = 'fallback',
      },
      formatters_by_ft = {
        lua = { 'stylua' },
        sh = { 'shfmt' },
        python = { 'ruff' },
        go = { 'gofumpt' },
        javascript = { 'prettierd', 'prettier', stop_after_first = true },
        typescript = { 'prettierd', 'prettier', stop_after_first = true },
        _ = { 'trim_whitespace' },
      },
      formatters = {
        injected = { options = { ignore_errors = true } },
      },
    },
  },

  {
    'saghen/blink.cmp',
    lazy = false, -- lazy loading handled internally
    enabled = not Hvim.is_vscode(),
    dependencies = 'rafamadriz/friendly-snippets',
    version = 'v0.*',

    opts = {
      appearance = {
        -- Sets the fallback highlight groups to nvim-cmp's highlight groups
        -- Useful for when your theme doesn't support blink.cmp
        -- will be removed in a future release
        use_nvim_cmp_as_default = true,
        -- Set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
        -- Adjusts spacing to ensure icons are aligned
        nerd_font_variant = 'mono',
      },

      completion = {
        list = {
          selection = {
            preselect = false,
            auto_insert = false,
          },
        },

        menu = {
          min_width = 40,
          draw = {
            treesitter = { 'lsp' },
            padding = 0,
            columns = {
              { 'kind_icon' },
              { 'label', 'label_description', gap = 1 },
            },
          },
        },
      },

      sources = {
        default = { 'lsp', 'snippets' },
      },

      cmdline = { sources = {} },

      signature = { enabled = true },
    },
    opts_extend = { 'sources.default' },
  },

  -- add icons
  {
    'saghen/blink.cmp',
    opts = function(_, opts)
      opts.appearance = opts.appearance or {}
      opts.appearance.kind_icons = {
        Array = '  ',
        Boolean = ' 󰨙 ',
        Class = '  ',
        Codeium = ' 󰘦 ',
        Color = '  ',
        Control = '  ',
        Collapsed = '  ',
        Constant = ' 󰏿 ',
        Constructor = '  ',
        Enum = '  ',
        EnumMember = '  ',
        Event = '  ',
        Field = '  ',
        File = '  ',
        Folder = '  ',
        Function = ' 󰊕 ',
        Interface = '  ',
        Key = '  ',
        Keyword = '  ',
        Method = ' 󰊕 ',
        Module = '  ',
        Namespace = ' 󰦮 ',
        Null = '  ',
        Number = ' 󰎠 ',
        Object = '  ',
        Operator = '  ',
        Package = '  ',
        Property = '  ',
        Reference = '  ',
        Snippet = '  ',
        String = '  ',
        Struct = ' 󰆼 ',
        Supermaven = '  ',
        TabNine = ' 󰏚 ',
        Text = '  ',
        TypeParameter = '  ',
        Unit = '  ',
        Value = '  ',
        Variable = ' 󰀫 ',
      }
    end,
  },

  -- lazydev
  {
    'saghen/blink.cmp',
    enabled = not Hvim.is_mini() and not Hvim.is_vscode(),
    opts = {
      sources = {
        -- add lazydev to your completion providers
        default = { 'lazydev' },
        providers = {
          lazydev = {
            name = 'LazyDev',
            module = 'lazydev.integrations.blink',
          },
        },
      },
    },
  },

  {
    'numToStr/Comment.nvim',
    event = 'LazyFile',
  },

  {
    'folke/lazydev.nvim',
    enabled = not Hvim.is_mini() and not Hvim.is_vscode(),
    ft = 'lua',
    cmd = 'LazyDev',
    opts = {
      library = {
        { path = 'hvim', words = { 'Hvim' } },
        { path = 'snacks.nvim', words = { 'Snacks' } },
        { path = 'lazy.nvim', words = { 'LazyVim' } },
      },
    },
  },

  {
    'brenoprata10/nvim-highlight-colors',
    event = 'LazyFile',
    opts = {},
  },
}
