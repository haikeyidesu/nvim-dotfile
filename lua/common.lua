local vim = vim

-- display line numbers
vim.wo.number = true

-- enable mouse control
vim.g.mouse = "a"
vim.opt.encoding = "utf-8"

-- disable swap files
vim.opt.swapfile = false

-- set tab and indent settings
vim.opt.scrolloff = 999
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.autoindent = true
vim.opt.expandtab = true -- Use actual tabs, not spaces
vim.opt.smarttab = true
vim.opt.smartindent = true
vim.opt.shiftround = true -- round indent
vim.opt.list = true

-- undoo
vim.opt.undolevels = 10000

-- disable modeline
vim.opt.modeline = false

-- set relative line numbers
vim.wo.relativenumber = true

vim.opt.fileformat = "unix"

-- smooth scrolling
vim.opt.smoothscroll = true

-- sync with system keyboard
vim.opt.clipboard = "unnamedplus"

-- persistent undo
-- create an undo directory to save history across restarts
vim.opt.undofile = true

-- what's this do?
-- less notifications, disable intro default screen, removes some distracting completion popup thing ig
vim.opt.shortmess:append({ W = true, I = true, c = true })

-- clear search highlights with esc
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- highlight when yanking
vim.api.nvim_create_autocmd("TextYankPost", {
    desc = "Highlight when yanking (copying) text",
    group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
    callback = function()
        vim.highlight.on_yank({
            higroup = "IncSearch",
            timeout = 150,
        })
    end,
})

-- jj to enter normal mode (from insert mode)
vim.keymap.set("i", "jj", "<Esc>")

-- move between splits with ctrl + hjkl
-- with a 'smart' brein
local function smart_navigate(direction)
    local curr_win = vim.api.nvim_get_current_win()
    local prev_win = vim.fn.win_getid(vim.fn.winnr("#"))

    if prev_win and prev_win ~= 0 and vim.api.nvim_win_is_valid(prev_win) then
        -- 1. Get exact boundaries of current window
        local curr_pos = vim.api.nvim_win_get_position(curr_win)
        local curr_top, curr_left = curr_pos[1], curr_pos[2]
        local curr_bottom = curr_top + vim.api.nvim_win_get_height(curr_win)
        local curr_right = curr_left + vim.api.nvim_win_get_width(curr_win)

        -- 2. Get exact boundaries of previous window
        local prev_pos = vim.api.nvim_win_get_position(prev_win)
        local prev_top, prev_left = prev_pos[1], prev_pos[2]
        local prev_bottom = prev_top + vim.api.nvim_win_get_height(prev_win)
        local prev_right = prev_left + vim.api.nvim_win_get_width(prev_win)

        local is_in_direction = false

        -- 3. Check for geometric overlap in the chosen direction
        if direction == "k" then -- Up: Prev bottom edge is above us AND shares horizontal space
            is_in_direction = (prev_bottom <= curr_top) and (prev_left < curr_right and prev_right > curr_left)
        elseif direction == "j" then -- Down: Prev top edge is below us AND shares horizontal space
            is_in_direction = (prev_top >= curr_bottom) and (prev_left < curr_right and prev_right > curr_left)
        elseif direction == "h" then -- Left: Prev right edge is to our left AND shares vertical space
            is_in_direction = (prev_right <= curr_left) and (prev_top < curr_bottom and prev_bottom > curr_top)
        elseif direction == "l" then -- Right: Prev left edge is to our right AND shares vertical space
            is_in_direction = (prev_left >= curr_right) and (prev_top < curr_bottom and prev_bottom > curr_top)
        end

        -- 4. If the previous window genuinely lives in that direction, snap back to it
        if is_in_direction then
            vim.api.nvim_set_current_win(prev_win)
            return
        end
    end

    -- 5. Fallback: If no history exists there, move normally
    vim.cmd("wincmd " .. direction)
end

-- moving between splits
vim.keymap.set("n", "<C-k>", function()
    smart_navigate("k")
end, { desc = "Window: Smart move up" })
vim.keymap.set("n", "<C-j>", function()
    smart_navigate("j")
end, { desc = "Window: Smart move down" })
vim.keymap.set("n", "<C-h>", function()
    smart_navigate("h")
end, { desc = "Window: Smart move left" })
vim.keymap.set("n", "<C-l>", function()
    smart_navigate("l")
end, { desc = "Window: Smart move right" })

-- vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Move to left split" })
-- vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Move to below split" })
-- vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Move to above split" })
-- vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Move to right split" })

-- highlight working line
vim.opt.cursorline = true

vim.startofline = false

vim.opt.virtualedit = "block"

-- confirm save before exiting
vim.opt.confirm = true

-- single global statusline at the bottom
vim.opt.laststatus = 3 -- Enables a single, global statusline at the bottom

-- have nvim respect your indentation stuff whatnot instead of overriding for markdown styling
vim.g.markdown_recommended_style = 0
