-- Molten configuration for text layouts
vim.g.molten_auto_open_output = false
vim.g.molten_wrap_output = true
vim.g.molten_virt_text_output = true
vim.g.molten_virt_lines_off_by_1 = true

-- Jupytext setup to automatically treat .ipynb files as markdown syntax
require("jupytext").setup({
    style = "markdown",
    output_extension = "md",
    extension = "md",
    force_ft = "markdown",
})

-- Normal mode bindings
vim.keymap.set("n", "<leader>ji", ":MoltenInit<CR>", { desc = "Jupyter Initialize (Molten)" })
vim.keymap.set(
    "n",
    "<leader>je",
    ":MoltenEvaluateOperator<CR>",
    { desc = "Molten [J]upyter [E]valuate Operator (Molten)" }
)
vim.keymap.set("n", "<leader>jl", ":MoltenEvaluateLine<CR>", { desc = "Jupyter Evaluate Line (Molten)" })
vim.keymap.set("n", "<leader>jo", ":MoltenOutput_Show<CR>", { desc = "Jupyter Output Show (Molten)" })
vim.keymap.set("n", "<leader>jh", ":MoltenHideOutput<CR>", { desc = "Jupyter Hide Output (Molten)" })

-- Visual mode binding to execute multi-line code selections
vim.keymap.set("v", "<leader>je", ":<C-u>MoltenEvaluateVisual<CR>gv", { desc = "Molten [J]upyter [E]valuate Visual" })
