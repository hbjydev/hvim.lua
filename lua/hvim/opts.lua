local opt = vim.opt

opt.background = 'dark'
opt.backup = false
opt.clipboard = vim.env.SSH_TTY and '' or 'unnamedplus'
opt.colorcolumn = '80'
opt.completeopt = 'menu,menuone,noselect'
opt.cursorline = true
opt.expandtab = true
opt.foldcolumn = '0'
opt.foldenable = true
opt.foldlevel = 99
opt.foldlevelstart = 99
opt.grepprg = 'rg --vimgrep'
opt.hlsearch = true
opt.ignorecase = true
opt.inccommand = 'nosplit'
opt.incsearch = true
opt.number = true
opt.relativenumber = true
opt.ruler = false
opt.scrolloff = 8
opt.shiftwidth = 2
opt.showmode = false
opt.sidescrolloff = 8
opt.smartcase = true
opt.smartindent = true
opt.softtabstop = 2
opt.swapfile = false
opt.tabstop = 2
opt.termguicolors = true
opt.undofile = true
opt.undolevels = 10000
opt.updatetime = 200
opt.wrap = false
