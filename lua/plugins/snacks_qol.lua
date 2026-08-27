-- 1. Setup Options
require("snacks").setup({
    bigfile = { enabled = true },
    dashboard = {
        enabled = true,

        -- 󰜘 1. The official way to define custom ASCII art
        -- don't touch!
        preset = {
            header = [[
                   +÷±±±÷÷××××                    
               ×÷÷÷÷=--÷±÷÷÷≈+÷±>>××±÷±              
             +≈++><+-<+÷×-÷÷÷÷±÷÷÷÷÷÷÷÷÷÷           
           +<×>>÷!>×-÷×÷±±-++>÷÷±>+÷××÷÷÷××÷÷        
           !!!>>×>>-++++>->>!=+-+÷=±÷÷÷÷×××÷+>>         
       ><>><>>+--=××=>>==+>;!+=+>>++±÷÷÷÷÷÷÷×=×÷     
     <<<+>+>!!>×÷==+=×÷÷i!=+=-×≈<+>---÷÷±÷÷=-×÷>>-   
     !!llI.>++!++++;!×=±I+++++×≠÷÷=I!<<×>±÷,l+<×>÷×  
     !-.i<>l>>>>-<+-××-×<,!>>;I:!l.iIl<>>l!±÷±:il×<÷ 
    !I>:ill<l<l :;.. i<!,.I!!l!ii:   !IIli:l!<=!>>++ 
   !II.;..iI!..  ,,. .  ;..,., :.,.    ..   .I!<>->  
   Il;I ,.:,:,.  .,. ..   .      . .,          I=   
    ;,,...; ;;,. ...,,        :. ...... ..   Ii     
         ;I,.;,;:....,..    . .;i:  ;;:  I,i       
                        !;' ;!                        
                        !;  ;!                        
                        !;  ;!                        
                        !;  ;l                        
                                                 
                          N E O V I M                         
            ]],
        },

        sections = {
            -- 󰜘 2. Call the native header section and apply your cool Cyan color!
            { section = "header", hl = "DiagnosticHint", padding = 1 },
            { section = "keys", gap = 1, padding = 1 },
            { icon = " ", title = "Recent Files", section = "recent_files", indent = 2, padding = 1 },
            { icon = " ", title = "Projects", section = "projects", indent = 2, padding = 1 },
        },
    },
    explorer = { enabled = true },
    indent = { enabled = true },
    input = { enabled = true },
    notifier = {
        enabled = true,
        timeout = 3000,
    },
    picker = { enabled = true },
    quickfile = { enabled = true },
    scope = { enabled = true },
    scroll = { enabled = true },
    statuscolumn = { enabled = true },
    words = { enabled = true },
    styles = {
        notification = {
            -- wo = { wrap = true } -- Wrap notifications
        },
    },
    scroll = { enabled = true },
    indent = { enabled = true },

    -- enable terminal
    terminal = {
        enabled = true,
    },

    -- disable snack's git stuff
    git = { enabled = false },
    gitbrowse = { enabled = false },
    lazygit = { enabled = false },
})

-- 2. Keymaps
local map = vim.keymap.set

-- Top Pickers & Explorer
map("n", "<leader><space>", function()
    Snacks.picker.smart()
end, { desc = "Smart Find Files" })
map("n", "<leader>,", function()
    Snacks.picker.buffers()
end, { desc = "Buffers" })
map("n", "<leader>/", function()
    Snacks.picker.grep()
end, { desc = "Grep" })
map("n", "<leader>:", function()
    Snacks.picker.command_history()
end, { desc = "Command History" })
map("n", "<leader>n", function()
    Snacks.picker.notifications()
end, { desc = "Notification History" })
map("n", "<leader>e", function()
    Snacks.explorer()
end, { desc = "File Explorer" })

-- Find
map("n", "<leader>fb", function()
    Snacks.picker.buffers()
end, { desc = "Buffers" })
map("n", "<leader>fc", function()
    Snacks.picker.files({ cwd = vim.fn.stdpath("config") })
end, { desc = "Find Config File" })
map("n", "<leader>ff", function()
    Snacks.picker.files()
end, { desc = "Find Files" })
map("n", "<leader>fg", function()
    Snacks.picker.git_files()
end, { desc = "Find Git Files" })
map("n", "<leader>fp", function()
    Snacks.picker.projects()
end, { desc = "Projects" })
map("n", "<leader>fr", function()
    Snacks.picker.recent()
end, { desc = "Recent" })

