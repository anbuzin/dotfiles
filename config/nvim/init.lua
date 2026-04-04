-- <C-x-o> -- vanilla complete
vim.loader.enable()

vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.g.have_nerd_font = true

-- Options

vim.opt.showmode = false
vim.opt.mouse = "a"

vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.smartindent = true

vim.opt.ignorecase = true -- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.smartcase = true

vim.opt.wrap = false

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

-- vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.inccommand = 'split' -- Preview substitutions live, as you type!

vim.opt.cursorline = true    -- Show which line your cursor is on

vim.opt.termguicolors = true

vim.opt.scrolloff = 10
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

vim.opt.updatetime = 50

-- Native autocompletion (Neovim 0.12+)
vim.o.autocomplete = true
-- vim.o.completeopt = 'menu,menuone,noselect,nearest'
-- vim.o.pumborder = 'rounded'

-- Remaps
vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Explore" })

vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Go [d]own half a page and center" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Go [u]p half a page and center" })

vim.keymap.set("n", "n", "nzzzv", { desc = "Find next, open fold and center" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Find previous, open fold and center" })

vim.keymap.set("v", "<leader>p", "\"_dhp", { desc = "Paste without overriding yank buffer" })

vim.keymap.set({ "n", "v", "x" }, "<leader>d", "\"_d", { desc = "Delete without overriding yank buffer" })
vim.keymap.set({ "n", "v", "x" }, "<leader>y", [["+y]], { desc = "Yank selected to clipboard register" })

vim.keymap.set("n", "Q", "<nop>", { desc = "Don't go there" })

vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>', { desc = "Clear highlights" })

vim.keymap.set("n", '<leader>e', vim.diagnostic.open_float, { desc = 'Show diagnostic error' })

-- Highlight when yanking (copying) text
vim.api.nvim_create_autocmd('TextYankPost', {
    desc = 'Highlight when yanking (copying) text',
    group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
    callback = function()
        vim.highlight.on_yank()
    end,
})

-- Built-in plugins (Neovim 0.12+)
vim.cmd.packadd('nvim.undotree')

-- Plugin hooks (must be defined before vim.pack.add)
vim.api.nvim_create_autocmd('PackChanged', {
    callback = function(ev)
        local name, kind = ev.data.spec.name, ev.data.kind
        if name == 'nvim-treesitter' and (kind == 'install' or kind == 'update') then
            if not ev.data.active then vim.cmd.packadd('nvim-treesitter') end
            vim.cmd('TSUpdate')
        end
        -- Rebuild telescope-fzf-native on install/update
        if name == 'telescope-fzf-native.nvim' and (kind == 'install' or kind == 'update') then
            local path = vim.fn.stdpath('data') .. '/site/pack/core/opt/telescope-fzf-native.nvim'
            vim.system({ 'make' }, { cwd = path })
        end
    end,
})

-- Install and load plugins via vim.pack (Neovim 0.12+)
vim.pack.add({
    -- Theme
    { src = 'https://github.com/catppuccin/nvim', name = 'catppuccin' },

    -- Fuzzy finder
    'https://github.com/nvim-telescope/telescope.nvim',
    'https://github.com/nvim-lua/plenary.nvim',
    'https://github.com/nvim-telescope/telescope-fzf-native.nvim',
    'https://github.com/nvim-telescope/telescope-ui-select.nvim',

    -- Treesitter
    'https://github.com/nvim-treesitter/nvim-treesitter',

    -- Git
    'https://github.com/tpope/vim-fugitive',
    'https://github.com/lewis6991/gitsigns.nvim',

    -- LSP
    'https://github.com/williamboman/mason.nvim',
    'https://github.com/williamboman/mason-lspconfig.nvim',
    'https://github.com/neovim/nvim-lspconfig',

    -- File explorer
    'https://github.com/stevearc/oil.nvim',

    -- Key hints
    'https://github.com/folke/which-key.nvim',
})

-- Theme setup (must happen right after plugins are loaded)
require("catppuccin").setup({
    flavour = "mocha",
    transparent_background = true,
    float = {
        transparent = true,
    },
})
vim.cmd.colorscheme("catppuccin-nvim")

-- Which-key setup
require("which-key").setup({})
vim.keymap.set("n", "<leader>?", function()
    require("which-key").show({ global = false })
end, { desc = "Buffer Local Keymaps (which-key)" })

-- Gitsigns setup
require("gitsigns").setup({})
