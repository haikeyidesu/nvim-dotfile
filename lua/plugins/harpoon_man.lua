local harpoon = require("harpoon")
harpoon.setup({})

-- basic telescope configuration
local conf = require("telescope.config").values
local function toggle_telescope(harpoon_files)
    local file_paths = {}

    -- 1. Just grab the basic file paths
    for _, item in ipairs(harpoon_files.items) do
        table.insert(file_paths, item.value)
    end

    require("telescope.pickers")
        .new({}, {
            prompt_title = "Harpoon",
            finder = require("telescope.finders").new_table({
                results = file_paths,

                entry_maker = function(entry)
                    -- 2. 🪝 Ask our global function for the index of THIS specific entry
                    local idx = _G.get_harpoon_index(entry)

                    -- 3. If an index exists, format it nicely. Otherwise, just use the path.
                    local display_str = idx and string.format("#%d %s", idx, entry) or entry

                    return {
                        value = entry,
                        display = display_str, -- What you see (e.g., "󰈺 [1] lua/keymaps.lua")
                        ordinal = entry, -- What you search against
                        path = entry, -- What gets opened
                    }
                end,
            }),
            previewer = conf.file_previewer({}),
            sorter = conf.generic_sorter({}),
        })
        :find()
end

-- Get Harpoon ID for ANY file
_G.get_harpoon_index = function(file_path)
    -- 1. If no path is provided, default to the current active buffer
    local path_to_check = file_path or vim.api.nvim_buf_get_name(0)

    -- 2. Convert to relative path
    local normalized_path = vim.fn.fnamemodify(path_to_check, ":.")

    -- 3. Safely load Harpoon (prevents crashes during startup)
    local ok, harpoon = pcall(require, "harpoon")
    if not ok then
        return nil
    end

    -- 4. Loop to find the match
    for i, item in ipairs(harpoon:list().items) do
        if item.value == normalized_path then
            return i -- Match found! Return the slot number.
        end
    end

    return nil -- Not in Harpoon
end

-- view marked harpoon files
vim.keymap.set("n", "<leader>hh", function()
    toggle_telescope(harpoon:list())
    vim.schedule(function()
        -- 'n' means normal mode, true means escape special characters
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", false)
    end)
end, { desc = "Harpoon: Harpoon marked files" })

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
