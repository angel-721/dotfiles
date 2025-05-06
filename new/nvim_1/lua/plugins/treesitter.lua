local M = {
    "nvim-treesitter/nvim-treesitter",
    build = function()
        require("nvim-treesitter.install").update({ with_sync = true })()
    end,
    config = function()
        require("nvim-treesitter.configs").setup({
            ensure_installed = { "lua", "nim", "python", "javascript", "html", "tsx", "typescript","css", "rust" }, -- Add the languages you need
            highlight = { enable = true },
            indent = { enable = true },
        })
    end,
}

return { M }
