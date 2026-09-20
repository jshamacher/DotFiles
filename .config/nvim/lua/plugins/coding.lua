return {
  {
    "saghen/blink.cmp",
    version = "1.*",
    event = "InsertEnter",
    opts = {
      keymap = { preset = "default" },
      appearance = {
        nerd_font_variant = "mono",
        kind_icons = {
          Text = "txt",
          Method = "fn",
          Function = "fn",
          Constructor = "new",
          Field = "fld",
          Variable = "var",
          Class = "cls",
          Interface = "ifc",
          Module = "mod",
          Property = "prop",
          Unit = "unit",
          Value = "val",
          Enum = "enum",
          Keyword = "key",
          Snippet = "snip",
          Color = "color",
          File = "file",
          Reference = "ref",
          Folder = "dir",
          EnumMember = "enum",
          Constant = "const",
          Struct = "struct",
          Event = "event",
          Operator = "op",
          TypeParameter = "type",
        },
      },
      completion = {
        documentation = { auto_show = true, auto_show_delay_ms = 500 },
      },
      sources = { default = { "lsp", "path", "snippets", "buffer" } },
      -- The Lua matcher is fast enough for completion and avoids an opaque binary download.
      fuzzy = { implementation = "lua" },
    },
    opts_extend = { "sources.default" },
  },
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    cmd = "LspServers",
    config = function()
      require("config.lsp")
    end,
  },
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      signs = {
        add = { text = "+" },
        change = { text = "~" },
        delete = { text = "_" },
        topdelete = { text = "-" },
        changedelete = { text = "~" },
        untracked = { text = "+" },
      },
      on_attach = function(bufnr)
        local gitsigns = require("gitsigns")
        local function bmap(lhs, rhs, desc)
          vim.keymap.set("n", lhs, rhs, { buffer = bufnr, desc = desc })
        end

        bmap("]c", function()
          if vim.wo.diff then return "]c" end
          vim.schedule(gitsigns.next_hunk)
          return "<Ignore>"
        end, "Next Git change")
        bmap("[c", function()
          if vim.wo.diff then return "[c" end
          vim.schedule(gitsigns.prev_hunk)
          return "<Ignore>"
        end, "Previous Git change")
        bmap("<leader>gp", gitsigns.preview_hunk, "Preview hunk")
        bmap("<leader>gb", gitsigns.blame_line, "Blame line")
      end,
    },
  },
}
