-- This checks if the module is already in the process of failing
if package.loaded["codewindow"] then
    package.loaded["codewindow"] = nil
end

local ok, cw = pcall(require, "codewindow")
if not ok then
    return
end

cw.setup({
    -- your settings here
})

vim.keymap.set("n", "<leader>mm", cw.toggle_minimap)
