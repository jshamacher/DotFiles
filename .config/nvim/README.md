# Personal Neovim configuration

This is a from-scratch Lua configuration that carries the editing behavior from
`~/.vim/vimrc` into Neovim while adding a small modern plugin layer.

## First launch

Install the external tools used by the configuration:

```sh
sudo pacman -S --needed ripgrep fd wl-clipboard
```

Then start `nvim`. The first launch bootstraps `lazy.nvim` and installs the plugins.
Use `:Lazy` to inspect or update them and `:checkhealth` to diagnose the setup.

The configuration does not require a Nerd Font; icons are intentionally disabled or
replaced with text.

## Search behavior

- `/` and `?` search forward and backward for literal text inside the current file. They
  are incremental, case-sensitive, highlighted, and never fuzzy. Punctuation such as `.`,
  `*`, and `[` has no special meaning. Use `<Space>sr` or `<Space>sR` when you explicitly
  want a forward or backward Vim regex search.
- `<Space>ff` fuzzy-finds file names.
- `<Space>fg` searches project contents for the exact literal text entered. It includes
  hidden files and excludes `.git`.
- `<Space>fb`, `<Space>fr`, and `<Space>fh` find buffers, recent files, and help.

Pause for half a second after pressing `<Space>` to see the available mappings. Press
`<Space>?` to show buffer-local mappings explicitly.

## Completion

Completion uses `blink.cmp`. Its default keys include:

- `<C-n>` / `<C-p>` to move through suggestions
- `<C-y>` to accept a suggestion
- `<C-e>` to hide completion
- `<C-space>` to show completion or documentation

## Language servers

Language servers are intentionally not downloaded behind your back. Ruby, Python, Go,
Rust, and JavaScript/TypeScript/React are configured. At startup Neovim enables only
servers whose executable is installed, so a missing server does not cause an error every
time a matching file is opened. Run `:LspServers` to see what is ready.

Most of the servers are available from the official Arch repositories:

```sh
sudo pacman -S --needed ruby-lsp pyright gopls rust-analyzer typescript-language-server
```

Neovim provides `K`, `grn`, `gra`, `grr`, `gri`, and `grt` for common LSP actions.
This config adds `<Space>ld`, `<Space>lr`, `<Space>la`, and `<Space>lf`.

## Layout

- `init.lua` loads the configuration.
- `lua/config/` contains editor behavior and the LSP server list.
- `lua/plugins/` contains small, purpose-based plugin specifications.
- `lazy-lock.json` is generated after the first successful plugin installation and pins
  the working plugin revisions.