-- Search/Grep
map("n", "<leader>sb", function()
    Snacks.picker.lines()
end, { desc = "Buffer Lines" })
map("n", "<leader>sB", function()
    Snacks.picker.grep_buffers()
end, { desc = "Grep Open Buffers" })
map("n", "<leader>sg", function()
    Snacks.picker.grep()
end, { desc = "Grep" })
map({ "n", "x" }, "<leader>sw", function()
    Snacks.picker.grep_word()
end, { desc = "Visual selection or word" })
map("n", '<leader>s"', function()
    Snacks.picker.registers()
end, { desc = "Registers" })
map("n", "<leader>s/", function()
    Snacks.picker.search_history()
end, { desc = "Search History" })
map("n", "<leader>sa", function()
    Snacks.picker.autocmds()
end, { desc = "Autocmds" })
map("n", "<leader>sc", function()
    Snacks.picker.command_history()
end, { desc = "Command History" })
map("n", "<leader>sC", function()
    Snacks.picker.commands()
end, { desc = "Commands" })
map("n", "<leader>sd", function()
    Snacks.picker.diagnostics()
end, { desc = "Diagnostics" })
map("n", "<leader>sD", function()
    Snacks.picker.diagnostics_buffer()
end, { desc = "Buffer Diagnostics" })
map("n", "<leader>sh", function()
    Snacks.picker.help()
end, { desc = "Help Pages" })
map("n", "<leader>sH", function()
    Snacks.picker.highlights()
end, { desc = "Highlights" })
map("n", "<leader>si", function()
    Snacks.picker.icons()
end, { desc = "Icons" })
map("n", "<leader>sj", function()
    Snacks.picker.jumps()
end, { desc = "Jumps" })
map("n", "<leader>sk", function()
    Snacks.picker.keymaps()
end, { desc = "Keymaps" })
map("n", "<leader>sl", function()
    Snacks.picker.loclist()
end, { desc = "Location List" })
map("n", "<leader>sm", function()
    Snacks.picker.marks()
end, { desc = "Marks" })
map("n", "<leader>sM", function()
    Snacks.picker.man()
end, { desc = "Man Pages" })
map("n", "<leader>sp", function()
    Snacks.picker.lazy()
end, { desc = "Search for Plugin Spec" })
map("n", "<leader>sq", function()
    Snacks.picker.qflist()
end, { desc = "Quickfix List" })
map("n", "<leader>sR", function()
    Snacks.picker.resume()
end, { desc = "Resume" })
map("n", "<leader>su", function()
    Snacks.picker.undo()
end, { desc = "Undo History" })
map("n", "<leader>uC", function()
    Snacks.picker.colorschemes()
end, { desc = "Colorschemes" })

-- LSP
map("n", "gd", function()
    Snacks.picker.lsp_definitions()
end, { desc = "Goto Definition" })
map("n", "gD", function()
    Snacks.picker.lsp_declarations()
end, { desc = "Goto Declaration" })
map("n", "gr", function()
    Snacks.picker.lsp_references()
end, { nowait = true, desc = "References" })
map("n", "gI", function()
    Snacks.picker.lsp_implementations()
end, { desc = "Goto Implementation" })
map("n", "gy", function()
    Snacks.picker.lsp_type_definitions()
end, { desc = "Goto T[y]pe Definition" })
map("n", "gai", function()
    Snacks.picker.lsp_incoming_calls()
end, { desc = "C[a]lls Incoming" })
map("n", "gao", function()
    Snacks.picker.lsp_outgoing_calls()
end, { desc = "C[a]lls Outgoing" })
map("n", "<leader>ss", function()
    Snacks.picker.lsp_symbols()
end, { desc = "LSP Symbols" })
map("n", "<leader>sS", function()
    Snacks.picker.lsp_workspace_symbols()
end, { desc = "LSP Workspace Symbols" })

-- Other
map("n", "<leader>z", function()
    Snacks.zen()
end, { desc = "Toggle Zen Mode" })
map("n", "<leader>Z", function()
    Snacks.zen.zoom()
end, { desc = "Toggle Zoom" })
-- map("n", "<leader>.", function()
--     Snacks.scratch()
-- end, { desc = "Toggle Scratch Buffer" })
map("n", "<leader>bd", function()
    Snacks.bufdelete()
end, { desc = "Delete Buffer" })
map("n", "<leader>cR", function()
    Snacks.rename.rename_file()
end, { desc = "Rename File" })
map("n", "<leader>un", function()
    Snacks.notifier.hide()
end, { desc = "Dismiss All Notifications" })
map({ "n", "t" }, "]]", function()
    Snacks.words.jump(vim.v.count1)
end, { desc = "Next Reference" })
map({ "n", "t" }, "[[", function()
    Snacks.words.jump(-vim.v.count1)
end, { desc = "Prev Reference" })

-- News Window
map("n", "<leader>N", function()
    Snacks.win({
        file = vim.api.nvim_get_runtime_file("doc/news.txt", false)[1],
        width = 0.6,
        height = 0.6,
        wo = {
            spell = false,
            wrap = false,
            signcolumn = "yes",
            statuscolumn = " ",
            conceallevel = 3,
        },
    })
end, { desc = "Neovim News" })

-- 3. Initializer Logic
_G.dd = function(...)
    Snacks.debug.inspect(...)
end
_G.bt = function()
    Snacks.debug.backtrace()
end

-- Override print
if vim.fn.has("nvim-0.11") == 1 then
    vim._print = function(_, ...)
        dd(...)
    end
else
    vim.print = _G.dd
end

-- Toggle Mappings
-- Toggle the Snacks Terminal at the bottom
Snacks.toggle.terminal("terminal", { name = "Terminal" }):map("<leader>t")
Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>us")
Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>uL")
Snacks.toggle.diagnostics():map("<leader>ud")
Snacks.toggle.line_number():map("<leader>ul")
Snacks.toggle
    .option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 })
    :map("<leader>uc")
Snacks.toggle.treesitter():map("<leader>uT")
Snacks.toggle.option("background", { off = "light", on = "dark", name = "Dark Background" }):map("<leader>ub")
Snacks.toggle.inlay_hints():map("<leader>uh")
Snacks.toggle.indent():map("<leader>ug")
Snacks.toggle.dim():map("<leader>uD")
