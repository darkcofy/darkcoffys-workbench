-- Catppuccin: fast, low-overhead colorscheme
return {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    lazy = false,
    opts = {
        flavour = "mocha",
        transparent_background = true,
        integrations = {
            treesitter = true,
            telescope = { enabled = true },
            mini = { enabled = true },
        },
    },
    config = function(_, opts)
        require("catppuccin").setup(opts)
        vim.cmd.colorscheme("catppuccin")
    end,
}
