return {
  {
    "junegunn/seoul256.vim",
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd.colorscheme("seoul256")
      vim.api.nvim_set_hl(0, "Search", { bg = "#dfaf5f", fg = "#303030" })
      vim.api.nvim_set_hl(0, "IncSearch", { bg = "#ffaf87", fg = "#444444" })
    end,
  },
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = {
      options = {
        icons_enabled = false,
        theme = "auto",
        component_separators = "|",
        section_separators = "",
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch", "diff", "diagnostics" },
        lualine_c = { { "filename", path = 1 } },
        lualine_x = { "encoding", "fileformat", "filetype" },
        lualine_y = { "progress" },
        lualine_z = { "location" },
      },
    },
  },
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      delay = 500,
      icons = { mappings = false },
      spec = {
        { "<leader>f", group = "find" },
        { "<leader>g", group = "git" },
        { "<leader>l", group = "language" },
        { "<leader>s", group = "search" },
      },
    },
    keys = {
      {
        "<leader>?",
        function()
          require("which-key").show({ global = false })
        end,
        desc = "Buffer keymaps",
      },
    },
  },
}
