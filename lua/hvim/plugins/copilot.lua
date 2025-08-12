return {
  {
    'zbirenbaum/copilot.lua',
    enabled = not Hvim.is_mini() and not Hvim.is_vscode(),
    cmd = 'Copilot',
    event = 'InsertEnter',
    config = function()
      require('copilot').setup({})
    end,
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
