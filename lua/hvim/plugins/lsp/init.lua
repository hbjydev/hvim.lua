return {
  {
    'neovim/nvim-lspconfig',
    enabled = not Hvim.is_mini() and not Hvim.is_vscode(),
    event = 'LazyFile',
    dependencies = {
      'mason.nvim',
      { 'mason-org/mason-lspconfig.nvim', config = function() end },
    },

    opts = function()
      ---@class PluginLspOpts
      local ret = {
        ---@type vim.diagnostic.config()
        diagnostics = {
          underline = true,
          update_in_insert = false,
          virtual_text = {
            spacing = 4,
            source = "if_many",
            prefix = "icons"
          },
          severity_sort = true,
          signs = {
            text = {
              [vim.diagnostic.severity.ERROR] = Hvim.icons.diagnostics.Error,
              [vim.diagnostic.severity.WARN] = Hvim.icons.diagnostics.Warn,
              [vim.diagnostic.severity.HINT] = Hvim.icons.diagnostics.Hint,
              [vim.diagnostic.severity.INFO] = Hvim.icons.diagnostics.Info,
            },
          },
        },

        inlay_hints = {
          enabled = true,
          exclude = { 'vue' },
        },

        codelens = { enabled = false },

        folds = { enabled = true },

        format = {
          formatting_options = nil,
          timeout_ms = nil
        },

        servers = {
          ["*"] = {
            capabilities = {
              workspace = {
                fileOperations = {
                  didRename = true,
                  willRename = true,
                },
              },
            },

            keys = {
              -- Diagnostics
              { '<leader>do', vim.diagnostic.open_float, desc = 'Show diagnostics' },
              { '[d', vim.diagnostic.jump({ count = -1, float = true }), desc = 'Previous diagnostic' },
              { ']d', vim.diagnostic.jump({ count = 1, float = true }), desc = 'Next diagnostic' },

              -- LSP Buffer
              { '<leader>cl', function() Snacks.picker.lsp_config() end, desc = "LSP Info" },
              { 'gd', function() Snacks.picker.lsp_definitions() end, desc = "Go to [d]efinition", has = "definition" },
              { 'gr', function() Snacks.picker.lsp_references() end, desc = "References", nowait = true },
              { 'gt', function() Snacks.picker.lsp_type_definitions() end, desc = "Go to [t]ype definition" },
              { 'gD', function() Snacks.picker.lsp_declarations() end, desc = "Go to type [D]eclaration" },
              { 'gI', function() Snacks.picker.lsp_implementations() end, desc = "Go to type [I]mplementations" },
              { 'K', function() return vim.lsp.buf.hover() end, desc = 'Open hover dialog' },
              { 'gK', function() return vim.lsp.buf.signature_help() end, desc = 'Signature help', has = 'signatureHelp' },
              { '<c-k>', function() return vim.lsp.buf.signature_help() end, mode = 'i', desc = 'Signature help', has = 'signatureHelp' },
              { '<leader>ca', vim.lsp.buf.code_action, desc = 'Code action', has = 'codeAction' },
              { '<leader>rn', vim.lsp.buf.rename, desc = 'Rename', has = 'rename' },
            },
          },

          stylua = { enabled = false },
          lua_ls = {
            settings = {
              Lua = {
                workspace = {
                  checkThirdParty = false,
                },
                codeLens = {
                  enable = true,
                },
                completion = {
                  callSnippet = "Replace",
                },
                doc = {
                  privateName = { "^_" },
                },
                hint = {
                  enable = true,
                  setType = false,
                  paramType = true,
                  paramName = "Disable",
                  semicolon = "Disable",
                  arrayIndex = "Disable",
                },
              }
            }
          },

          astro = {},
          cssls = {},
          dockerls = {},
          html = {},
          jsonls = {},
          jsonnet_ls = {},
          pyright = {},
          rust_analyzer = {},
          terraform_ls = {},
          ts_ls = {},
          vue_ls = {},
          yamlls = {},
          roslyn_ls = {},
          intelephense = {
            init_options = {
              licenceKey = vim.fn.expand("$HOME/.config/nvim/intelephense.key"),
            },
          },
        },

        setup = {},
      }
      return ret
    end,

    ---@param opts PluginLspOpts
    config = vim.schedule_wrap(function(_, opts)
      for server, server_opts in pairs(opts.servers) do
        if type(server_opts) == "table" and server_opts.keys then
          require('hvim.plugins.lsp.keymaps').set({ name = server ~= "*" and server or nil }, server_opts.keys)
        end
      end

      -- inlay hints
      if opts.inlay_hints.enabled then
        Hvim.lsp.on_supports_method('textDocument/inlayHint', function(_, buffer)
          if
            vim.api.nvim_buf_is_valid(buffer)
            and vim.bo[buffer].buftype == ''
            and not vim.tbl_contains(opts.inlay_hints.exclude, vim.bo[buffer].filetype)
          then
            vim.lsp.inlay_hint.enable(true, { bufnr = buffer })
          end
        end)
      end

      -- folds
      if opts.folds.enabled then
        Snacks.util.lsp.on({ method = "textDocument/foldingRange" }, function()
          if Hvim.set_default("foldmethod", "expr") then
            Hvim.set_default("foldexpr", "v:lua.vim.lsp.foldexpr()")
          end
        end)
      end

      -- diagnostics
      if type(opts.diagnostics.virtual_text) == "table" and opts.diagnostics.virtual_text.prefix == "icons" then
        opts.diagnostics.virtual_text.prefix = function(diagnostic)
          local icons = Hvim.icons.diagnostics
          for d, icon in pairs(icons) do
            if diagnostic.severity == vim.diagnostic.severity[d:upper()] then
              return icon
            end
          end
          return "●"
        end
      end
      vim.diagnostic.config(vim.deepcopy(opts.diagnostics))

      if opts.servers["*"] then
        vim.lsp.config("*", opts.servers["*"])
      end

      local have_mason = Hvim.has("mason-lspconfig.nvim")
      local mason_all = have_mason
        and vim.tbl_keys(require("mason-lspconfig.mappings").get_mason_map().lspconfig_to_package)
        or {} --[[ @as string[] ]]
      local mason_exclude = {} ---@type string[]

      local function configure(server)
        if server == "*" then
          return false
        end
        local sopts = opts.servers[server]
        sopts = sopts == true and {} or (not sopts) and { enabled = false } or sopts

        if sopts.enabled == false then
          mason_exclude[#mason_exclude + 1] = server
          return
        end

        local use_mason = sopts.mason ~= false and vim.tbl_contains(mason_all, server)
        local setup = opts.setup[server] or opts.setup["*"]
        if setup and setup(server, opts) then
          mason_exclude[#mason_exclude + 1] = server
        else
          vim.lsp.config(server, sopts)
          if not use_mason then
            vim.lsp.enable(server)
          end
        end
        return use_mason
      end

      local install = vim.tbl_filter(configure, vim.tbl_keys(opts.servers))
      if have_mason then
        require("mason-lspconfig").setup({
          ensure_installed = vim.list_extend(install, Hvim.opts("mason-lspconfig.nvim").ensure_installed or {}),
          automatic_enable = { exclude = mason_exclude },
        })
      end
    end),
  },

  {
    'mason-org/mason.nvim',
    enabled = not Hvim.is_mini() and not Hvim.is_vscode(),
    cmd = 'Mason',
    keys = { { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" } },
    build = ':MasonUpdate',
    opts_extend = { 'ensure_installed' },
    opts = {
      registries = {
        'github:mason-org/mason-registry',
        'github:Crashdummyy/mason-registry',
      },
      ensure_installed = {
        'stylua',
        'shfmt',
        'prettierd',
        'prettier',
        'ruff',
        'isort',
        'black',
        'gofumpt',
      },
    },
    config = function(_, opts)
      require('mason').setup(opts)
      local mr = require('mason-registry')

      mr.refresh(function()
        for _, tool in ipairs(opts.ensure_installed) do
          local p = mr.get_package(tool)
          if not p:is_installed() then
            p:install()
          end
        end
      end)
    end,
  },

  {
    "seblyng/roslyn.nvim",
    ---@module 'roslyn.config'
    ---@type RoslynNvimConfig
    opts = {},
  }
}
