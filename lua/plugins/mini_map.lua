local ok, map = pcall(require, "mini.map")
if not ok then
    error("Could not load mini.map")
end

map.setup({
    -- 1. Integrations: What should show up on the minimap?
    integrations = {
        map.gen_integration.builtin_search(), -- Shows search results
        map.gen_integration.diagnostic(), -- Shows LSP errors/warnings
        -- map.gen_integration.gitsigns(),    -- Uncomment if you use lewis6991/gitsigns.nvim
    },

    -- 2. Visuals: How the code is drawn
    symbols = {
        -- '4x2' gives you that tight, blocky VS-Code look you had before
        encode = map.gen_encode_symbols.dot("4x2"),
    },

    -- 3. Window Settings: Matching your old codewindow preferences
    window = {
        width = 14, -- Your preferred 14-character width
        winblend = 0, -- 0 = solid background. (Try 25 or 50 if you want it slightly transparent!)
        zindex = 10, -- Keeps it neatly tucked under floating menus like autocomplete
    },
})

-- ==========================================================================
-- Keymaps (Restored from your codewindow setup)
-- ==========================================================================

-- Toggle the minimap on and off
vim.keymap.set("n", "<leader>mm", map.toggle, { desc = "Minimap: Toggle" })

-- Focus cursor into the minimap to rapidly navigate using standard j/k movements
vim.keymap.set("n", "<leader>mf", map.toggle_focus, { desc = "Minimap: Focus window" })
