-- Neovim owns the client configuration, while language-server executables remain
-- system-managed. A configured server becomes active after its command is installed
-- and Neovim is restarted; nothing is downloaded in the background.
local servers = {
  { name = "ruby_lsp", command = "ruby-lsp", language = "Ruby" },
  { name = "pyright", command = "pyright-langserver", language = "Python" },
  { name = "gopls", command = "gopls", language = "Go" },
  { name = "rust_analyzer", command = "rust-analyzer", language = "Rust" },
  { name = "ts_ls", command = "typescript-language-server", language = "JavaScript/TypeScript/React" },
}

vim.lsp.config("*", {
  capabilities = require("blink.cmp").get_lsp_capabilities(),
})

local enabled = {}
local missing = {}

for _, server in ipairs(servers) do
  if vim.fn.executable(server.command) == 1 then
    enabled[#enabled + 1] = server.name
  else
    missing[#missing + 1] = server
  end
end

if #enabled > 0 then
  vim.lsp.enable(enabled)
end

vim.api.nvim_create_user_command("LspServers", function()
  local lines = { "Language servers" }
  for _, server in ipairs(servers) do
    local installed = vim.fn.executable(server.command) == 1
    lines[#lines + 1] = string.format(
      "  %-28s %s (%s)",
      server.language,
      installed and "ready" or "missing",
      server.command
    )
  end
  vim.notify(table.concat(lines, "\n"), vim.log.levels.INFO, { title = "Neovim LSP" })
end, { desc = "Show configured language-server availability" })

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
