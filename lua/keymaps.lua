-- Set space as leader key (usually at the very top of init.lua or common.lua)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- remap j and k to keep cursor centred
-- vim.keymap.set("n", "j", "jzz")
-- vim.keymap.set("n", "k", "kzz")

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

-- resize panes
local function smart_resize(amount)
    local current_win = vim.api.nvim_get_current_win()

    -- Helper to find whether the current window is nested in a row or a column split
    local function find_parent_type(layout, parent_type)
        if layout[1] == "leaf" then
            return layout[2] == current_win and parent_type or nil
        end
        for _, child in ipairs(layout[2]) do
            local res = find_parent_type(child, layout[1])
            if res then
                return res
            end
        end
        return nil
    end

    local split_type = find_parent_type(vim.fn.winlayout(), nil)

    if split_type == "row" then
        vim.cmd("vertical resize " .. amount) -- Side-by-side splits -> adjust width
    elseif split_type == "col" then
        vim.cmd("resize " .. amount) -- Top-and-bottom splits -> adjust height
    else
        -- Fallback for complex grid layouts: adjust both
        vim.cmd("vertical resize " .. amount)
        vim.cmd("resize " .. amount)
    end
end
-- Keymaps using the smart function
vim.keymap.set("n", "<C-S-->", function()
    smart_resize("-5")
end, { silent = true, desc = "Smart shrink pane" })
vim.keymap.set("n", "<C-S-=>", function()
    smart_resize("+5")
end, { silent = true, desc = "Smart grow pane" })

-- panes divider highlight
-- 1. Define a function to set the divider color
local function apply_divider_color()
    -- Swap "#E0AF68" with your theme's specific yellow hex code if you prefer
    -- local divider_color = "#FFC777"
    local divider_color = "#82AAFF"

    -- Modern Neovim (0.7+) window separator
    vim.api.nvim_set_hl(0, "WinSeparator", { fg = divider_color, bg = "none" })

    -- Older Neovim compatibility (just in case)
    vim.api.nvim_set_hl(0, "VertSplit", { fg = divider_color, bg = "none" })
end
-- 2. Run it immediately right now on startup
apply_divider_color()
-- 3. Run it again automatically if the colorscheme is reloaded or changed
vim.api.nvim_create_autocmd("ColorScheme", {
    callback = apply_divider_color,
})

-- rename
-- Rename variable semantically using LSP
vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { desc = "LSP Rename variable" })

-- map Shift + Ctrl + (j, k) to scroll more
vim.keymap.set("n", "<S-C-j>", "<C-d>zz")
vim.keymap.set("n", "<S-C-k>", "<C-u>zz")

-- save file and more
vim.keymap.set("n", "<leader>w", ":w<CR>", { desc = "Save file" })

-- custom file name bar thing autocmd
_G.custom_winbar = function()
    -- 1. Ignore the explorer, terminal, and other special floating/popup panels
    local buftype = vim.bo.buftype
    local filetype = vim.bo.filetype
    if buftype == "nofile" or buftype == "terminal" or filetype == "snacks_explorer" or filetype == "snacks_picker" then
        return "" -- Keeps your explorer sidebar completely clean
    end

    -- 2. Get the full absolute path of the buffer
    local full_path = vim.api.nvim_buf_get_name(0)

    -- 3. 🎯 Identify and rename any Snacks Scratch Buffers
    if full_path:match("scratch/") then
        -- Change "Scratch Pad" to whatever you prefer to call it!
        return "%#DiagnosticWarn# 󱓧 Scratch Pad %="
    end

    -- 4. Standard files: Get the path relative to your current project root directory
    local relative_path = vim.fn.fnamemodify(full_path, ":.")
    if relative_path == "" then
        return ""
    end

    -- show harpoon_indicator
    local harpoon_indicator = ""
    local h_index = _G.get_harpoon_index()
    if h_index then
        harpoon_indicator = "󰈺↽ #" .. h_index .. " | "
    end
    -- 5. Return your clean yellow layout
    return "%#DiagnosticWarn#  " .. harpoon_indicator .. relative_path .. " %="
end

-- Ensure Neovim's global winbar is linked to our updated function
vim.opt.winbar = "%{%v:lua.custom_winbar()%}"

