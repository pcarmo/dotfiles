vim.g.mapleader = " "
vim.keymap.set("n", "<leader>pv", vim.cmd.NvimTreeToggle)
vim.keymap.set("t", "<Esc>", "<C-\\><C-n>")
vim.o.clipboard = 'unnamedplus'
vim.keymap.set("n", "<leader>ei", vim.diagnostic.open_float)
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }
