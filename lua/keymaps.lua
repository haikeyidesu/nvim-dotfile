-- Set space as leader key (usually at the very top of init.lua or common.lua)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- remap j and k to keep cursor centred
-- vim.keymap.set("n", "j", "jzz")
-- vim.keymap.set("n", "k", "kzz")

-- map Shift + Ctrl + (j, k) to scroll more
vim.keymap.set("n", "<S-C-j>", "<C-d>zz")
vim.keymap.set("n", "<S-C-k>", "<C-u>zz")

-- save file and more
vim.keymap.set("n", "<leader>w", ":w<CR>", { desc = "Save file" })

vim.keymap.set("n", "<leader>q", ":q<CR>", { desc = "Quit current window" })

vim.keymap.set("n", "<leader>Q", ":qa<CR>", { desc = "Quit all" })

-- Obsidian! :)
vim.keymap.set("n", "<leader>o", ":Obsidian<CR>", { desc = "Obsidian commands" })
vim.keymap.set("n", "gf", ":Obsidian follow_link<CR>", { desc = "Obsidian follow_link" })
vim.keymap.set("n", "gr", ":Obsidian backlinks<CR>", { desc = "Obsidian backlinks" })
-- Toggle conceal level between 0 and 2
vim.keymap.set("n", "<leader>tc", function()
    if vim.opt_local.conceallevel:get() >= 1 then
        vim.opt_local.conceallevel = 0
    else
        vim.opt_local.conceallevel = 2
    end
end, { desc = "Toggle Conceal" })

-- vim.keymap.set("n", "<leader>wq", ":wqa<CR>", { desc = " Write and quit current window" })
--
-- vim.keymap.set("n", "<leader>wQ", ":wqa<CR>", { desc = " Write and quit all" })

-- toggle nvim tree
vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>", { silent = true, desc = "Toggle NvimTree" })

-- select all
-- vim.keymap.set({ "n", "v", "i" }, "<leader>a", "ggVG", { desc = "Select all" })

-- toggle terminal
vim.keymap.set("n", "<leader>t", ":terminal<CR>", { silent = true, desc = "Toggle NvimTree" })

-- reload nvim
vim.keymap.set("n", "<leader>R", ":source $MYVIMRC<CR>", { silent = true, desc = "Toggle NvimTree" })

-- More!
-- quick git push
vim.keymap.set("n", "<leader>gP", function()
    -- 1. Prompt the user for a commit message
    vim.ui.input({ prompt = "📝 Commit message: " }, function(msg)
        -- If you hit escape or leave it blank, cancel the whole thing
        if not msg or msg == "" then
            vim.notify("Push aborted: No commit message provided.", vim.log.levels.WARN)
            return
        end

        -- 2. Run the Fugitive commands sequentially
        vim.cmd("Git add .")
        vim.cmd('Git commit -m "' .. msg .. '"')
        vim.cmd("Git push")

        -- 3. Let you know it worked!
        vim.notify("🚀 Code Pushed: " .. msg, vim.log.levels.INFO)
    end)
end, { desc = "Git: Add All, Commit, and Push" })
