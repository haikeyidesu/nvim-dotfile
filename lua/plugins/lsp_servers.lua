-- lua/plugins/lsp_servers.lua

-- 1. Setup Capabilities (Autocomplete)
local status, cmp_lsp = pcall(require, "cmp_nvim_lsp")
local capabilities = status and cmp_lsp.default_capabilities() or {}

-- 2. Define your server list
local servers = { "gopls", "basedpyright", "lua_ls" }

-- 3. Use the new Native API to configure and enable
for _, server in ipairs(servers) do
    -- This replaces the old .setup() call entirely
    vim.lsp.config(server, {
        capabilities = capabilities,
        settings = (server == "gopls") and {
            gopls = {
                analyses = { unusedparams = true },
                staticcheck = true,
                gofumpt = true,
            },
        } or (server == "lua_ls") and {
            Lua = {
                diagnostics = { globals = { "vim" } },
            },
        } or (server == "basedpyright") and {
            root_dir = vim.fs.root(0, { ".git", "pyrightconfig.json", "requirements.txt" }),
            basedpyright = {
                analysis = {
                    autoSearchPaths = true,
                    useLibraryCodeForTypes = true,
                    diagnosticMode = "openFilesOnly",
                },
                -- MODIFIED: Use a dynamic function so paths update if you jump folders
                extraPaths = { "${workspaceFolder}" },
            },
        } or {},
    })

    -- This tells Neovim to actually start the server for its filetypes
    vim.lsp.enable(server)
end

-- Restart basedpyright when VenvSelect changes the environment
vim.api.nvim_create_autocmd("User", {
    pattern = "VenvSelectPost",
    callback = function()
        vim.cmd("LspRestart")
    end,
})
