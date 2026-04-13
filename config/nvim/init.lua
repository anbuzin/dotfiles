vim.loader.enable()

vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.g.have_nerd_font = true

vim.opt.showmode = false

-- these should be superceded by defaults
-- vim.opt.mouse = "a"
-- vim.opt.incsearch = true
-- vim.opt.termguicolors = true

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

vim.opt.inccommand = 'split' -- Preview substitutions live, as you type!

vim.opt.cursorline = true    -- Show which line your cursor is on

vim.opt.scrolloff = 10
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

vim.opt.updatetime = 50

-- native autocompletion
vim.o.autocomplete = true
-- vim.o.completeopt = 'menu,menuone,noselect,nearest'
-- vim.o.pumborder = 'rounded'

-- diagnostics
vim.diagnostic.config({
    severity_sort = true,
    float = {
        -- border = 'rounded',
        source = true,
    },
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = 'E',
            [vim.diagnostic.severity.WARN]  = 'W',
            [vim.diagnostic.severity.INFO]  = 'I',
            [vim.diagnostic.severity.HINT]  = 'H',
        },
    },
})


-- keymaps
vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Explore" })

vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Go [d]own half a page and center" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Go [u]p half a page and center" })

vim.keymap.set("n", "n", "nzzzv", { desc = "Find next, open fold and center" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Find previous, open fold and center" })

vim.keymap.set("v", "<leader>p", "\"_dhp", { desc = "Paste without overriding yank buffer" })

vim.keymap.set({ "n", "v", "x" }, "<leader>d", "\"_d", { desc = "Delete without overriding yank buffer" })
vim.keymap.set({ "n", "v", "x" }, "<leader>y", [["+y]], { desc = "Yank selected to clipboard register" })

-- vim.keymap.set("n", "Q", "<nop>", { desc = "Don't go there" })

vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>', { desc = "Clear highlights" })

vim.keymap.set("n", '<leader>e', vim.diagnostic.open_float, { desc = 'Show diagnostic error' })


-- blink when yanking text for visual feedback
vim.api.nvim_create_autocmd('TextYankPost', {
    desc = 'Highlight when yanking (copying) text',
    group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
    callback = function()
        vim.highlight.on_yank()
    end,
})

-- built-in
vim.cmd.packadd('nvim.undotree')

-- hooks
vim.api.nvim_create_autocmd('PackChanged', {
    callback = function(ev)
        local name, kind = ev.data.spec.name, ev.data.kind
        if name == 'nvim-treesitter' and (kind == 'install' or kind == 'update') then
            if not ev.data.active then vim.cmd.packadd('nvim-treesitter') end
            vim.cmd('TSUpdate')
        end
        if name == 'telescope-fzf-native.nvim' and (kind == 'install' or kind == 'update') then
            local path = vim.fn.stdpath('data') .. '/site/pack/core/opt/telescope-fzf-native.nvim'
            vim.system({ 'make' }, { cwd = path })
        end
    end,
})

-- plugins
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


require("catppuccin").setup({
    flavour = "mocha",
    transparent_background = true,
    float = {
        transparent = true,
    },
})
vim.cmd.colorscheme("catppuccin-nvim")

require('nvim-treesitter').setup {}

require('nvim-treesitter').install {
    "c", "lua", "vim", "vimdoc", "query",
    "markdown", "markdown_inline",
    "cuda", "javascript", "typescript", "tsx", "jsdoc",
    "cpp", "python", "rust",
    "json", "yaml", "toml", "html", "css",
}

-- treesitter highlighting for all filetypes that have a parser
vim.api.nvim_create_autocmd('FileType', {
    callback = function()
        pcall(vim.treesitter.start)
    end,
})

require("oil").setup({
    view_options = {
        show_hidden = true,
    }
})

require("gitsigns").setup({})

require("which-key").setup({})

vim.keymap.set("n", "<leader>?", function()
    require("which-key").show({ global = false })
end, { desc = "Buffer Local Keymaps (which-key)" })

-- Telescope setup
-- In-picker controls:
--   <C-h>  toggle hidden/dotfiles (but not turd directories)
--   <C-f>  toggle show full (including turd directores)
--   <C-g>  toggle between project root and current file directory
--   -      go up one directory (normal mode)

-- List of turd directories
local exclude_patterns = {
    '.git',
    '.mypy_cache',
    '.venv',
    '.ruff_cache',
    '.pytest_cache',
    '.vercel',
    '__pycache__',
    'node_modules',
}

local function build_exclude_globs(show_full)
    if show_full then return {} end
    local args = {}
    for _, pat in ipairs(exclude_patterns) do
        table.insert(args, '--glob')
        table.insert(args, '!**/' .. pat .. '/*')
    end
    return args
end

require('telescope').setup {
    extensions = {
        ['ui-select'] = {
            require('telescope.themes').get_dropdown(),
        },
    },
}

pcall(require('telescope').load_extension, 'fzf')
pcall(require('telescope').load_extension, 'ui-select')

local function get_current_dir()
    local ok, oil = pcall(require, 'oil')
    if ok and oil.get_current_dir then
        local dir = oil.get_current_dir()
        if dir then return dir end
    end
    return vim.fn.expand('%:p:h')
end

local function get_project_root()
    local dot_git = vim.fn.finddir('.git', '.;')
    if dot_git ~= '' then
        return vim.fn.fnamemodify(dot_git, ':h')
    end
    return vim.fn.getcwd()
end

local function find_files(opts)
    opts = opts or {}
    local cwd = opts.cwd or get_project_root()
    local show_hidden = opts.show_hidden or false
    local show_full = opts.show_full or false

    local find_command = nil
    if show_hidden or show_full then
        find_command = { 'rg', '--files', '--hidden', '--no-ignore' }
        vim.list_extend(find_command, build_exclude_globs(show_full))
    end

    require('telescope.builtin').find_files({
        cwd = cwd,
        find_command = find_command,
        initial_mode = opts.initial_mode or 'insert',
        attach_mappings = function(prompt_bufnr, map)
            local action_state = require('telescope.actions.state')

            map({ 'i', 'n' }, '<C-h>', function()
                local prompt = action_state.get_current_line()
                require('telescope.actions').close(prompt_bufnr)
                find_files({ cwd = cwd, show_hidden = not show_hidden, show_full = show_full, prompt = prompt })
            end, { desc = 'Toggle [H]idden' })

            map({ 'i', 'n' }, '<C-f>', function()
                local prompt = action_state.get_current_line()
                require('telescope.actions').close(prompt_bufnr)
                find_files({ cwd = cwd, show_hidden = show_hidden, show_full = not show_full, prompt = prompt })
            end, { desc = 'Toggle [F]ull (including turds)' })

            map({ 'i', 'n' }, '<C-g>', function()
                local prompt = action_state.get_current_line()
                require('telescope.actions').close(prompt_bufnr)
                local new_cwd
                if cwd == get_project_root() then
                    new_cwd = get_current_dir()
                else
                    new_cwd = get_project_root()
                end
                find_files({ cwd = new_cwd, show_hidden = show_hidden, show_full = show_full, prompt = prompt })
            end, { desc = 'Toggle local / [G]it root search' })

            map('n', '-', function()
                local prompt = action_state.get_current_line()
                require('telescope.actions').close(prompt_bufnr)
                find_files({
                    cwd = vim.fn.fnamemodify(cwd, ':h'),
                    show_hidden = show_hidden,
                    show_full = show_full,
                    prompt = prompt,
                    initial_mode = 'normal'
                })
            end, { desc = 'Go up one directory' })

            return true
        end,
        default_text = opts.prompt or '',
    })
end

local function live_grep(opts)
    opts = opts or {}
    local cwd = opts.cwd or get_project_root()
    local show_hidden = opts.show_hidden or false
    local show_full = opts.show_full or false

    local vimgrep_arguments = {
        'rg', '--color=never', '--no-heading', '--with-filename',
        '--line-number', '--column', '--smart-case',
    }
    if show_hidden or show_full then
        table.insert(vimgrep_arguments, '--hidden')
        table.insert(vimgrep_arguments, '--no-ignore')
        vim.list_extend(vimgrep_arguments, build_exclude_globs(show_full))
    end

    require('telescope.builtin').live_grep({
        cwd = cwd,
        vimgrep_arguments = vimgrep_arguments,
        initial_mode = opts.initial_mode or 'insert',
        attach_mappings = function(prompt_bufnr, map)
            local action_state = require('telescope.actions.state')

            map({ 'i', 'n' }, '<C-h>', function()
                local prompt = action_state.get_current_line()
                require('telescope.actions').close(prompt_bufnr)
                live_grep({ cwd = cwd, show_hidden = not show_hidden, show_full = show_full, prompt = prompt })
            end, { desc = 'Toggle hidden/dotfiles' })

            map({ 'i', 'n' }, '<C-f>', function()
                local prompt = action_state.get_current_line()
                require('telescope.actions').close(prompt_bufnr)
                live_grep({ cwd = cwd, show_hidden = show_hidden, show_full = not show_full, prompt = prompt })
            end, { desc = 'Toggle show full (bypass exclude list)' })

            map({ 'i', 'n' }, '<C-g>', function()
                local prompt = action_state.get_current_line()
                require('telescope.actions').close(prompt_bufnr)
                local new_cwd
                if cwd == get_project_root() then
                    new_cwd = get_current_dir()
                else
                    new_cwd = get_project_root()
                end
                live_grep({ cwd = new_cwd, show_hidden = show_hidden, show_full = show_full, prompt = prompt })
            end, { desc = 'Toggle local/project directory' })

            map('n', '-', function()
                local prompt = action_state.get_current_line()
                require('telescope.actions').close(prompt_bufnr)
                live_grep({
                    cwd = vim.fn.fnamemodify(cwd, ':h'),
                    show_hidden = show_hidden,
                    show_full = show_full,
                    prompt = prompt,
                    initial_mode = 'normal'
                })
            end, { desc = 'Go up one directory' })

            return true
        end,
        default_text = opts.prompt or '',
    })
end

local builtin = require 'telescope.builtin'
vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp tags' })
vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
vim.keymap.set('n', '<leader>sf', function() find_files() end, { desc = '[S]earch [F]iles' })
-- vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
-- vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
vim.keymap.set('n', '<leader>sg', function() live_grep() end, { desc = '[S]earch by [G]rep' })
vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume last picker' })
-- vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
-- vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })

vim.keymap.set('n', '<leader>sn', function()
    find_files({ cwd = vim.fn.stdpath 'config' })
end, { desc = '[S]earch [N]eovim files' })

-- LSP setup
vim.api.nvim_create_autocmd('LspAttach', {
    desc = 'LSP actions',
    callback = function(event)
        local map = function(keys, func, desc, mode)
            mode = mode or 'n'
            vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
        end

        -- Overrides for Telescope-based navigation (instead of built-in quickfix):
        map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
        map('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')

        map('<leader>ff', vim.lsp.buf.format, '[F]ormat [F]ile')

        --   gra  -> code actions
        --   gri  -> implementations
        --   grn  -> rename
        --   grr  -> references
        --   grt  -> type definition
        --   grx  -> run codelens
        --   gO   -> document symbols
        --   <C-S> (insert) -> signature help
    end,
})

-- Mason
require('mason').setup({})
require('mason-lspconfig').setup({
    ensure_installed = {
        "lua_ls", "ts_ls", "eslint", "clangd",
        "ruff", "basedpyright", "rust_analyzer",
    },
    handlers = {
        function(server_name)
            vim.lsp.config(server_name, {})
        end,
        clangd = function()
            vim.lsp.config('clangd', {
                cmd = { "clangd", "--fallback-style=webkit" },
            })
        end,
    },
})

-- sourcekit (Swift) ships with Xcode, not managed by Mason
vim.lsp.config("sourcekit", {
    capabilities = {
        workspace = {
            didChangeWatchedFiles = {
                dynamicRegistration = true,
            },
        },
    },
})
