return {
  {
    'zbirenbaum/copilot.lua',
    enabled = not Hvim.is_mini() and not Hvim.is_vscode(),
    cmd = 'Copilot',
    event = 'InsertEnter',
    opts = {},
  },

  {
    'ravitemer/mcphub.nvim',
    enabled = not Hvim.is_mini() and not Hvim.is_vscode(),
    dependencies = { "nvim-lua/plenary.nvim" },
    build = 'bun install --global mcp-hub@latest',
    opts = {
      extensions = {
        copilotchat = {
          enabled = true,
          convert_tools_to_functions = true,
          convert_resources_to_functions = true,
          add_mcp_prefix = false,
        },
      },
    },
  },

  {
    "CopilotC-Nvim/CopilotChat.nvim",
    enabled = not Hvim.is_mini() and not Hvim.is_vscode(),
    build = "make tiktoken",
    keys = {
      { '<leader>cpc', ':CopilotChatToggle<CR>', desc = 'Toggle Copilot Chat' }
    },
    cmd = {
      "CopilotChat",
      "CopilotChatToggle",
      "CopilotChatOpen",
      "CopilotChatClose",
      "CopilotChatPrompts",
      "CopilotChatModels",
      "CopilotChatExplain",
      "CopilotChatReview",
      "CopilotChatFix",
      "CopilotChatOptimize",
      "CopilotChatDocs",
      "CopilotChatTests",
      "CopilotChatCommit",
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
    },
    opts = {
      model = 'gpt-4.1',
      temperature = 0.5,
      window = {
        layout = 'float',
        width = 0.5,
      },
      auto_insert_mode = false,
      show_folds = false,
    }
  },

  {
    "saghen/blink.cmp",
    dependencies = { "fang2hou/blink-copilot" },
    opts = {
      sources = {
        default = { 'copilot' },
        providers = {
          copilot = {
            name = "copilot",
            module = "blink-copilot",
            score_offset = 100,
            async = true,
          }
        }
      }
    }
  }
}
