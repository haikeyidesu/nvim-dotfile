-- Setup Mason
require("mason").setup()
require("mason-lspconfig").setup({
	ensure_installed = { "pyright", "gopls", "lua_ls" }
})

-- Setup standard servers
-- local standard servers
lspconfig = require('lspconfig')

-- Roslyn bridge for C#
-- handles Roslyn requirements
-- TODO: add roslyn stuff here
