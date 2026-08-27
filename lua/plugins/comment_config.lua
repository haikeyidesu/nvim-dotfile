require("Comment").setup({
    -- ... your existing configs (toggles, mappings, etc.) ...

    pre_hook = function(ctx)
        -- Check if the file we are currently editing is a TOML file
        if vim.bo.filetype == "toml" then
            return "# %s"
        end
    end,
})

local ft = require("Comment.ft")
ft.set("conf", "# %s")
ft.set("tmux", "# %s")
ft.set("toml", "# %s")

vim.filetype.add({
    filename = {
        ["tmux.conf"] = "tmux",
        [".tmux.conf"] = "tmux",
    },
    extension = {
        conf = "tmux",
        toml = "toml",
    },
})