-- smart quit: close current file buffer without breaking split layouts
vim.keymap.set("n", "<leader>q", function()
    -- Get a list of all listed, valid file buffers
    local buffers = vim.fn.getbufinfo({ buflisted = 1 })

    if #buffers > 1 then
        -- If multiple files are open in the top bar, delete the current one cleanly
        vim.cmd("bwipeout")
    else
        -- If it's the absolute last file open, quit Neovim completely
        vim.cmd("q")
    end
end, { silent = true, desc = "Buffers: Smart close file or quit" })

vim.keymap.set("n", "<leader>Q", ":qa<CR>", { desc = "Quit all" })

-- split
vim.keymap.set("n", "<leader>pd", ":split<CR>", { desc = "Pane: Split Horizontal" })
vim.keymap.set("n", "<leader>pv", ":vsplit<CR>", { desc = "Pane: Split Vertical" })
-- Toggle a scratchpad split pane on the right side
vim.keymap.set("n", "<leader>ps", function()
    Snacks.scratch({
        ft = "markdown",
        name = "Scratch Pad",
        icon = "󱓧",
        win = {
            style = "split", -- Force it to be an editor panel layout instead of a float
            position = "right", -- Snap it cleanly to the right side
            width = 45, -- Set panel column width
            wo = {
                number = false, -- No line numbers (gives it that clean panel style)
                relativenumber = false, -- No relative numbers
                signcolumn = "no", -- Hides linter/LSP yellow warning marks on the left margin
                statuscolumn = "", -- Strips away gutter clutter
            },
        },
    })
end, { desc = "Pane: Scratch Pad buffer on the right" })
vim.keymap.set("n", "<leader>pf", function()
    Snacks.scratch({
        ft = "markdown",
        name = "Scratch Pad",
        icon = "󱓧",
        win = {
            style = "float", -- 👈 Spawns as an independent centered floating card
            width = 0.6, -- Spans 60% of screen width
            height = 0.6, -- Spans 60% of screen height
            border = "rounded",
        },
    })
end, { desc = "Pane: Floating Scratch Pad buffer" })
vim.keymap.set("n", "<leader>ph", function()
    Snacks.scratch.select()
end, { desc = "Pane: History, find old Scratch Pad buffers" })

-- Obsidian! :)
vim.keymap.set("n", "<leader>oo", ":Obsidian<CR>", { desc = "Obsidian commands" })
vim.keymap.set("n", "<leader>oO", ":Obsidian open<CR>", { desc = "Obsidian: open in Obsidian" })
vim.keymap.set("n", "<leader>os", ":Obsidian quick_switch<CR>", { desc = "Obsidian: search" })
vim.keymap.set("n", "<leader>od", ":Obsidian today<CR>", { desc = "Obsidian: daily note" })
vim.keymap.set("n", "<leader>on", ":Obsidian new_from_template<CR>", { desc = "Obsidian: new note" })
vim.keymap.set("n", "<leader>or", ":Obsidian rename<CR>", { desc = "Obsidian: rename note" })
vim.keymap.set("n", "<leader>ot", ":Obsidian template<CR>", { desc = "Obsidian: note templates" })
vim.keymap.set("n", "<leader>oT", ":Obsidian toc<CR>", { desc = "Obsidian: note Table of Contents" })
vim.keymap.set("n", "gf", ":Obsidian follow_link<CR>", { desc = "Obsidian follow_link" })
vim.keymap.set("n", "gr", ":Obsidian backlinks<CR>", { desc = "Obsidian backlinks" })
-- Toggle conceal level between 0 and 2
vim.keymap.set("n", "<leader>Tc", function()
    if vim.opt_local.conceallevel:get() >= 1 then
        vim.opt_local.conceallevel = 0
    else
        vim.opt_local.conceallevel = 2
    end
end, { desc = "Toggle Conceal" })

-- vim.keymap.set("n", "<leader>wq", ":wqa<CR>", { desc = " Write and quit current window" })
--
-- vim.keymap.set("n", "<leader>wQ", ":wqa<CR>", { desc = " Write and quit all" })

-- toggle nvim tree
vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>", { silent = true, desc = "Toggle NvimTree" })

-- select all
-- vim.keymap.set({ "n", "v", "i" }, "<leader>a", "ggVG", { desc = "Select all" })

