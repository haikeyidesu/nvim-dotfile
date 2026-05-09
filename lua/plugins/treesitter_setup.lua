local status, configs = pcall(require, "nvim-treesitter.configs")
if not status then
    return
end

configs.setup({
    -- A list of parser names, or "all"
    ensure_installed = { "lua", "vim", "vimdoc", "markdown", "markdown_inline" },

    -- Install parsers synchronously (only applied to `ensure_installed`)
    sync_install = false,

    -- Automatically install missing parsers when entering buffer
    auto_install = true,

    highlight = {
        enable = true, -- MUST be true for the minimap to see colors!
        additional_vim_regex_highlighting = false,
    },
    indent = {
        enable = true,
    },
})
