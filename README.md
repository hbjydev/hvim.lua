## hvim.lua

My Neovim config, done _yet again_ in Lua...

## Setup

```sh
git clone https://github.com/hbjydev/hvim.lua.git ~/.config/nvim
nvim
```

## Mini Mode

This config works in a lightweight mode for use cases that benefit from it (i.e.
deployment to a low-power/overhead server). To enable this mode, simply create
an empty file in the config dir (`~/.config/nvim`, `/etc/neovim`, etc.) called
`mini`.

```shell
touch $HOME/.config/nvim/mini
```

This will disable all LSP, Tree-Sitter, and formatting plugins disabled.
