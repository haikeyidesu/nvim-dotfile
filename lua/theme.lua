require("colorizer").setup({
    filetypes = { "*" },
    user_default_options = {
        RGB = true, -- Highlight #RGB hex codes
        RRGGBB = true, -- Highlight #RRGGBB hex codes
        names = false, -- CRITICAL FIX: Turn off plain word highlighting!
        RRGGBBAA = true,
        mode = "background", -- Keep painting hex code backgrounds
    },
})

require("rose-pine").setup({
    variant = "moon",
    styles = {
        transparency = true,
    },
})

require("kanagawa").setup({
    theme = "dragon", -- Load the warm, dark variant
    background = {
        dark = "dragon",
    },
    transparent = true,
})

require("catppuccin").setup({
    flavour = "mocha", -- Options: latte, frappe, macchiato, mocha
    transparent_background = true, -- Wipes out Catppuccin's native bg
    styles = {
        conditionals = { "bold" },
    },
})

require("red-checker").setup({
    -- If you ever move your ghostty files, you can update the path here!
    ghostty_path = vim.fn.expand("~/.config/ghostty/themes/red-checker"),
})

require("tokyonight").setup({
    transparent = true, -- Enables transparency for the main editor window
    styles = {
        sidebars = "transparent", -- Makes tools like NvimTree or neo-tree transparent
        floats = "transparent", -- Makes floating windows (like hover docs) transparent
    },
})

-- work and casual theme
work_theme = "tokyonight"
casual_theme = "rose-pine"

-- apply theme
local function ApplyTheme(theme_name)
    if string.find(theme_name, "tokyonight") then
        vim.cmd("hi clear Cursor")
        vim.cmd(("colorscheme %s"):format(work_theme))
        pcall(function()
            require("lualine").setup({ options = { theme = work_theme } })
        end)
    else
        vim.o.background = "dark"
        vim.cmd(("colorscheme %s"):format(casual_theme))
        pcall(function()
            require("lualine").setup({ options = { theme = "auto" } })
        end)
    end

    -- Safe, native requests to the visual plugins (No cache-nuking or reboots)
    vim.schedule(function()
        pcall(function()
            vim.cmd("ColorizerReloadAllBuffers")
        end)
        pcall(function()
            require("todo-comments.highlight").create()
        end)
    end)
end

-- Toggle Theme
-- actually it's refresh theme or smth ah
_G.ToggleTheme = function()
    local current_theme = vim.g.colors_name or ""
    local state_file = os.getenv("HOME") .. "/.config/nvim/.theme_state"
    local file = io.open(state_file, "r")
    -- local target_theme = "work" -- Fallback default

    if file then
        target_theme = file:read("*a"):gsub("%s+", "")
        file:close()
    end
    if target_theme == "work" then
        target_theme = work_theme
    end
    -- Write the new theme state to the hidden file so SyncTheme knows what to do!
    local state_file = os.getenv("HOME") .. "/.config/nvim/.theme_state"
    local file = io.open(state_file, "w")
    if file then
        file:write(target_theme)
        file:close()
    end

    ApplyTheme(target_theme)
    print("Theme: " .. (target_theme == "casual" and "Casual" or "Work"))
end

-- Sync Theme
-- Sync Theme (Automated Signal State Trigger with Live Cache Flush)
_G.SyncTheme = function()
    local state_file = os.getenv("HOME") .. "/.config/nvim/.theme_state"
    local file = io.open(state_file, "r")
    -- local target_theme = "work" -- Fallback default

    if file then
        target_theme = file:read("*a"):gsub("%s+", "")
        file:close()
    end

    -- Mirroring the exact commands from ToggleTheme that you know work smoothly:
    if target_theme == "casual" or target_theme == casual_theme then
        vim.o.background = "dark"
        vim.cmd(("colorscheme %s"):format(casual_theme))
        pcall(function()
            require("lualine").setup({ options = { theme = "auto" } })
        end)
    else
        vim.cmd("hi clear Cursor")
        vim.cmd(("colorscheme %s"):format(work_theme))
        pcall(function()
            require("lualine").setup({ options = { theme = work_theme } })
        end)
    end

    -- Force instant visual reload
    vim.schedule(function()
        pcall(function()
            vim.cmd("ColorizerReloadAllBuffers")
        end)
        pcall(function()
            require("todo-comments.highlight").create()
        end)
    end)
end

-- 1. Run immediately when Neovim boots up so it perfectly matches your system
-- vim.o.background = "dark"
-- vim.cmd.colorscheme("tokyonight")

-- Run immediately when Neovim boots up
if not vim.g.has_booted_theme then
    vim.g.has_booted_theme = true
    _G.SyncTheme()
end

-- listen for theme toggle signal
vim.api.nvim_create_autocmd("Signal", {
    pattern = "SIGUSR1",
    callback = _G.SyncTheme,
})
