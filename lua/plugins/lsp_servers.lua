-- lua/plugins/lsp_servers.lua

-- 1. Setup Capabilities (Autocomplete)
local status, cmp_lsp = pcall(require, "cmp_nvim_lsp")
local capabilities = status and cmp_lsp.default_capabilities() or {}

-- 2. Define server configs cleanly (Fixes the misplaced root bug and messy ternaries)
local server_configs = {
    gopls = {
        root_markers = { "go.work", "go.mod", ".git" },
        settings = {
            gopls = {
                analyses = { unusedparams = true },
                staticcheck = true,
                gofumpt = true,
            },
        },
    },

    lua_ls = {
        root_markers = { ".luarc.json", ".git" },
        settings = {
            Lua = {
                diagnostics = { globals = { "vim" } },
            },
        },
    },

    basedpyright = {
        -- FIX: root_markers belongs here at the top level, NOT inside settings!
        root_markers = { ".git", "pyrightconfig.json", "requirements.txt", "pyproject.toml" },
        settings = {
            basedpyright = {
                analysis = {
                    autoSearchPaths = true,
                    useLibraryCodeForTypes = true,
                    diagnosticMode = "openFilesOnly",
                },
                extraPaths = { "${workspaceFolder}" },
            },
        },
    },

    vtsls = {
        root_markers = {
            "package.json",
            "tsconfig.json",
            "jsconfig.json",
            ".git",
        },
    },

    html = {
        filetypes = { "html" },
    },

    cssls = {
        filetypes = { "css", "scss", "less" },
    },

    emmet_language_server = {
        filetypes = {
            "html",
            "css",
            "scss",
            "less",
            "javascriptreact",
            "typescriptreact",
        },
    },
}

-- 3. Loop through and apply configurations using Native Neovim API
for server, config in pairs(server_configs) do
    -- Inject the shared autocomplete capabilities
    config.capabilities = capabilities

    -- Register and trigger automatic activation
    vim.lsp.config(server, config)
    vim.lsp.enable(server)
end

-- Restart basedpyright when VenvSelect changes the environment
vim.api.nvim_create_autocmd("User", {
    pattern = "VenvSelectPost",
    callback = function()
        vim.cmd("LspRestart")
    end,
})
