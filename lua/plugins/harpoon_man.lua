local harpoon = require("harpoon")
harpoon.setup({})

-- basic telescope configuration
local conf = require("telescope.config").values
local function toggle_telescope(harpoon_files)
    local file_paths = {}
    for _, item in ipairs(harpoon_files.items) do
        table.insert(file_paths, item.value)
    end

    require("telescope.pickers")
        .new({}, {
            prompt_title = "Harpoon",
            finder = require("telescope.finders").new_table({
                results = file_paths,
            }),
            previewer = conf.file_previewer({}),
            sorter = conf.generic_sorter({}),
        })
        :find()
end

-- setting harpoon marks
vim.keymap.set("n", "<leader>ha1", function()
    require("harpoon"):list():replace_at(1)
    vim.notify("󰈺 Marked #1")
end, { desc = "Harpoon: Set Mark #1" })

vim.keymap.set("n", "<leader>ha2", function()
    require("harpoon"):list():replace_at(2)
    vim.notify("󰈺 Marked #1")
end, { desc = "Harpoon: Set Mark #2" })

vim.keymap.set("n", "<leader>ha3", function()
    require("harpoon"):list():replace_at(3)
    vim.notify("󰈺 Marked #1")
end, { desc = "Harpoon: Set Mark #3" })

vim.keymap.set("n", "<leader>ha4", function()
    require("harpoon"):list():replace_at(4)
    vim.notify("󰈺 Marked #1")
end, { desc = "Harpoon: Set Mark #4" })

vim.keymap.set("n", "<leader>ha5", function()
    require("harpoon"):list():replace_at(5)
    vim.notify("󰈺 Marked #1")
end, { desc = "Harpoon: Set Mark #5" })

-- view marked harpoon files
vim.keymap.set("n", "<leader>hv", function()
    toggle_telescope(harpoon:list())
    vim.schedule(function()
        -- 'n' means normal mode, true means escape special characters
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", false)
    end)
end, { desc = "Harpoon: View marked files" })

-- keymaps for harpoons 1 to 5
vim.keymap.set("n", "<leader>h1", function()
    harpoon:list():select(1)
    vim.notify("󰈺↽ #1")
end, { desc = "Harpoon: fly to mark #1" })

vim.keymap.set("n", "<leader>h2", function()
    harpoon:list():select(2)
    vim.notify("󰈺↽ #2")
end, { desc = "Harpoon: fly to mark #2" })

vim.keymap.set("n", "<leader>h3", function()
    harpoon:list():select(3)
    vim.notify("󰈺↽ #3")
end, { desc = "Harpoon: fly to mark #3" })

vim.keymap.set("n", "<leader>h4", function()
    harpoon:list():select(4)
    vim.notify("󰈺↽ #4")
end, { desc = "Harpoon: fly to mark #4" })

vim.keymap.set("n", "<leader>h5", function()
    harpoon:list():select(5)
    vim.notify("󰈺↽ #5")
end, { desc = "Harpoon: fly to mark #5" })
