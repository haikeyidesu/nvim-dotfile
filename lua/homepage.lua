local M = {}

function M.setup()
  require("snacks").setup({
    dashboard = {
      enabled = true,
      sections = {
        { section = "header", padding = 1 },
        { section = "keys", gap = 1, padding = 1, indent = 2 },
        -- We manually define the startup section here so it doesn't 
        -- try to look for the "lazy.stats" module.
        {
          section = "startup",
          padding = 1,
          format = function(cmd)
            -- This gets the generic Neovim startup time instead of Lazy's stats
            local stats = require("snacks").dashboard.stats()
            local time = (math.floor(stats.startuptime * 100 + 0.5) / 100)
            return { { "⚡ Neovim loaded in " .. time .. "ms", hl = "SnacksDashboardStats" } }
          end,
        },
      },
      preset = {
        header = [[
      ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
      ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║
      ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║
      ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
      ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
      ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝]],
        keys = {
          { icon = " ", key = "e",   desc = "New file",            action = ":ene | startinsert" },
          { icon = " ", key = "ff",  desc = "Find file",           action = ":lua Snacks.dashboard.pick('files')" },
          { icon = " ", key = "fh",  desc = "Recently opened files", action = ":lua Snacks.dashboard.pick('recent')" },
          { icon = " ", key = "fr",  desc = "Frecency/MRU",        action = ":lua Snacks.dashboard.pick('recent')" },
          { icon = " ", key = "fg",  desc = "Find word",           action = ":lua Snacks.dashboard.pick('live_grep')" },
          { icon = " ", key = "fm",  desc = "Jump to bookmarks",   action = ":lua Snacks.dashboard.pick('marks')" },
          { icon = " ", key = "sl",  desc = "Open last session",   action = ":lua Snacks.dashboard.pick('resume')" },
        },
      },
      formats = {
        key = function(item)
          local display_key = item.key:gsub("(%w)(%w)", "SPC %1 %2")
          return { { display_key, hl = "SnacksDashboardKey" } }
        end,
      },
    },
  })
end

return M
