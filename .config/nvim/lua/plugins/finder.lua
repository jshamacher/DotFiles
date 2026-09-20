return {
  {
    "nvim-telescope/telescope.nvim",
    version = "*",
    cmd = "Telescope",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      {
        "<leader>ff",
        function()
          require("telescope.builtin").find_files({ hidden = true })
        end,
        desc = "Find files",
      },
      {
        "<leader>fb",
        function()
          require("telescope.builtin").buffers()
        end,
        desc = "Find buffers",
      },
      {
        "<leader>fh",
        function()
          require("telescope.builtin").help_tags()
        end,
        desc = "Find help",
      },
      {
        "<leader>fr",
        function()
          require("telescope.builtin").oldfiles()
        end,
        desc = "Find recent files",
      },
      {
        "<leader>fg",
        function()
          require("telescope.builtin").live_grep({
            additional_args = function()
              return { "--fixed-strings", "--hidden", "--glob", "!.git" }
            end,
            prompt_title = "Grep project (literal)",
          })
        end,
        desc = "Grep project (literal)",
      },
    },
    opts = {
      defaults = {
        prompt_prefix = "> ",
        selection_caret = "> ",
        path_display = { "smart" },
        sorting_strategy = "ascending",
        layout_config = { prompt_position = "top" },
      },
    },
  },
}

