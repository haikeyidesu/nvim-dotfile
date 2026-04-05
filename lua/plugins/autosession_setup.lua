require'auto-session'.setup {
	bypass_save_filetypes = { "snacks_dashboard", "dashboard" },
	suppressed_dirs = { "~/", "~/Projects", "~/Downloads", "/"},
	auto_restore_last_session = true
}

vim.o.sessionoptions="blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"
