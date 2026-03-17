
vim.opt.nu = true
vim.opt.relativenumber = true

vim.g.netrw_bufsettings = 'noma nomod nu rnu nobl nowrap ro'

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.smartindent = true

vim.opt.wrap = false

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

vim.opt.updatetime = 50

-- Fold settings
vim.opt.foldmethod = "indent"
vim.opt.foldenable = true
vim.opt.foldlevel = 99 -- Start with all folds open, use zM to close all

-- vim.opt.colorcolumn = "80"

vim.diagnostic.config({
  signs = false
})
