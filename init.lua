-- General
vim.g.mapleader = " "

-- Options
vim.o.number = true
vim.o.relativenumber = true
vim.o.signcolumn = "yes"
vim.o.winborder = "rounded"
vim.o.showmode = false
vim.o.scrolloff = 8

vim.o.expandtab = true
vim.o.tabstop = 4
vim.o.shiftwidth = 4

vim.o.ignorecase = true
vim.o.smartcase = true

vim.o.clipboard = "unnamedplus"
vim.o.undofile = true

-- Keymaps
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<cr>")
vim.keymap.set("t", "<Esc><Esc>", [[<C-\><C-n>]])

-- Plugins
vim.pack.add({
    "https://github.com/navarasu/onedark.nvim",
    "https://github.com/nvim-tree/nvim-web-devicons",
    "https://github.com/nvim-treesitter/nvim-treesitter",
    "https://github.com/nvim-lualine/lualine.nvim",
    "https://github.com/lewis6991/gitsigns.nvim",
    "https://github.com/folke/snacks.nvim",
    "https://github.com/neovim/nvim-lspconfig",
    "https://github.com/rachartier/tiny-inline-diagnostic.nvim",
    "https://github.com/saghen/blink.lib",
    "https://github.com/saghen/blink.cmp",
    "https://github.com/windwp/nvim-autopairs",
    "https://codeberg.org/andyg/leap.nvim",
    "https://github.com/stevearc/conform.nvim",
})

-- Theme
require("onedark").setup({ style = "darker" })
require("onedark").load()

-- Status line
require("lualine").setup({
    options = {
        section_separators = "",
        component_separators = "",
    },
    sections = {
        lualine_b = { "branch" },
        lualine_c = { { "filename", path = 1 } },
        lualine_x = { "diagnostics", "lsp_status", { "filetype", icon_only = true } },
        lualine_z = {},
    },
})

-- Git signs
require("gitsigns").setup()

-- Snacks: explorer, picker and lazygit
require("snacks").setup({
    explorer = { enabled = true },
    lazygit = { enabled = true },
    picker = {
        enabled = true,
        sources = { explorer = { layout = { hidden = { "input" } } } },
    },
})
vim.keymap.set("n", "<leader>fe", Snacks.explorer.open)
vim.keymap.set("n", "<leader>ff", Snacks.picker.files)
vim.keymap.set("n", "<leader>fg", Snacks.picker.grep)
vim.keymap.set("n", "<leader>fb", Snacks.picker.buffers)
vim.keymap.set("n", "<leader>fd", Snacks.picker.diagnostics)
vim.keymap.set("n", "<leader>fr", Snacks.picker.lsp_references)
vim.keymap.set("n", "gd", Snacks.picker.lsp_definitions)
vim.keymap.set("n", "<leader>lg", Snacks.lazygit.open)

-- LSP
vim.lsp.config("lua_ls", {
    settings = {
        Lua = {
            diagnostics = { globals = { "vim", "Snacks" } },
        },
    },
})
vim.lsp.enable({
    "lua_ls",
    "rust_analyzer",
    "pyright",
    "clangd",
    "ts_ls",
    "bashls",
})

-- Diagnostics
vim.diagnostic.config({
    virtual_text = false,
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = "●",
            [vim.diagnostic.severity.WARN] = "●",
            [vim.diagnostic.severity.INFO] = "●",
            [vim.diagnostic.severity.HINT] = "●",
        },
    },
})
require("tiny-inline-diagnostic").setup({
    preset = "ghost",
    options = {
        multilines = { enabled = true },
    },
})
vim.keymap.set("n", "<leader>dn", function()
    vim.diagnostic.jump({ count = 1 })
end)
vim.keymap.set("n", "<leader>dp", function()
    vim.diagnostic.jump({ count = -1 })
end)

-- Completion
local cmp = require("blink.cmp")
cmp.build():pwait()
cmp.setup({
    keymap = {
        ["<CR>"] = { "accept", "fallback" },
        ["<Tab>"] = { "select_next", "fallback" },
        ["<S-Tab>"] = { "select_prev", "fallback" },
        ["<Esc>"] = { "cancel", "fallback" },
    },
    completion = {
        documentation = { auto_show = true },
    },
    sources = {
        default = { "lsp", "path", "snippets", "buffer" },
    },
})

-- Auto pairs
require("nvim-autopairs").setup()

-- Leap
vim.keymap.set({ "n", "x", "o" }, "s", "<Plug>(leap)")
vim.keymap.set("n", "S", "<Plug>(leap-from-window)")

-- Format
require("conform").setup({
    default_format_opts = { lsp_format = "fallback" },
    formatters_by_ft = {
        python = { "ruff_format" },
        javascript = { "prettier" },
        typescript = { "prettier" },
        html = { "prettier" },
    },
})
vim.keymap.set("n", "<leader>fm", require("conform").format)

-- Treesitter
require("nvim-treesitter").install({
    "rust",
    "lua",
    "python",
    "c",
    "cpp",
    "bash",
    "typescript",
    "javascript",
    "html",
})
vim.api.nvim_create_autocmd("FileType", {
    callback = function()
        pcall(vim.treesitter.start)
    end,
})
