local status, obsidian = pcall(require, "obsidian")
if not status then
    return
end

obsidian.setup({
    legacy_commands = false,
    workspaces = {
        {
            name = "personal",
            path = "/Users/asher/Library/Mobile Documents/iCloud~md~obsidian/Documents/asher's obsidian vault/daily notes/22 May 2025 (Thursday).md",
        },
    },
    -- UI customization
    ui = {
        enable = false, -- set to false to disable all UI features
    },

    -- THE NEW CHECKBOX SYSTEM
    checkboxes = {
        -- The order you want to cycle through when you hit <CR> or use the toggle command
        -- " " is empty, "x" is done, "!" is important, etc.
        order = { " ", "x", "!", ">" },
        -- If true, hitting toggle on a normal line converts it to a checkbox list item
        create_new = true,
    },
    templates = {
        folder = "Templates", -- Matches "Template folder location" in image
        date_format = "%d-%m-%Y", -- Matches "DD-MM-YYYY" in image
        time_format = "%H:%M", -- Matches "HH:mm" in image
    },
    daily_notes = {
        -- The folder where daily notes are stored (relative to vault root)
        folder = "daily notes",

        -- The date format for the filename
        -- %d = 03, %B = May, %Y = 2026, %A = Sunday
        date_format = "%d %B %Y (%A)",

        -- The template to use (relative to the templates folder)
        template = "Daily Notes Template.md",
    },
})

-- Set conceal level 2 for markdown files
vim.api.nvim_create_autocmd("FileType", {
    pattern = "markdown",
    callback = function()
        vim.opt_local.conceallevel = 2
    end,
})
