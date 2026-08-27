-- ~/.config/nvim/lua/red-checker/init.lua

local M = {}

-- Allow optional user configuration (just like real plugins!)
M.config = {
    ghostty_path = vim.fn.expand("~/.config/ghostty/themes/red-checker"),
}

-- The standard setup function
function M.setup(opts)
    M.config = vim.tbl_deep_extend("force", M.config, opts or {})
end

-- The main execution engine
function M.load()
    -- 1. Reset Neovim's highlight state completely
    vim.cmd("hi clear")
    if vim.fn.exists("syntax_on") == 1 then
        vim.cmd("syntax reset")
    end
    vim.g.colors_name = "red-checker"

    -- 2. Ensure cursor reverts to terminal default to stop bleeding into TokyoNight
    vim.cmd("hi clear Cursor")

    -- 3. Parse the Ghostty Configuration
    local file = io.open(M.config.ghostty_path, "r")
    local c = {
        bg = "#1e1214",
        foreground = "#f5ebd6",
        ["cursor-color"] = "#e05c75",
        ["selection-background"] = "#42252a",
        p0 = "#1e1214",
        p1 = "#e05c75",
        p2 = "#b8a98f",
        p3 = "#f7d399",
        p4 = "#c96984",
        p5 = "#df879f",
        p6 = "#e5b4b1",
        p7 = "#f5ebd6",
    }

    if file then
        for line in file:lines() do
            if not line:match("^%s*#") and not line:match("^%s*$") then
                local key, val = line:match("([^%s=]+)%s*=%s*[\"']?([^\"'\n]+)[\"']?")
                if key and val then
                    val = val:gsub("%s+", ""):gsub("^#", "")
                    if key == "palette" then
                        local p_idx, p_hex = val:match("([^=]+)=#?([^=]+)")
                        if p_idx and p_hex then
                            c["p" .. p_idx] = "#" .. p_hex
                        end
                    else
                        c[key] = "#" .. val
                    end
                end
            end
        end
        file:close()
    end

    -- 4. The Complete UI Matrix
    local highlights = {
        -- Editor Core
        Normal = { fg = c.foreground, bg = "NONE" },
        NormalNC = { fg = c.foreground, bg = "NONE" },
        SignColumn = { bg = "NONE" },
        FoldColumn = { fg = c.p2, bg = "NONE" },
        Visual = { bg = c["selection-background"] },
        LineNr = { fg = c.p2 },
        CursorLine = { bg = c["selection-background"] },
        CursorLineNr = { fg = c.p3, bold = true },
        MatchParen = { fg = c.p3, bg = c["selection-background"], bold = true },
        Search = { fg = c.bg, bg = c.p3 },
        IncSearch = { fg = c.bg, bg = c.p1 },

        -- Syntax Hierarchy
        Comment = { fg = c.p2, italic = true },
        Constant = { fg = c.p5 },
        String = { fg = c.p6 },
        Number = { fg = c.p5 },
        Boolean = { fg = c.p5 },
        Identifier = { fg = c.foreground },
        Function = { fg = c.p1, bold = true },
        Statement = { fg = c.p4 },
        Conditional = { fg = c.p4, bold = true },
        Repeat = { fg = c.p4 },
        Keyword = { fg = c.p4, bold = true },
        Operator = { fg = c.p1 },
        Delimiter = { fg = c.p5 },
        Punctuation = { fg = c.p3 },
        Type = { fg = c.p3 },
        Special = { fg = c.p6 },
        Todo = { fg = c.bg, bg = c.p3, bold = true },
        Error = { fg = c.p1, bold = true },

        -- Splits and Floats
        VertSplit = { fg = c["selection-background"], bg = "NONE" },
        WinSeparator = { fg = c["selection-background"], bg = "NONE" },
        Pmenu = { fg = c.foreground, bg = c["selection-background"] },
        PmenuSel = { fg = c.bg, bg = c.p3, bold = true },
        NormalFloat = { fg = c.foreground, bg = "NONE" },
        FloatBorder = { fg = c.p4, bg = "NONE" },

        -- Diagnostics
        DiagnosticError = { fg = c.p1 },
        DiagnosticWarn = { fg = c.p3 },
        DiagnosticInfo = { fg = c.p6 },
        DiagnosticHint = { fg = c.p2 },

        -- Neo-Tree
        NeoTreeNormal = { fg = c.foreground, bg = "NONE" },
        NeoTreeNormalNC = { fg = c.foreground, bg = "NONE" },
        NeoTreeWinSeparator = { fg = c["selection-background"], bg = "NONE" },
        NeoTreeEndOfBuffer = { fg = c.p0, bg = "NONE" },
        NeoTreeDirectoryIcon = { fg = c.p4 },
        NeoTreeDirectoryName = { fg = c.foreground, bold = true },
        NeoTreeFileName = { fg = c.foreground },
        NeoTreeRootName = { fg = c.p1, bold = true },
        NeoTreeCursorLine = { bg = c["selection-background"] },

        -- Lualine fallbacks
        StatusLine = { fg = c.foreground, bg = "NONE" },
        StatusLineNC = { fg = c.p2, bg = "NONE" },
    }

    for group, settings in pairs(highlights) do
        vim.api.nvim_set_hl(0, group, settings)
    end
end

return M
