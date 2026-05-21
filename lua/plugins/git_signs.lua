local ok, gitsigns = pcall(require, "gitsigns")
if not ok then
    error("Could not load gitsigns")
end

-- Minimal setup: Just turn on the inline blame (ghost text)
gitsigns.setup({
    current_line_blame = true,
})
