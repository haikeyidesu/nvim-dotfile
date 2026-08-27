local vim = vim

-- increase nvim's updatetime
vim.opt.updatetime = 250

-- display line numbers
vim.wo.number = true

-- enable mouse control
vim.g.mouse = "a"
vim.opt.encoding = "utf-8"

-- disable swap files
vim.opt.swapfile = false

-- set tab and indent settings
vim.opt.scrolloff = 999
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.autoindent = true
vim.opt.expandtab = true -- Use actual tabs, not spaces
vim.opt.smarttab = true
vim.opt.smartindent = true
vim.opt.shiftround = true -- round indent
vim.opt.list = true

-- undoo
vim.opt.undolevels = 10000

-- disable modeline
vim.opt.modeline = false

-- set relative line numbers
vim.wo.relativenumber = true

vim.opt.fileformat = "unix"

-- smooth scrolling
vim.opt.smoothscroll = true

-- sync with system keyboard
vim.opt.clipboard = "unnamedplus"

-- persistent undo
-- create an undo directory to save history across restarts
vim.opt.undofile = true

-- what's this do?
-- less notifications, disable intro default screen, removes some distracting completion popup thing ig
vim.opt.shortmess:append({ W = true, I = true, c = true })

-- clear search highlights with esc
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- highlight when yanking
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

-- jj to enter normal mode (from insert mode)
vim.keymap.set("i", "jk", "<Esc>")

-- moved to keymaps.lua
-- vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Move to left split" })
-- vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Move to below split" })
-- vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Move to above split" })
-- vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Move to right split" })

-- highlight working line
vim.opt.cursorline = true

vim.startofline = false

vim.opt.virtualedit = "block"

-- confirm save before exiting
vim.opt.confirm = true

-- single global statusline at the bottom
vim.opt.laststatus = 3 -- Enables a single, global statusline at the bottom

-- have nvim respect your indentation stuff whatnot instead of overriding for markdown styling
vim.g.markdown_recommended_style = 0

-- comment string?
vim.bo.commentstring = "# %s"