-- toggle terminal
-- use the terminal from Snacks
vim.keymap.set({ "n", "t" }, "<leader>t", function()
    Snacks.terminal.toggle()
end, { silent = true, desc = "Toggle Terminal" })

-- reload nvim
vim.keymap.set("n", "<leader>R", ":source $MYVIMRC<CR>", { silent = true, desc = "Toggle NvimTree" })

-- hover documentation (shift+k)
-- Smart Hover: Shows Git/LSP errors if they exist, otherwise shows code documentation (Toggleable)
vim.keymap.set("n", "K", function()
    -- Check if a floating window is already open on the screen
    for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
        local config = vim.api.nvim_win_get_config(win)
        if config.relative and config.relative ~= "" then
            -- If a floating box is already open, close it instantly!
            vim.api.nvim_win_close(win, true)
            return
        end
    end

    -- 1. Check if there are any diagnostic errors/warnings on the current line
    local diagnostics = vim.diagnostic.get(0, { lnum = vim.api.nvim_win_get_cursor(0)[1] - 1 })

    if not vim.tbl_isempty(diagnostics) then
        -- If an error exists under the cursor, show the nice VS Code error box
        vim.diagnostic.open_float({
            scope = "cursor",
            border = "rounded",
            focusable = false,
        })
    else
        -- If the line is clean, show the standard LSP code documentation window
        local lsp_has_hover = false
        for _, client in ipairs(vim.lsp.get_clients({ bufnr = 0 })) do
            if client.supports_method("textDocument/hover") then
                lsp_has_hover = true
                break
            end
        end

        if lsp_has_hover then
            vim.lsp.buf.hover({ border = "rounded" })
        else
            vim.notify(" 󰜘  No documentation or errors found under cursor", vim.log.levels.WARN)
        end
    end
end, { desc = "LSP: Smart Hover (Docs or Errors)" })

-- tab navigation: Ctrl + Shift + H / L
vim.keymap.set("n", "<C-S-l>", ":bnext<CR>", { silent = true, desc = "Buffers: Go to next file" })
vim.keymap.set("n", "<C-S-h>", ":bprevious<CR>", { silent = true, desc = "Buffers: Go to prev file" })

-----
-- More!
-- quick git push
vim.keymap.set("n", "<leader>gP", function()
    -- 1. Prompt the user for a commit message
    vim.ui.input({ prompt = "󰜘 Commit message: " }, function(msg)
        -- If you hit escape or leave it blank, cancel the whole thing
        if not msg or msg == "" then
            vim.notify("Push aborted: No commit message provided.", vim.log.levels.WARN)
            return
        end

        -- 2. Run the Fugitive commands sequentially
        vim.cmd("Git add .")
        vim.cmd('Git commit -m "' .. msg .. '"')
        vim.cmd("Git push")

        -- 3. Let you know it worked!
        vim.notify("󰗡  Code Pushed: " .. msg, vim.log.levels.INFO)
    end)
end, { desc = "Git: Add All, Commit, and Push" })

-- quick git commit
vim.keymap.set("n", "<leader>gC", function()
    -- 1. Prompt the user for a commit message
    vim.ui.input({ prompt = "󰜘 Commit message: " }, function(msg)
        -- If you hit escape or leave it blank, cancel the whole thing
        if not msg or msg == "" then
            vim.notify("Push aborted: No commit message provided.", vim.log.levels.WARN)
            return
        end

        -- 2. Run the Fugitive commands sequentially
        vim.cmd("Git add .")
        vim.cmd('Git commit -m "' .. msg .. '"')

        -- 3. Let you know it worked!
        vim.notify("󰗡  Code Committed: " .. msg, vim.log.levels.INFO)
    end)
end, { desc = "Git: Add All, and Commit" })

-- open Git (fugitive)
vim.keymap.set("n", "<leader>G", ":Git", { silent = true, desc = "Git: Enter command" })

vim.keymap.set("n", "<leader>gs", ":Git status<CR>", { silent = true, desc = "Git: Status" })

