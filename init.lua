local vim = vim
local Plug = vim.fn["plug#"]

-- use terminal gui
vim.opt.termguicolors = true

vim.call("plug#begin")

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
Plug("gorbit99/codewindow.nvim")
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

vim.call("plug#end")

home = os.getenv("HOME")
package.path = home .. "/.config/nvim/?.lua;" .. package.path

require("common")
require("theme")
require("keymaps")
require("plugins.vimtree")
require("plugins.barbar_plugin")
require("plugins.lua_line")
require("plugins.lsp")
require("plugins.treesitter_setup")
require("plugins.cmp_config")
require("plugins.mason_setup")
require("plugins.masonlsp_setup")
require("plugins.autosession_setup")
require("plugins.comment_config")
require("plugins.indent_blankline_nvim")
-- enable for the nice command menu
-- require("noice_ui")
require("plugins.snacks_qol")
require("plugins.conform_formatter")
require("plugins.lazy_dev")
require("plugins.cw_minimap")
require("plugins.nvim_surround")
require("plugins.obsidian_nvim")
require("plugins.nvim_autopairs")
require("plugins.wilder_nvim")
require("plugins.nvim_image")
require("plugins.render_markdown")

-- homepage!
-- require("homepage").setup()

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
