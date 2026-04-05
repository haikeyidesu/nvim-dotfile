local vim = vim
local Plug = vim.fn['plug#']

-- use terminal gui
vim.opt.termguicolors = true

vim.call('plug#begin')

-- theme: tokyonight
Plug('folke/tokyonight.nvim')
-- nvim tree for the sidebar thing
Plug('nvim-tree/nvim-tree.lua')
Plug('nvim-tree/nvim-web-devicons')
-- barbar for nice tabs
Plug('romgrk/barbar.nvim')
--lualine is the bar at the bottom that shows the vim mode
Plug('nvim-lualine/lualine.nvim')
-- treesitter for code syntax stuff
Plug('nvim-treesitter/nvim-treesitter', {['do'] = ':TSUpdate'})
-- lspconfig for lsp configs
Plug('neovim/nvim-lspconfig')
-- mason for lsp management
Plug('mason-org/mason.nvim')
Plug('williamboman/mason-lspconfig.nvim')
-- plugins for autocomplete (though lsps are needed first)
Plug('hrsh7th/cmp-buffer') 
Plug('hrsh7th/cmp-path')
Plug('hrsh7th/cmp-cmdline') 
Plug('hrsh7th/nvim-cmp')
Plug('hrsh7th/cmp-nvim-lsp' ) 
Plug('hrsh7th/cmp-nvim-lsp-signature-help') 
-- autosession to remember file previously open
Plug('rmagatti/auto-session')
-- comment plugin
Plug('numToStr/Comment.nvim')
-- fzf lua
Plug('ibhagwan/fzf-lua')
Plug 'karb94/neoscroll.nvim'
Plug('folke/which-key.nvim')
-- for line indents
Plug('lukas-reineke/indent-blankline.nvim')
Plug('L3MON4D3/LuaSnip', {['tag'] = 'v2.*', ['do'] = 'make install_jsregexp'}) -- Replace <CurrentMajor> by the latest released major (first number of latest release)
-- show error diagnostics stuff
Plug('folke/trouble.nvim')
-- UI component lib for nvim
Plug 'MunifTanjim/nui.nvim'
Plug 'rcarriga/nvim-notify'
-- nice command menu popup
-- Plug('folke/noice.nvim')
-- snacks, a collection of QoL plugins
Plug('folke/snacks.nvim')
Plug('stevearc/conform.nvim')

vim.call('plug#end')

home = os.getenv("HOME")
package.path = home .. "/.config/nvim/?.lua;" .. package.path

require "common"
require "theme"
require "keymaps"
require "plugins.vimtree"
require "plugins.barbar_plugin"
require "plugins.lua_line"
require "plugins.lsp"
require "plugins.cmp_config"
require "plugins.mason_setup"
require "plugins.masonlsp_setup"
require "plugins.autosession_setup"
require("plugins.comment_config")
require("plugins.indent_blankline_nvim")
-- enable for the nice command menu 
-- require("noice_ui")
require "plugins.snacks_qol"
require "plugins.conform_formatter"

-- homepage!
-- require("homepage").setup()
