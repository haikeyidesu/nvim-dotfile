local vim = vim
local Plug = vim.fn["plug#"]

-- use terminal gui
vim.opt.termguicolors = true

vim.call("plug#begin", "~/.config/nvim/plugged")

-- theme: tokyonight
Plug("folke/tokyonight.nvim")
-- nvim tree for the sidebar thing
Plug("nvim-tree/nvim-tree.lua")
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
Plug("rcarriga/nvim-notify")
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

vim.notify("-( ) init.lua reached config section", vim.log.levels.INFO)

local function load(module)
    local ok, err = pcall(require, module)
    if not ok then
        vim.notify("-[x] CRASH in " .. module .. ": " .. tostring(err), vim.log.levels.ERROR)
        return false
    end
    vim.notify("-[v] Loaded: " .. module, vim.log.levels.INFO)
    return true
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
load("plugins.vimtree")
load("plugins.barbar_plugin")
load("plugins.lsp_servers")
load("plugins.lua_line")
load("plugins.lsp")
load("plugins.treesitter_setup")
load("plugins.cmp_config")
load("plugins.mason_setup")
load("plugins.autosession_setup")
load("plugins.comment_config")
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

-- homepage!
-- require("homepage").setup()

-- remove error things for markdown?
vim.api.nvim_create_autocmd("FileType", {
    pattern = "markdown",
    callback = function()
        vim.diagnostic.enable(false, { bufnr = 0 })
    end,
})

-- remove error things for python (for now)
vim.api.nvim_create_autocmd("FileType", {
    pattern = "python",
    callback = function()
        vim.diagnostic.enable(false, { bufnr = 0 })
    end,
})

-- obsidian backlinking shortcut
-- This will jump to the link under your cursor
-- vim.keymap.set("n", "gf", function()
--     if require("obsidian").util.smart_action() then
--         return
--     else
--         -- Fallback to native gf if not on an Obsidian link
--         vim.cmd("normal! gf")
--     end
-- end, { desc = "Smart Action / Go to File", buffer = true })

-- create new folder
-- vim.api.nvim_create_autocmd(
--     { "BufWritePre", },
--     {
--         callback = function(event)
--             if event.match:match("^%w%w+:[\\/][\\/]") then
--                 return
--             end
--             local file = vim.uv.fs_realpath(event.match) or event.match vim.fn.mkdir(vim.fn.fnamemodify(file, ":h", "p")
--         end,
--     }
-- )
