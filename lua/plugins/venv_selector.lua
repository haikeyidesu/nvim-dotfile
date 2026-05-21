local status, venv_selector = pcall(require, "venv-selector")
if not status then
    return
end

venv_selector.setup({
    -- Optional: Customize which venv names to look for
    name = { ".venv", "venv", ".env", "env" },

    -- Optional: If you use conda, set this to true
    prefer_conda = false,

    -- Optional: Automatically select the venv when opening a file
    auto_select = true,
})

-- Set the keymap to open the selector
vim.keymap.set("n", "<leader>vs", ":VenvSelect<CR>", { desc = "Select Python Virtual Environment" })
