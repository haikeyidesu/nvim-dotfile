local status, jdtls = pcall(require, "jdtls")
if not status then
    return
end

-- Automatically find where Mason downloaded jdtls
local mason_path = vim.fn.stdpath("data") .. "/mason/packages/jdtls"
local config_dir = mason_path .. "/config_mac" -- Use config_linux if you are on Linux
local target_jar = vim.fn.glob(mason_path .. "/plugins/org.eclipse.equinox.launcher_*.jar")

-- Generate a unique workspace folder for the project you're currently in
local workspace_dir = vim.fn.stdpath("data") .. "/jdtls-workspace/" .. vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")

local function setup_jdtls()
    local cmd = {
        "java",
        "-Declipse.application=org.eclipse.jdt.ls.core.id1",
        "-Dosgi.bundles.defaultStartLevel=4",
        "-Declipse.product=org.eclipse.jdt.ls.core.product",
        "-Dlog.protocol=true",
        "-Dlog.level=ALL",
        "-Xmx2g",
        "--add-modules=ALL-SYSTEM",
        "--add-opens",
        "java.base/java.util=ALL-UNNAMED",
        "--add-opens",
        "java.base/java.lang=ALL-UNNAMED",
        "-jar",
        target_jar,
        "-configuration",
        config_dir,
        "-data",
        workspace_dir,
    }

    local config = {
        cmd = cmd,
        capabilities = require("cmp_nvim_lsp").default_capabilities(),
    }

    jdtls.start_or_attach(config)
end

-- This triggers ONLY when you open a .java file, keeping it completely decoupled from your other LSPs
vim.api.nvim_create_autocmd("FileType", {
    pattern = "java",
    callback = setup_jdtls,
})