-- 1. Git Add (Interactive)
vim.keymap.set("n", "<leader>ga", function()
    vim.ui.input({ prompt = ' 󰜘  Git add (e.g. ".", "file.lua"): ', default = "." }, function(input)
        if not input or input == "" then
            vim.notify("Git add canceled.", vim.log.levels.WARN)
            return
        end
        vim.cmd("Git add " .. input)
        vim.notify(" 󰗡  Staged: " .. input, vim.log.levels.INFO)
    end)
end, { desc = "Git: Add files" })

-- 2. Git Commit (Interactive)
vim.keymap.set("n", "<leader>gc", function()
    vim.ui.input({ prompt = " 󰗡  Commit message: " }, function(msg)
        if not msg or msg == "" then
            vim.notify("Commit canceled: Empty message.", vim.log.levels.WARN)
            return
        end
        vim.cmd('Git commit -m "' .. msg .. '"')
        vim.notify(" 󰗡  Committed: " .. msg, vim.log.levels.INFO)
    end)
end, { desc = "Git: Commit staged changes" })

-- Gdiffsplit!
-- Toggle Fugitive visual diff split
-- Smart Toggle for Git Diff Split
vim.keymap.set("n", "<leader>gd", function()
    -- Check how many windows are currently open in the active tab
    local wins = vim.api.nvim_tabpage_list_wins(0)

    if #wins > 1 then
        -- If more than 1 window is open, collapse back to normal view
        vim.cmd("only")
        vim.notify(" 󰜘  Exit Diff View", vim.log.levels.INFO)
    else
        -- Check if the current file has any active git conflict markers
        local has_conflict = vim.fn.search([[^\(<<<<<<<\|=======>>>>>\)]], "nw") > 0

        if has_conflict then
            -- 3-Pane Layout: Merge conflict detected!
            vim.cmd("Gdiffsplit!")
            vim.notify(" 󰜘  Conflict Detected: 3-Pane Merge Layout Open", vim.log.levels.WARN)
        else
            -- 2-Pane Layout: Just normal daily code reviewing.
            vim.cmd("vert Gdiffsplit! HEAD")
            if #vim.api.nvim_tabpage_list_wins(0) > 2 then
                vim.cmd("wincmd h | close") -- Safely snaps it down to a 2-pane split
            end
        end
    end
end, { silent = true, desc = "Git: Toggle Smart Diff Layout" })

-- Dynamic Visual Buttons for Diff Mode (Super Safe Edition)

_G.diff_action_get = function()
    vim.cmd("diffget")
end
_G.diff_action_put = function()
    vim.cmd("diffput")
end
_G.diff_action_next = function()
    vim.cmd("normal! ]c")
end
_G.diff_action_prev = function()
    vim.cmd("normal! [c")
end

vim.api.nvim_create_autocmd({ "BufWinEnter", "WinEnter", "CursorMoved" }, {
    pattern = "*",
    callback = function()
        if vim.wo.diff then
            -- Find out if the cursor is in the left window or right window
            local current_win = vim.api.nvim_get_current_win()
            local wins = vim.api.nvim_tabpage_list_wins(0)

            local left_win = wins[1]
            local right_win = wins[2]

            local get_label = ""
            local put_label = ""

            if current_win == right_win then
                -- Cursor is on the right side (Normal Coding Workspace)
                get_label = "󰜘 [ RESET: ONLY LEFT ]"
                put_label = "󰗡 [ STAGE: ONLY RIGHT ]"
            else
                -- Cursor is on the left side (The Git Vault)
                get_label = "󰜘 [ STAGE: ONLY LEFT ]"
                put_label = "󰀼 [ DANGER: ONLY RIGHT ]"
            end

            vim.wo.winbar = table.concat({
                "  ",
                "%@v:lua.diff_action_get@" .. get_label .. "%X",
                "   ",
                "%@v:lua.diff_action_put@" .. put_label .. "%X",
                "   │   ",
                "%@v:lua.diff_action_prev@ [ Prev ]%X",
                "   ",
                "%@v:lua.diff_action_next@ [ Next ]%X",
            })
        else
            vim.wo.winbar = nil
        end
    end,
})

-- navigate between hunks
vim.keymap.set("n", "]c", function()
    require("gitsigns").next_hunk()
end, { desc = "Next Git Change" })
vim.keymap.set("n", "[c", function()
    require("gitsigns").prev_hunk()
end, { desc = "Prev Git Change" })
