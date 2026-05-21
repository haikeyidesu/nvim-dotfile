-- Setup Mason
require("mason").setup()
require("mason-lspconfig").setup({
    ensure_installed = { "basedpyright", "gopls", "lua_ls" },
})

-- Setup standard servers
-- local standard servers
lspconfig = require("plugins.lsp_servers")

-- Roslyn bridge for C#
-- handles Roslyn requirements
-- TODO: add roslyn stuff here
