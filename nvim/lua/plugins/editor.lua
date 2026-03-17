return {
    -- File tree (lightweight, replaces netrw)
    {
        "nvim-tree/nvim-tree.lua",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        keys = {
            { "<leader>e", "<cmd>NvimTreeToggle<CR>", desc = "Toggle file tree" },
        },
        opts = {
            view = { width = 30 },
            filters = { dotfiles = false },
            git = { enable = true },
        },
    },

    -- Fuzzy finder
    {
        "nvim-telescope/telescope.nvim",
        branch = "0.1.x",
        dependencies = { "nvim-lua/plenary.nvim" },
        keys = {
            { "<leader>ff", "<cmd>Telescope find_files<CR>", desc = "Find files" },
            { "<leader>fg", "<cmd>Telescope live_grep<CR>",  desc = "Live grep" },
            { "<leader>fb", "<cmd>Telescope buffers<CR>",    desc = "Buffers" },
            { "<leader>fh", "<cmd>Telescope help_tags<CR>",  desc = "Help tags" },
            { "<leader>/",  "<cmd>Telescope current_buffer_fuzzy_find<CR>", desc = "Search buffer" },
        },
        opts = {
            defaults = {
                file_ignore_patterns = { "node_modules", ".git/", "__pycache__" },
            },
        },
    },

    -- Status line (fast, minimal)
    {
        "nvim-lualine/lualine.nvim",
        event = "VeryLazy",
        opts = {
            options = {
                theme = "catppuccin",
                component_separators = { left = "│", right = "│" },
                section_separators = {},
                globalstatus = true,
            },
            sections = {
                lualine_a = { "mode" },
                lualine_b = { "branch", "diff" },
                lualine_c = { { "filename", path = 1 } },
                lualine_x = { "diagnostics" },
                lualine_y = { "filetype" },
                lualine_z = { "location" },
            },
        },
    },

    -- Treesitter (syntax highlighting)
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        event = { "BufReadPost", "BufNewFile" },
        opts = {
            ensure_installed = {
                "python", "lua", "javascript", "typescript",
                "rust", "go", "bash", "json", "yaml", "toml",
                "html", "css", "markdown", "markdown_inline",
            },
            highlight = { enable = true },
            indent = { enable = true },
        },
        config = function(_, opts)
            require("nvim-treesitter.configs").setup(opts)
        end,
    },

    -- Autopairs
    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        opts = {},
    },

    -- Git signs in gutter
    {
        "lewis6991/gitsigns.nvim",
        event = { "BufReadPost", "BufNewFile" },
        opts = {},
    },

    -- Comment toggling
    {
        "numiras/Comment.nvim",
        keys = {
            { "gcc", mode = "n", desc = "Toggle comment" },
            { "gc",  mode = "v", desc = "Toggle comment" },
        },
        opts = {},
    },

    -- Which-key (shows available keybinds)
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        opts = {},
    },
}
