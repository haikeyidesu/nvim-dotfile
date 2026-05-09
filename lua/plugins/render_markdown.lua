require("render-markdown").setup({
    -- This is the critical part for Obsidian users
    link = {
        enabled = true,
        image = "󰥶 ",
        hyperlink = "󰌹 ",
        wiki = {
            enabled = true,
            icon = "󰥶 ", -- Show an image icon for wikilinks too
        },
        -- This helps image.nvim "see" the path inside the brackets
        custom = {
            obsidian = {
                pattern = "^!%[%[.-%]%]$",
                render = function(manager, node, label)
                    -- This function helps resolve the image path for the image plugin
                end,
            },
        },
    },
})
