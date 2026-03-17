-- ──────────────────────────────────────────────
-- darkcoffys-workbench :: neovim config
-- ──────────────────────────────────────────────

-- ── Leader key ──
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- ── Core options ──
local opt = vim.opt
opt.number = true
opt.relativenumber = true
opt.signcolumn = "yes"
opt.cursorline = true
opt.termguicolors = true
opt.mouse = "a"
opt.clipboard = "unnamedplus"
opt.breakindent = true
opt.undofile = true
opt.ignorecase = true
opt.smartcase = true
opt.updatetime = 250
opt.timeoutlen = 300
opt.splitright = true
opt.splitbelow = true
opt.scrolloff = 8
opt.sidescrolloff = 8
opt.expandtab = true
opt.shiftwidth = 4
opt.tabstop = 4
opt.wrap = false
opt.showmode = false
opt.swapfile = false

-- ── Basic keymaps ──
local map = vim.keymap.set

-- Better window navigation
map("n", "<C-h>", "<C-w>h", { desc = "Move to left pane" })
map("n", "<C-j>", "<C-w>j", { desc = "Move to lower pane" })
map("n", "<C-k>", "<C-w>k", { desc = "Move to upper pane" })
map("n", "<C-l>", "<C-w>l", { desc = "Move to right pane" })

-- Clear search highlight
map("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Better indenting (stay in visual mode)
map("v", "<", "<gv")
map("v", ">", ">gv")

-- Move lines up/down
map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

-- ── Bootstrap lazy.nvim (plugin manager) ──
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git", "clone", "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

-- ── Plugins ──
require("lazy").setup("plugins", {
    performance = {
        rtp = {
            disabled_plugins = {
                "gzip", "matchit", "matchparen",
                "netrwPlugin", "tarPlugin", "tohtml",
                "tutor", "zipPlugin",
            },
        },
    },
    ui = { border = "rounded" },
})
