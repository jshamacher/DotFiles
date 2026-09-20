-- Add server names here after installing their executables with pacman (or another
-- trusted system package source). nvim-lspconfig supplies each server's defaults.
-- Example: local servers = { "lua_ls", "pyright", "rust_analyzer", "ts_ls" }
local servers = {}

if #servers > 0 then
  vim.lsp.enable(servers)
end

vim.diagnostic.config({
  severity_sort = true,
  underline = true,
  virtual_text = { spacing = 2, prefix = "-" },
  float = { border = "rounded", source = true },
})

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("personal_lsp", { clear = true }),
  callback = function(event)
    local function map(lhs, rhs, desc)
      vim.keymap.set("n", lhs, rhs, { buffer = event.buf, desc = desc })
    end

    map("<leader>ld", vim.diagnostic.open_float, "Line diagnostics")
    map("<leader>lr", vim.lsp.buf.rename, "Rename symbol")
    map("<leader>la", vim.lsp.buf.code_action, "Code action")
    map("<leader>lf", function()
      vim.lsp.buf.format({ async = true })
    end, "Format buffer")
  end,
})

