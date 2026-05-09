require("nvim-autopairs").setup({})

-- Optional: If you want to make sure [[ works perfectly
local Rule = require("nvim-autopairs.rule")
local npairs = require("nvim-autopairs")

npairs.add_rules({
    Rule("[[", "]]", "markdown"),
})
