-- Gdiffsplit! pane labels with dynamic version tracking
local function git_diff_label()
    local bufname = vim.api.nvim_buf_get_name(0)

    -- 1. Check for standard 2-pane Git Diff (index version vs working file)
    if string.match(bufname, "//0") or string.match(bufname, "%.git_index") then
        return "󰜘 STAGED INDEX (PRE-COMMIT)"

    -- 2. Check for an explicit Git commit/revision window (extracts the commit reference!)
    elseif string.match(bufname, "fugitive://") and string.match(bufname, "%.git//") then
        -- This extracts the specific commit hash/branch name out of Fugitive's internal URL
        local commit_ref = string.match(bufname, "%.git//([^/]+)_")
        if commit_ref then
            return "󰜘 VER: " .. commit_ref:sub(1, 7) -- Shows the first 7 characters of the commit hash
        end
        return "󰜘 OLD VERSION"

    -- 3. Check for 3-pane Merge Conflicts
    elseif string.match(bufname, "%.git//2_") or string.match(bufname, "//2") then
        return "󰜘 REMOTE (THEIRS)"
    elseif string.match(bufname, "%.git//3_") or string.match(bufname, "//3") then
        return "󰜘 LOCAL (YOURS)"

    -- 4. Check for the general Fugitive status panel
    elseif vim.bo.filetype == "fugitive" then
        -- If it's the main status page, try to grab the current branch name
        local branch = vim.fn.FugitiveHead()
        return branch ~= "" and ("󰜘 GIT STATUS (" .. branch .. ")") or "󰜘 GIT STATUS"
    end

    -- Fallback to standard filename if it's a normal active file
    return vim.fn.expand("%:t")
end

-- Single, unified lualine setup block
require("lualine").setup({
    options = {
        icons_enabled = true,
        theme = "auto",
        component_separators = { left = "", right = "" },
        section_separators = { left = "", right = "" },
        disabled_filetypes = {
            statusline = {},
            winbar = {},
        },
        ignore_focus = {},
        always_divide_middle = true,
        globalstatus = true,false
        refresh = {
            statusline = 1000,
            tabline = 1000,
            winbar = 1000,
        },
    },
    sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch", "diff", "diagnostics" },
        lualine_c = { git_diff_label }, -- 󰜘 Uses our new smart label instead of raw text!
        lualine_x = { "encoding", "fileformat", "filetype" },
        lualine_y = { "progress" },
        lualine_z = { "location" },
    },
    inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { git_diff_label }, -- Also apply it to inactive split windows!
        lualine_x = { "location" },
        lualine_y = {},
        lualine_z = {},
    },
    tabline = {},
    winbar = {},
    inactive_winbar = {},
    extensions = {},
})
