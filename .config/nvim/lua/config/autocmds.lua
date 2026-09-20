local group = vim.api.nvim_create_augroup("personal_config", { clear = true })

vim.api.nvim_create_autocmd("TextYankPost", {
  group = group,
  callback = function()
    vim.highlight.on_yank({ timeout = 150 })
  end,
})

vim.api.nvim_create_autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
  group = group,
  command = "checktime",
})

-- Preserve the old save-time cleanup without disturbing the cursor or search history.
vim.api.nvim_create_autocmd("BufWritePre", {
  group = group,
  callback = function(args)
    if vim.bo[args.buf].buftype ~= "" or not vim.bo[args.buf].modifiable then
      return
    end

    local view = vim.fn.winsaveview()
    vim.cmd([[keeppatterns silent! %s/ \+$//e]])
    vim.fn.winrestview(view)
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  group = group,
  pattern = { "javascript", "javascriptreact", "ruby", "typescript", "typescriptreact", "yaml" },
  callback = function()
    vim.opt_local.shiftwidth = 2
    vim.opt_local.softtabstop = 2
    vim.opt_local.tabstop = 2
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  group = group,
  pattern = { "gitcommit", "html", "markdown", "text" },
  callback = function()
    vim.opt_local.spell = true
  end,
})

-- Filetype plugins can replace formatoptions, so apply these preferences afterward.
vim.api.nvim_create_autocmd("FileType", {
  group = group,
  callback = function()
    vim.opt_local.formatoptions:append({ "j", "n" })
  end,
})

