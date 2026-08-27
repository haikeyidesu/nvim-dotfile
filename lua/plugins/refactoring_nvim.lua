local refactoring = require("refactoring")

-- Initialize the plugin
refactoring.setup()

-- Remaps for the refactoring operations you'll use most in Java/Go
-- '<leader>rr' opens the main Refactoring menu in visual mode
vim.keymap.set("x", "<leader>rr", function()
    refactoring.select_refactor()
end, { desc = "Refactor Menu" })

-- Quick extract variable (Visual Mode)
vim.keymap.set("x", "<leader>rv", ":Refactor extract_var ", { desc = "Extract Variable" })

-- Quick extract function (Visual Mode)
vim.keymap.set("x", "<leader>rf", ":Refactor extract ", { desc = "Extract Function" })
