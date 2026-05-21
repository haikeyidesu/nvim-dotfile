require("auto-session").setup({
    bypass_save_filetypes = { "snacks_dashboard", "dashboard" },
    suppressed_dirs = { "~/", "~/Projects", "~/Downloads", "/" },
    auto_restore_last_session = true,
})

-- 󰜘 Changed: Removed "buffers" so background file histories don't pollute your top bar on startup
vim.o.sessionoptions = "blank,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"
