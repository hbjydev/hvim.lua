return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      {
        "theHamsta/nvim-dap-virtual-text",
        opts = {}
      },
    },

    keys = {
      { "<leader>dB", function() require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: ")) end, desc = "Breakpoint Condition" },
      { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Toggle Breakpoint" },
      { "<leader>dc", function() require("dap").continue() end, desc = "Run/Continue" },
      { "<leader>dC", function() require("dap").run_to_cursor() end, desc = "Run to Cursor" },
      { "<leader>dg", function() require("dap").goto_() end, desc = "Go to line (No Execute)" },
      { "<leader>di", function() require("dap").step_into() end, desc = "Step Into" },
      { "<leader>dj", function() require("dap").down() end, desc = "Down" },
      { "<leader>dk", function() require("dap").up() end, desc = "Up" },
      { "<leader>dl", function() require("dap").run_last() end, desc = "Run Last" },
      { "<leader>do", function() require("dap").step_out() end, desc = "Step Out" },
      { "<leader>dO", function() require("dap").step_over() end, desc = "Step Over" },
      { "<leader>dP", function() require("dap").pause() end, desc = "Pause" },
      { "<leader>dr", function() require("dap").repl.toggle() end, desc = "Toggle REPL" },
      { "<leader>ds", function() require("dap").session() end, desc = "Session" },
      { "<leader>dt", function() require("dap").terminate() end, desc = "Terminate" },
      { "<leader>dw", function() require("dap.ui.widgets").hover() end, desc = "Widgets" },
    },

    config = function()
      if Hvim.has("mason-nvim-dap.nvim") then
        require("mason-nvim-dap").setup(Hvim.opts("mason-nvim-dap.nvim"))
      end

      vim.api.nvim_set_hl(0, "DapStoppedLine", { default = true, link = "Visual" })

      for name, sign in pairs(Hvim.icons.dap) do
        sign = type(sign) == "table" and sign or { sign }
        vim.fn.sign_define(
          "Dap" .. name,
          { text = sign[1], texthl = sign[2] or "DiagnosticInfo", linehl = sign[3], numhl = sign[3] }
        )
      end


      -- setup dap config by VsCode launch.json file
      local vscode = require("dap.ext.vscode")
      local json = require("plenary.json")
      vscode.json_decode = function(str)
        return vim.json.decode(json.json_strip_comments(str))
      end

      local number_indices = function(array)
        local result = {}
        for i, value in ipairs(array) do
          result[i] = i .. ": " .. value
        end
        return result
      end

      local display_options = function(prompt_title, options)
        options = number_indices(options)
        table.insert(options, 1, prompt_title)

        local choice = vim.fn.inputlist(options)

        if choice > 0 then
          return options[choice + 1]
        else
          return nil
        end
      end

      local file_selection = function(cmd, opts)
        local results = vim.fn.systemlist(cmd)

        if #results == 0 then
          print(opts.empty_message)
          return
        end

        if opts.allow_multiple then
          return results
        end

        local result = results[1]
        if #results > 1 then
          result = display_options(opts.multiple_title_message, results)
        end

        return result
      end

      local project_selection = function(project_path, allow_multiple)
        local check_csproj_cmd = string.format('find %s -type f -name "*.csproj"', project_path)
        local project_file = file_selection(check_csproj_cmd, {
          empty_message = 'No csproj files found in ' .. project_path,
          multiple_title_message = 'Select project:',
          allow_multiple = allow_multiple
        })
        return project_file
      end

      local smart_pick_process = function(project_path)
        local dap_utils = require('dap.utils')
        local project_file = project_selection(project_path, true)
        if project_file == nil then
          return
        end

        return dap_utils.pick_process({
          filter = function(proc)
            if type(project_file) == "table" then
              for _, file in pairs(project_file) do
                local project_name = vim.fn.fnamemodify(file, ":t:r")
                if vim.endswith(proc.name, project_name) then
                  return true
                end
              end
              return false
            elseif type(project_file) == "string" then
              local project_name = vim.fn.fnamemodify(project_file, ":t:r")
              return vim.startswith(proc.name, project_name or "dotnet")
            ---@diagnostic disable-next-line: missing-return
            end
          end
        })
      end

      local config = {
        {
          type = "coreclr",
          name = "attach",
          request = "attach",
          processId = function()
            local current_working_dir = vim.fn.getcwd()
            return smart_pick_process(current_working_dir) or require('dap').ABORT
          end
        },
      }

      local dap = require('dap')
      dap.configurations.cs = config
      dap.configurations.fsharp = config
    end
  },

  {
    "rcarriga/nvim-dap-ui",
    dependencies = { "nvim-neotest/nvim-nio" },
    -- stylua: ignore
    keys = {
      { "<leader>du", function() require("dapui").toggle({ }) end, desc = "Dap UI" },
      { "<leader>de", function() require("dapui").eval() end, desc = "Eval", mode = {"n", "x"} },
    },
    opts = {},
    config = function(_, opts)
      local dap = require("dap")
      local dapui = require("dapui")
      dapui.setup(opts)
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open({})
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close({})
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close({})
      end
    end,
  },

  {
    "jay-babu/mason-nvim-dap.nvim",
    dependencies = "mason.nvim",
    cmd = { "DapInstall", "DapUninstall" },
    opts = {
      automatic_installation = true,
      handlers = {},
      ensure_installed = {
        "delve",
        "js-debug-adapter",
        "netcoredbg",
        "php-debug-adapter",
      },
    },

    -- mason-nvim-dap is loaded when nvim-dap loads
    config = function() end,
  },
}
