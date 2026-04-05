-- Set space as leader key (usually at the very top of init.lua or common.lua)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Set <leader>w to save file
vim.keymap.set('n', '<leader>w', ':w<CR>', {silent = true, desc = 'Save file'})
-- Set <leader>e to toggle nvim-tree
vim.keymap.set('n', '<leader>e', ':NvimTreeToggle<CR>', { silent = true, desc = 'Toggle NvimTree' })
