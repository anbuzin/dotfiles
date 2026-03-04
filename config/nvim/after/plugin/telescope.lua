-- Telescope is a fuzzy finder that comes with a lot of different things that
-- it can fuzzy find! It's more than just a "file finder", it can search
-- many different aspects of Neovim, your workspace, LSP, and more!
--
-- The easiest way to use Telescope, is to start by doing something like:
--  :Telescope help_tags
--
-- After running this command, a window will open up and you're able to
-- type in the prompt window. You'll see a list of `help_tags` options and
-- a corresponding preview of the help.
--
-- Two important keymaps to use while in Telescope are:
--  - Insert mode: <c-/>
--  - Normal mode: ?
--
-- This opens a window that shows you all of the keymaps for the current
-- Telescope picker. This is really useful to discover what Telescope can
-- do as well as how to actually do it!

-- In-picker controls:
--   <C-h>  toggle hidden/dotfiles (ignore list still applies)
--   <C-a>  show ALL files (hidden + ignore list off)
--   <C-g>  jump to git project root
--   -      go up one directory (normal mode)

-- Excluded from search even when hidden files are shown.
-- Only bypassed by <C-a> (show all).
local ignore_patterns = {
    '.git',
    '.mypy_cache',
    '.venv',
    '.ruff_cache',
    '.pytest_cache',
    '.vercel',
    '__pycache__',
    'node_modules',
}

-- Build rg glob args from ignore_patterns: { '--glob', '!pat', '--glob', '!pat', ... }
local function ignore_globs(use_ignore)
    if use_ignore == false then return {} end
    local args = {}
    for _, pat in ipairs(ignore_patterns) do
        table.insert(args, '--glob')
        table.insert(args, '!**/' .. pat .. '/*')
    end
    return args
end

-- [[ Configure Telescope ]]
-- See `:help telescope` and `:help telescope.setup()`
require('telescope').setup {
    extensions = {
        ['ui-select'] = {
            require('telescope.themes').get_dropdown(),
        },
    },
}

-- Enable Telescope extensions if they are installed
pcall(require('telescope').load_extension, 'fzf')
pcall(require('telescope').load_extension, 'ui-select')

-- Get the directory of the current buffer, oil-aware.
local function get_current_dir()
    local ok, oil = pcall(require, 'oil')
    if ok and oil.get_current_dir then
        local dir = oil.get_current_dir()
        if dir then return dir end
    end
    return vim.fn.expand('%:p:h')
end

-- Find the project root (nearest .git parent), fall back to cwd.
local function get_project_root()
    local dot_git = vim.fn.finddir('.git', '.;')
    if dot_git ~= '' then
        return vim.fn.fnamemodify(dot_git, ':h')
    end
    return vim.fn.getcwd()
end

-- Reusable find_files with directory navigation and hidden/ignore toggles.
-- `opts.cwd`        — starting directory
-- `opts.hidden`     — show dotfiles
-- `opts.use_ignore` — apply ignore_patterns (default true)
local function find_files(opts)
    opts = opts or {}
    local cwd = opts.cwd or get_current_dir()
    local hidden = opts.hidden or false
    local use_ignore = opts.use_ignore ~= false -- default true

    local find_command = nil
    if hidden then
        find_command = { 'rg', '--files', '--hidden', '--no-ignore' }
        vim.list_extend(find_command, ignore_globs(use_ignore))
    end

    require('telescope.builtin').find_files({
        cwd = cwd,
        hidden = hidden,
        no_ignore = hidden,
        find_command = find_command,
        initial_mode = opts.initial_mode or 'insert',
        attach_mappings = function(prompt_bufnr, map)
            local action_state = require('telescope.actions.state')

            -- <C-h>: toggle hidden/dotfiles (ignore list still applies)
            map({ 'i', 'n' }, '<C-h>', function()
                local prompt = action_state.get_current_line()
                require('telescope.actions').close(prompt_bufnr)
                find_files({ cwd = cwd, hidden = not hidden, use_ignore = true, prompt = prompt })
            end)

            -- <C-a>: show ALL files (hidden on, ignore list off)
            map({ 'i', 'n' }, '<C-a>', function()
                local prompt = action_state.get_current_line()
                require('telescope.actions').close(prompt_bufnr)
                find_files({ cwd = cwd, hidden = true, use_ignore = not use_ignore, prompt = prompt })
            end)

            -- <C-g>: jump to git project root
            map({ 'i', 'n' }, '<C-g>', function()
                local prompt = action_state.get_current_line()
                require('telescope.actions').close(prompt_bufnr)
                find_files({ cwd = get_project_root(), hidden = hidden, use_ignore = use_ignore, prompt = prompt })
            end)

            -- - (normal mode): go up one directory, stay in normal mode
            map('n', '-', function()
                local prompt = action_state.get_current_line()
                require('telescope.actions').close(prompt_bufnr)
                find_files({
                    cwd = vim.fn.fnamemodify(cwd, ':h'),
                    hidden = hidden,
                    use_ignore = use_ignore,
                    prompt =
                        prompt,
                    initial_mode = 'normal'
                })
            end)

            return true
        end,
        default_text = opts.prompt or '',
    })
