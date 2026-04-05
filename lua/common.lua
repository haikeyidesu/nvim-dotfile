local vim = vim

-- display line numbers
vim.wo.number = true

-- enable mouse control
vim.g.mouse = "a"
vim.opt.encoding = "utf-8"

-- disable swap files
vim.opt.swapfile = false

-- set tab and indent settings
vim.opt.scrolloff = 7
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.autoindent = true

-- set relative line numbers
vim.wo.relativenumber = true

vim.opt.fileformat = "unix"

-- smooth scrolling
vim.opt.smoothscroll = true

-- sync with system keyboard
vim.opt.clipboard = "unnamedplus"

-- persistent undo
-- create an undo directory to save history acrossrestarts
vim.opt.undofile = true

-- clear search highlights with esc
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- highlist when yanking
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank({
			higroup = "IncSearch",
			timeout = 150,
		})
	end,
})

-- move between splits with ctrl + hjkl

vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Move to left split" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Move to below split" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Move to above split" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Move to right split" })

-- highlight working line
vim.opt.cursorline = true

-- for loading tabs
vim.opt.expandtab = false -- Use actual tabs, not spaces
vim.opt.tabstop = 4 -- Number of spaces a tab counts for
vim.opt.shiftwidth = 4 -- Number of spaces for auto-indent
