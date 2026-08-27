local vim = vim
local Plug = vim.fn["plug#"]

-- disable netrw hmm
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- use terminal gui
vim.opt.termguicolors = true

vim.call("plug#begin", "~/.config/nvim/plugged")

-- theme: tokyonight
Plug("folke/tokyonight.nvim")
-- theme: rose pine
Plug("rose-pine/neovim", { ["as"] = "rose-pine" })
-- theme: kanagawa (dragon)
Plug("rebelot/kanagawa.nvim")
-- theme: catpuccin
Plug("catppuccin/nvim", { ["as"] = "catppuccin" })
-- nvim tree for the sidebar thing
-- Plug("nvim-tree/nvim-tree.lua")
Plug("nvim-tree/nvim-web-devicons")
-- barbar for nice tabs
Plug("romgrk/barbar.nvim")
--lualine is the bar at the bottom that shows the vim mode
Plug("nvim-lualine/lualine.nvim")
-- treesitter for code syntax stuff
Plug("nvim-treesitter/nvim-treesitter", { ["do"] = ":TSUpdate" })
-- lspconfig for lsp configs
Plug("neovim/nvim-lspconfig")
-- mason for lsp management
Plug("mason-org/mason.nvim")
Plug("williamboman/mason-lspconfig.nvim")
-- plugins for autocomplete (though lsps are needed first)
Plug("hrsh7th/cmp-buffer")
Plug("hrsh7th/cmp-path")
Plug("hrsh7th/cmp-cmdline")
Plug("hrsh7th/nvim-cmp")
Plug("hrsh7th/cmp-nvim-lsp")
Plug("hrsh7th/cmp-nvim-lsp-signature-help")
-- autosession to remember file previously open
Plug("rmagatti/auto-session")
-- comment plugin
Plug("numToStr/Comment.nvim")
-- TODO plugin
Plug("folke/todo-comments.nvim")
-- fzf lua
Plug("ibhagwan/fzf-lua")
Plug("karb94/neoscroll.nvim")
Plug("folke/which-key.nvim")
-- for line indents
Plug("lukas-reineke/indent-blankline.nvim")
Plug("L3MON4D3/LuaSnip", { ["tag"] = "v2.*", ["do"] = "make install_jsregexp" }) -- Replace <CurrentMajor> by the latest released major (first number of latest release)
-- show error diagnostics stuff
Plug("folke/trouble.nvim")
-- UI component lib for nvim
Plug("MunifTanjim/nui.nvim")
-- Plug("rcarriga/nvim-notify")
-- nice command menu popup
-- Plug('folke/noice.nvim')
-- snacks, a collection of QoL plugins
Plug("folke/snacks.nvim")
-- powerful formatter plugin
Plug("stevearc/conform.nvim")
Plug("folke/lazydev.nvim")
-- minimap
Plug("echasnovski/mini.map")
-- nvim surround, for adding quotes and braces around text
Plug("kylechui/nvim-surround")
Plug("obsidian-nvim/obsidian.nvim")
-- autopairs for automatically paired quotes and braces
Plug("windwp/nvim-autopairs")
-- for terminal commands autocomplete
Plug("gelguy/wilder.nvim")
-- for rendering images in nvim
Plug("3rd/image.nvim")
Plug("MeanderingProgrammer/render-markdown.nvim")
-- luasnip and friends
Plug("L3MON4D3/LuaSnip")
Plug("saadparwaiz1/cmp_luasnip")
Plug("rafamadriz/friendly-snippets") -- Pre-made snippets for Go, Lua, etc.
Plug("linux-cultist/venv-selector.nvim")
-- telescope!
Plug("nvim-telescope/telescope.nvim")
Plug("nvim-lua/plenary.nvim")
-- Git integrations
Plug("lewis6991/gitsigns.nvim")
Plug("tpope/vim-fugitive")
-- harpoooon
-- the harpoon man is here!
Plug("ThePrimeagen/harpoon", { branch = "harpoon2" })
-- vim-tmux plugin
Plug("christoomey/vim-tmux-navigator")
-- colorizer
Plug("NvChad/nvim-colorizer.lua")
-- plugins for Jupyter notebook
Plug("benlubas/molten-nvim", { ["do"] = ":UpdateRemotePlugins" })
Plug("GCBallesteros/jupytext.nvim")
Plug("jmbuhr/otter.nvim")
-- lsp snippets
Plug("lewis6991/async.nvim")
Plug("ThePrimeagen/refactoring.nvim")
-- for java
Plug("mfussenegger/nvim-jdtls")

vim.call("plug#end") -- Everything below this line knows plugins exist!

-- Treesitter configuration moved here so it safely initializes after plug#end
local status, configs = pcall(require, "nvim-treesitter.configs")
if status then
    configs.setup({
        -- A list of parser names, or "all"
        ensure_installed = { "lua", "vim", "vimdoc", "markdown", "markdown_inline", "go" },

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
end

-- toggle off explorer and minimap on dashboard
-- hide explorer and minimap panels when the dashboard opens
vim.api.nvim_create_autocmd("FileType", {
    pattern = "snacks_dashboard",
    callback = function()
        -- 1. Lock down mini.map so it disables and closes on this screen
        vim.b.minimap_disable = true
        if package.loaded["mini.map"] then
            pcall(MiniMap.close)
        end

        -- 2. Scan and close any sidebar window pane (like Snacks Explorer)
        for _, win in ipairs(vim.api.nvim_list_wins()) do
            if vim.api.nvim_win_is_valid(win) then
                local buf = vim.api.nvim_win_get_buf(win)
                local ft = vim.bo[buf].filetype

                -- Snacks Explorer uses 'snacks_picker_list' under the hood
                if ft == "snacks_picker_list" or ft == "NvimTree" then
                    pcall(vim.api.nvim_win_close, win, true)
                end
            end
        end
    end,
})

-- In your lsp configuration
vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if client and client.server_capabilities.semanticTokensProvider then
            client.server_capabilities.semanticTokensProvider = {
                full = true,
                legend = client.server_capabilities.semanticTokensProvider.legend,
            }
        end
    end,
})