end

-- Reusable live_grep with directory navigation and hidden/ignore toggles.
local function live_grep(opts)
    opts = opts or {}
    local cwd = opts.cwd or get_current_dir()
    local hidden = opts.hidden or false
    local use_ignore = opts.use_ignore ~= false -- default true

    local vimgrep_arguments = {
        'rg', '--color=never', '--no-heading', '--with-filename',
        '--line-number', '--column', '--smart-case',
    }
    if hidden then
        table.insert(vimgrep_arguments, '--hidden')
        table.insert(vimgrep_arguments, '--no-ignore')
        vim.list_extend(vimgrep_arguments, ignore_globs(use_ignore))
    end

    require('telescope.builtin').live_grep({
        cwd = cwd,
        vimgrep_arguments = vimgrep_arguments,
        initial_mode = opts.initial_mode or 'insert',
        attach_mappings = function(prompt_bufnr, map)
            local action_state = require('telescope.actions.state')

            -- <C-h>: toggle hidden/dotfiles (ignore list still applies)
            map({ 'i', 'n' }, '<C-h>', function()
                local prompt = action_state.get_current_line()
                require('telescope.actions').close(prompt_bufnr)
                live_grep({ cwd = cwd, hidden = not hidden, use_ignore = true, prompt = prompt })
            end)

            -- <C-a>: show ALL files (hidden on, ignore list off)
            map({ 'i', 'n' }, '<C-a>', function()
                local prompt = action_state.get_current_line()
                require('telescope.actions').close(prompt_bufnr)
                live_grep({ cwd = cwd, hidden = true, use_ignore = not use_ignore, prompt = prompt })
            end)

            -- <C-g>: jump to git project root
            map({ 'i', 'n' }, '<C-g>', function()
                local prompt = action_state.get_current_line()
                require('telescope.actions').close(prompt_bufnr)
                live_grep({ cwd = get_project_root(), hidden = hidden, use_ignore = use_ignore, prompt = prompt })
            end)

            -- - (normal mode): go up one directory, stay in normal mode
            map('n', '-', function()
                local prompt = action_state.get_current_line()
                require('telescope.actions').close(prompt_bufnr)
                live_grep({
                    cwd = vim.fn.fnamemodify(cwd, ':h'),
                    hidden = hidden,
                    use_ignore = use_ignore,
                    prompt =
                        prompt,
                    initial_mode = 'normal'
                })
            end)

            return true
        end,
        default_text = opts.prompt or '',
    })
end

-- See `:help telescope.builtin`
local builtin = require 'telescope.builtin'
vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
vim.keymap.set('n', '<leader>sf', function() find_files() end, { desc = '[S]earch [F]iles' })
-- vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
-- vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
vim.keymap.set('n', '<leader>sg', function() live_grep() end, { desc = '[S]earch by [G]rep' })
vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
-- vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
-- vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })

vim.keymap.set('n', '<leader>si', function()
    find_files({ hidden = true })
end, { desc = "[S]earch files, including [I]gnored" })

-- Shortcut for searching your Neovim configuration files
vim.keymap.set('n', '<leader>sn', function()
    find_files({ cwd = vim.fn.stdpath 'config' })
end, { desc = '[S]earch [N]eovim files' })
