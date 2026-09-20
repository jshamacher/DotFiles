-- Personal Neovim configuration.
-- The ordering matters: leader keys must exist before plugins are loaded.
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

require("config.options")
require("config.keymaps")
require("config.autocmds")
require("config.lazy")

