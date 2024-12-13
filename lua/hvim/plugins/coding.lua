return {
  {
    "saghen/blink.cmp",
    lazy = false, -- lazy loading handled internally
    dependencies = 'rafamadriz/friendly-snippets',
    version = "v0.*",

    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      appearance = {
        -- Sets the fallback highlight groups to nvim-cmp's highlight groups
        -- Useful for when your theme doesn't support blink.cmp
        -- will be removed in a future release
        use_nvim_cmp_as_default = true,
        -- Set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
        -- Adjusts spacing to ensure icons are aligned
        nerd_font_variant = 'mono'
      },

      completion = {
        list = {
          selection = 'manual',
        },

        menu = {
          min_width = 40,
          draw = {
            treesitter = true,
            padding = 0,
            columns = {
              { 'kind_icon' },
              { "label", "label_description", gap = 1 },
            },
          },
        },
      },

      sources = {
        default = { 'lsp', 'snippets' },
        cmdline = {},
      },

      signature = { enabled = true },
    },
    opts_extend = { "sources.default" },
  },

  -- add icons
  {
    "saghen/blink.cmp",
    opts = function(_, opts)
      opts.appearance = opts.appearance or {}
      opts.appearance.kind_icons = {
        Array         = "  ",
        Boolean       = " 󰨙 ",
        Class         = "  ",
        Codeium       = " 󰘦 ",
        Color         = "  ",
        Control       = "  ",
        Collapsed     = "  ",
        Constant      = " 󰏿 ",
        Constructor   = "  ",
        Enum          = "  ",
        EnumMember    = "  ",
        Event         = "  ",
        Field         = "  ",
        File          = "  ",
        Folder        = "  ",
        Function      = " 󰊕 ",
        Interface     = "  ",
        Key           = "  ",
        Keyword       = "  ",
        Method        = " 󰊕 ",
        Module        = "  ",
        Namespace     = " 󰦮 ",
        Null          = "  ",
        Number        = " 󰎠 ",
        Object        = "  ",
        Operator      = "  ",
        Package       = "  ",
        Property      = "  ",
        Reference     = "  ",
        Snippet       = "  ",
        String        = "  ",
        Struct        = " 󰆼 ",
        Supermaven    = "  ",
        TabNine       = " 󰏚 ",
        Text          = "  ",
        TypeParameter = "  ",
        Unit          = "  ",
        Value         = "  ",
        Variable      = " 󰀫 ",
      }
    end,
  },

  -- lazydev
  {
    "saghen/blink.cmp",
    opts = {
      sources = {
        -- add lazydev to your completion providers
        default = { "lazydev" },
        providers = {
          lazydev = {
            name = "LazyDev",
            module = "lazydev.integrations.blink",
          },
        },
      },
    },
  },

  {
    "folke/lazydev.nvim",
    ft = "lua",
    cmd = "LazyDev",
    opts = {
      library = {
        { path = "hvim", words = { "Hvim" } },
        { path = "snacks.nvim", words = { "Snacks" } },
        { path = "lazy.nvim", words = { "LazyVim" } },
      },
    },
  },
}
