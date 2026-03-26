vim.g.mapleader = " "
vim.keymap.set("t", "<c-esc>", "<c-\\><c-n>")

-- Standard Neovim LSP rename mapping
vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { desc = "LSP Rename" })

-- Auto-reload Neovim when init.lua is saved
local nvim_config_group = vim.api.nvim_create_augroup("NvimConfig", { clear = true })
vim.api.nvim_create_autocmd("BufWritePost", {
	group = nvim_config_group,
	pattern = "init.lua",
	callback = function()
		vim.cmd("source %")
		print("Config reloaded!")
	end,
})
