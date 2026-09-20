local map = vim.keymap.set

-- Keep wrapped-line movement intuitive if wrapping is enabled temporarily.
map({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
map({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

map("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlight" })
map("n", "<leader>w", "<cmd>write<CR>", { desc = "Write file" })
map("n", "<leader>q", "<cmd>quit<CR>", { desc = "Quit window" })

-- \V means "very nomagic": punctuation is searched literally, not as a pattern.
-- A slash or backslash in the query still needs the usual command-line escaping.
map({ "n", "x", "o" }, "/", "/\\V", { desc = "Search forward (literal)" })
map({ "n", "x", "o" }, "?", "?\\V", { desc = "Search backward (literal)" })
map("n", "<leader>sr", "/", { desc = "Search forward (regex)" })
map("n", "<leader>sR", "?", { desc = "Search backward (regex)" })

map("n", "<C-h>", "<C-w>h", { desc = "Window left" })
map("n", "<C-j>", "<C-w>j", { desc = "Window down" })
map("n", "<C-k>", "<C-w>k", { desc = "Window up" })
map("n", "<C-l>", "<C-w>l", { desc = "Window right" })

-- Keep selected text selected while changing indentation.
map("x", "<", "<gv")
map("x", ">", ">gv")