home = os.getenv("HOME")
-- package.path = home .. "/.config/nvim/?.lua;" .. package.path

local function load(module)
    local ok, err = pcall(require, module)
    if not ok then
        -- 󰜘 Safe Guard: Use Snacks if it exists, otherwise fall back to native vim.notify
        if _G.Snacks and Snacks.notify then
            Snacks.notify.error("-[x] CRASH in " .. module .. ": " .. tostring(err))
        else
            vim.notify("-[x] CRASH in " .. module .. ": " .. tostring(err), vim.log.levels.ERROR)
        end
        return false
    end

    -- 󰗡 Safe Guard: Stacks successful modules perfectly once Snacks loads up
    if _G.Snacks and Snacks.notify then
        Snacks.notify.info(" 󰗡  Loaded: " .. module)
    end
    return true
end

-- Global LSP Message Deduplicator
-- Catches rapid-fire duplicate alerts from language servers (like basedpyright)
local last_lsp_message = ""
local original_lsp_handler = vim.lsp.handlers["window/showMessage"]

vim.lsp.handlers["window/showMessage"] = function(err, result, ctx, config)
    if result and result.message then
        -- If this message is identical to the last one received, ignore it completely
        if result.message == last_lsp_message then
            return
        end
        last_lsp_message = result.message

        -- Optional: Completely mute this specific venv warning if it annoys you:
        -- if result.message:match("venv .- subdirectory not found") then return end
    end
    return original_lsp_handler(err, result, ctx, config)
end

-- Prevent Neovim from choking on massive files (like your GGUF)
vim.api.nvim_create_autocmd("BufReadPre", {
    pattern = "*",
    callback = function()
        local size = vim.fn.getfsize(vim.fn.expand("%:p"))
        if size > 10 * 1024 * 1024 then -- 10MB limit
            vim.cmd("syntax off")
            vim.cmd("buffer delete")
            print("File too large! Neovim blocked it to save your sanity.")
        end
    end,
})

-- Now safely loading modules using your custom load function wrapper
load("common")
load("theme")
load("keymaps")
-- load("plugins.vimtree")
load("plugins.barbar_plugin")
load("plugins.lsp_servers")
load("plugins.lua_line")
load("plugins.lsp")
load("plugins.treesitter_setup")
load("plugins.cmp_config")
load("plugins.mason_setup")
load("plugins.autosession_setup")
load("plugins.comment_config")
load("plugins.todo")
load("plugins.indent_blankline_nvim")
-- enable for the nice command menu
-- load("noice_ui")
load("plugins.snacks_qol")
load("plugins.conform_formatter")
load("plugins.lazy_dev")
load("plugins.mini_map")
load("plugins.nvim_surround")
load("plugins.obsidian_nvim")
load("plugins.nvim_autopairs")
load("plugins.wilder_nvim")
load("plugins.nvim_image")
load("plugins.render_markdown")
-- venv selector
load("plugins.venv_selector")
-- git integrations
load("plugins.git_signs")
load("plugins.harpoon_man")
load("plugins.jupyter")
load("plugins.otter_nvim")
load("plugins.refactoring_nvim")
load("plugins.jdtls_setup")

-- homepage!
-- require("homepage").setup()

-- remove error things for markdown?
vim.api.nvim_create_autocmd("FileType", {
    pattern = "markdown",
    callback = function()
        vim.diagnostic.enable(false, { bufnr = 0 })
        vim.schedule(function()
            pcall(function()
                require("mini.map").close()
            end)
        end)
    end,
})

-- -- LSPs worth stopping when Neovim loses focus
-- local heavy_lsps = {
--     "jdtls", -- Java (JVM, very heavy)
--     "rust_analyzer", -- Rust (continuous analysis)
--     "clangd", -- C/C++ (large memory footprint)
--     "pyright", -- Python (CPU spikes during type checking)
-- }
--
-- -- Stop heavy LSPs when Neovim loses focus
-- vim.api.nvim_create_autocmd("FocusLost", {
--     pattern = "*",
--     callback = function()
--         local clients = vim.lsp.get_clients()
--         for _, client in ipairs(clients) do
--             if vim.tbl_contains(heavy_lsps, client.name) then
--                 vim.lsp.stop_client(client.id)
--             end
--         end
--     end,
-- })
--
-- -- Restart them when you come back
-- -- NOTE: Highly recommended to keep this commented out.
-- -- Auto-restarting jdtls on focus will freeze your editor for 10-20s
-- -- while the JVM boots up. It's better to just let it start naturally
-- -- when you open a new Java file.
-- --[[
-- vim.api.nvim_create_autocmd("FocusGained", {
--     pattern = "*",
--     callback = function()
--         local filetype_to_lsp = {
--             java = "jdtls",
--             rust = "rust_analyzer",
--             c = "clangd",
--             cpp = "clangd",
--             python = "pyright",
--         }
--         local lsp = filetype_to_lsp[vim.bo.filetype]
--
--         -- Only attempt to restart if it's not already running
--         if lsp and vim.tbl_contains(heavy_lsps, lsp) then
--             if #vim.lsp.get_clients({ name = lsp }) == 0 then
--                 vim.cmd("LspStart " .. lsp)
--             end
--         end
--     end,
-- })
-- --]]
