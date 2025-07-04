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
        diagnostics = {},
        inlay_hints = {
          enabled = true,
          exclude = { 'vue' },
        },
        codelens = { enabled = true },
        document_highlight = { enabled = true },
        capabilities = {
          workspace = {
            fileOperations = {
              didRename = true,
              willRename = true,
            },
          },
        },

        format = {
          formatting_options = nil,
          timeout_ms = nil,
        },

        servers = {
          cssls = {},
          -- denols = {},
          dockerls = {},
          html = {},
          jsonls = {},
          jsonnet_ls = {},
          pyright = {
            settings = {
              pyright = { disableOrganizeImports = true },
            },
          },
          ruff = {},
          rust_analyzer = {},
          terraformls = {},
          ts_ls = {
            settings = {
              single_file_support = false,
            },
          },
          volar = {},
          yamlls = {},

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
                  callSnippet = 'Replace',
                },
                doc = {
                  privateName = { '^_' },
                },
                hint = {
                  enable = true,
                  setType = false,
                  paramType = true,
                  paramName = 'Disable',
                  semicolon = 'Disable',
                  arrayIndex = 'Disable',
                },
              },
            },
          },
        },

        setup = {},
      }
      return ret
    end,

    ---@param opts PluginLspOpts
    config = function(_, opts)
      Hvim.lsp.on_attach(function(client, buffer)
        require('hvim.plugins.lsp.keymaps').on_attach(client, buffer)
      end)

      Hvim.lsp.setup()
      Hvim.lsp.on_dynamic_capability(require('hvim.plugins.lsp.keymaps').on_attach)

      -- inlay hints
      if opts.inlay_hints.enabled then
        Hvim.lsp.on_supports_method('textDocument/inlayHint', function(client, buffer)
          if
            vim.api.nvim_buf_is_valid(buffer)
            and vim.bo[buffer].buftype == ''
            and not vim.tbl_contains(opts.inlay_hints.exclude, vim.bo[buffer].filetype)
          then
            vim.lsp.inlay_hint.enable(true, { bufnr = buffer })
          end
        end)
      end

      vim.diagnostic.config(vim.deepcopy(opts.diagnostics))

      local servers = opts.servers
      local has_blink, blink = pcall(require, 'blink.cmp')
      local capabilities = vim.tbl_deep_extend(
        'force',
        {},
        vim.lsp.protocol.make_client_capabilities(),
        has_blink and blink.get_lsp_capabilities() or {},
        opts.capabilities or {}
      )

      local function setup(server)
        local server_opts = vim.tbl_deep_extend('force', {
          capabilities = vim.deepcopy(capabilities),
        }, servers[server] or {})
        if server_opts.enabled == false then
          return
        end

        if opts.setup[server] then
          if opts.setup[server](server, server_opts) then
            return
          end
        elseif opts.setup['*'] then
          if opts.setup['*'](server, server_opts) then
            return
          end
        end
        require('lspconfig')[server].setup(server_opts)
      end

      -- get all the servers that are available through mason-lspconfig
      local have_mason, mlsp = pcall(require, 'mason-lspconfig')
      local all_mslp_servers = {}
      if have_mason then
        all_mslp_servers = vim.tbl_keys(require('mason-lspconfig.mappings.server').lspconfig_to_package)
      end

      local ensure_installed = {} ---@type string[]
      for server, server_opts in pairs(servers) do
        if server_opts then
          server_opts = server_opts == true and {} or server_opts
          if server_opts.enabled ~= false then
            -- run manual setup if mason=false or if this is a server that cannot be installed with mason-lspconfig
            if server_opts.mason == false or not vim.tbl_contains(all_mslp_servers, server) then
              setup(server)
            else
              ensure_installed[#ensure_installed + 1] = server
            end
          end
        end
      end

      if have_mason then
        mlsp.setup({
          ensure_installed = vim.tbl_deep_extend(
            'force',
            ensure_installed,
            Hvim.opts('mason-lspconfig.nvim').ensure_installed or {}
          ),
          handlers = { setup },
        })
      end

      if Hvim.lsp.is_enabled('denols') and Hvim.lsp.is_enabled('tsls') then
        local is_deno = require('lspconfig.util').root_pattern('deno.json', 'deno.jsonc')
        Hvim.lsp.disable('ts_ls', is_deno)
        Hvim.lsp.disable('denols', function(root_dir, config)
          if not is_deno(root_dir) then
            config.settings.deno.enable = false
          end
          return false
        end)
      end
    end,
  },

  {
    'mason-org/mason.nvim',
    enabled = not Hvim.is_mini() and not Hvim.is_vscode(),
    cmd = 'Mason',
    keys = {},
    build = ':MasonUpdate',
    opts_extend = { 'ensure_installed' },
    opts = {
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

  -- pin to v1 for now
  { "mason-org/mason.nvim", version = "^1.0.0" },
  { "mason-org/mason-lspconfig.nvim", version = "^1.0.0" },
}
