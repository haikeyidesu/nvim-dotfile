local otter = require("otter")

-- Automatically run Otter when opening a markdown file
vim.api.nvim_create_autocmd("FileType", {
    pattern = "markdown",
    callback = function()
        -- Activates python LSP tracking within markdown code fences
        otter.activate({ "python" }, true, true, nil)
    end,
})
