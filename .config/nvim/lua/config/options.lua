local opt = vim.opt

-- Editing behavior carried over from ~/.vim/vimrc.
opt.backspace = { "indent", "eol", "start" }
opt.history = 256
opt.mouse = ""
opt.showcmd = true
opt.showmatch = true
opt.cursorline = true
opt.swapfile = false
opt.backup = false
opt.writebackup = false

opt.list = true
opt.listchars = {
  trail = "·",
  tab = "» ",
  extends = "…",
  precedes = "…",
}

-- Preserve the old preference: do not invent a final newline on write.
opt.endofline = false
opt.fixendofline = false

-- Search is native Vim pattern search, never fuzzy matching.
opt.hlsearch = true
opt.incsearch = true
opt.magic = true
opt.ignorecase = false

opt.autoindent = true
opt.smartindent = true
opt.smarttab = true
opt.expandtab = true
opt.shiftwidth = 4
opt.softtabstop = 4
opt.tabstop = 4

opt.wrap = false
opt.linebreak = true
opt.sidescroll = 1
opt.scrolloff = 1
opt.sidescrolloff = 15
opt.textwidth = 100

opt.wildmode = "list:longest"
opt.wildmenu = true
opt.wildignore = { "*.o", "*.obj", "*~" }

opt.undofile = true
opt.undodir = vim.fn.stdpath("state") .. "/undo//"
vim.fn.mkdir(opt.undodir:get()[1], "p")

opt.autoread = true
opt.foldmethod = "marker"

-- Small modern conveniences that do not change Vim's editing language.
opt.termguicolors = true
opt.number = true
opt.signcolumn = "yes"
opt.splitbelow = true
opt.splitright = true
opt.updatetime = 250
opt.timeoutlen = 500
opt.completeopt = { "menuone", "noselect" }

if vim.fn.executable("wl-copy") == 1 then
  opt.clipboard = "unnamedplus"
end

