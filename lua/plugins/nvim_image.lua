require("image").setup({
    backend = "kitty", -- Ghostty uses the kitty protocol
    integrations = {
        markdown = {
            enabled = true,
            clear_in_insert_mode = false,
            download_remote_images = true,
            only_render_image_at_cursor = false,
            filetypes = { "markdown", "vimwiki", "obsidian" }, -- Add obsidian here
        },
    },
    max_width = 100,
    max_height = 12,
    max_width_window_percentage = nil,
    max_height_window_percentage = 50,
    window_overlap_clear_enabled = false,
    -- obsidian image path
    resolve_image_path = function(image_path, current_buffer_path)
        -- 1. Check if it's an Obsidian wikilink: ![[image.png]]
        if image_path:match("^!%[%[(.*)%]%]$") then
            local filename = image_path:match("^!%[%[(.*)%]%]$")

            -- 2. Define where your Obsidian images actually live
            -- CHANGE THIS to your actual attachments folder path!
            local vault_root =
                "/Users/asher/Library/Mobile Documents/iCloud~md~obsidian/Documents/asher's obsidian vault/"
            local attachments_folder = vault_root .. "attachments/"

            -- 3. Return the absolute path so the plugin can find it
            return attachments_folder .. filename
        end

        -- Fallback for standard markdown links
        return image_path
    end,
    pipe_path = "/tmp/nvim-image-proxy", -- For remote/tmux support
})
