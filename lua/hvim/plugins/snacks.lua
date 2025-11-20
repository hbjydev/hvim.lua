return {
  {
    'folke/snacks.nvim',
    priority = 1000,
    lazy = false,
    dependencies = {
      'nvim-tree/nvim-web-devicons',
    },
    opts = {
      dashboard = {
        preset = {
          header = [[
    ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
    ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣤⣶⣿⣿⣶⡄⠱⣦⠀⠀⠀
    ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣴⣿⡿⠛⠉⡙⣿⣿⡄⢹⣧⠀⠀
    ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⣿⡿⢋⣠⠾⠋⠉⢹⣿⣷⢸⣿⡆⠀
    ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣼⣿⠏⣠⠞⠁⠀⠀⠀⢸⣿⣿⢸⣿⡇⠀
    ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⣿⠟⢡⡾⠋⠀⠀⠀⠀⠀⢸⣿⡇⢸⣿⠃⠀
    ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣴⡿⠁⣴⡟⠁⠀⠀⠀⠀⠀⠀⣿⡿⠀⣾⡟⠀⠀
    ⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⣾⠏⢠⣾⠏⠀⠀⠀⠀⠀⠀⠀⣼⠟⢁⣼⣿⠀⠀⠀
    ⠀⠀⠀⠀⠀⠀⠀⠀⣴⣄⠁⠰⡿⠃⠀⠀⠀⠀⠀⠀⢠⡾⠁⣴⣿⣿⡟⠀⠀⠀
    ⠀⠀⠀⠀⠀⠀⣠⣾⣿⣿⣿⠆⠀⠀⠀⠀⠀⠀⠀⢀⡿⢀⣾⣿⣿⣿⡇⠀⠀⠀
    ⠀⠀⠀⠀⢀⣴⣿⣿⣿⡿⠋⠀⠀⠀⠀⠀⠀⠀⠀⡼⠁⣼⡿⢃⣿⣿⠇⠀⠀⠀
    ⠀⠀⠀⢠⣾⣿⣿⣿⡟⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⢷⣼⠟⠁⣸⣿⠏⠀⠀⠀⠀
    ⠀⠀⣰⣿⣿⣿⣿⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠻⠃⠀⠀⠀⠀⠀
    ⠀⣾⣿⣿⣿⡟⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
    ⠀⠛⠛⠛⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀


"Gordon doesn't need to hear all this,
 he's a highly trained professional"
- Dr. Coomer PhD, 2000
   ]],
        },
      },

      animate = { enabled = true },
      bigfile = { enabled = true },
      explorer = {
        replace_netrw = true,
      },

      picker = {
        sources = {
          files = {
            cmd = "rg",
            args = { "--hidden", "--glob", "!.git" }
          },

          explorer = {
            auto_close = true,
            layout = {
              preset = "default",
              layout = {
                min_width = 85,
                width = 0.4,
              }
            },
          },
        },
      },

      dim = { enabled = true },
      git = { enabled = true },
      indent = { enabled = true },
      input = { enabled = true },
      lazygit = { enabled = true },
      quickfile = { enabled = true },
      rename = { enabled = true },
    },
    keys = {
      { '<leader>pv', function() Snacks.explorer() end, desc = "File tree" },
      { '<leader>pf', function() Snacks.picker.files() end, desc = "Files" },
      { '<leader>ps', function() Snacks.picker.grep() end, desc = "Grep" },
      { '<leader><space>', function() Snacks.picker.buffers() end, desc = "Buffers" },
      { '<leader>gf', function() Snacks.lazygit.log_file() end, desc = 'Lazygit Current File History' },
      { '<leader>gg', function() Snacks.lazygit() end, desc = 'Lazygit' },
    },
  },
}
