require("image").setup({
    backend = "kitty",
    processor = "magick_cli",
    integrations = {
        markdown = {
            enabled = true,
            clear_in_insert_mode = true,
            download_remote_images = false,
            -- FIX 1: Only render what you see to prevent background crashes
            only_render_image_at_cursor = true,
            filetypes = { "markdown", "vimwiki", "obsidian" },
        },
    },
    -- FIX 2: Ignore tiny or weirdly sized data blobs
    min_width = 10,
    min_height = 10,

    resolve_image_path = function(image_path, _)
        -- FIX 3: THE SAFEGUARD
        -- If the "path" is actually a giant Base64 string (longer than 1000 chars),
        -- or starts with "data:", return nil so the plugin doesn't crash.
        if image_path:match("^data:image") or #image_path > 1000 then
            return nil
        end

        local filename = image_path:match("!%[%[(.-)%]%]")
        if not filename then
            return image_path
        end

        local vault_root = "/Users/asher/Library/Mobile Documents/iCloud~md~obsidian/Documents/asher's obsidian vault/"

        local paths_to_check = {
            vault_root .. filename,
            vault_root .. "attachments/" .. filename,
            vim.fn.expand("%:p:h") .. "/" .. filename,
        }

        for _, path in ipairs(paths_to_check) do
            if vim.fn.filereadable(path) == 1 then
                return path
            end
        end
        return image_path
    end,
    tmux_passthrough = true,
})
