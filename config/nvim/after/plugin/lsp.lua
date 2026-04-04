-- LSP configuration for Neovim 0.12+
-- Uses native vim.lsp.config + vim.lsp.enable pattern
-- Completion is handled by built-in autocomplete (vim.o.autocomplete)

-- This is where you enable features that only work
-- if there is a language server active in the file
vim.api.nvim_create_autocmd('LspAttach', {
    desc = 'LSP actions',
    callback = function(event)
        local map = function(keys, func, desc, mode)
            mode = mode or 'n'
            vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
        end

        -- Jump to the definition of the word under your cursor.
        --  This is where a variable was first declared, or where a function is defined, etc.
        --  To jump back, press <C-t>.
        map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')

        -- Find references for the word under your cursor.
        map('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')

        -- Jump to the implementation of the word under your cursor.
        --  Useful when your language has ways of declaring types without an actual implementation.
        -- map('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')

        -- Jump to the type of the word under your cursor.
        --  Useful when you're not sure what type a variable is and you want to see
        --  the definition of its *type*, not where it was *defined*.
        -- map('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')

        -- Fuzzy find all the symbols in your current document.
        --  Symbols are things like variables, functions, types, etc.
        -- map('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')

        -- Fuzzy find all the symbols in your current workspace.
        --  Similar to document symbols, except searches over your entire project.
        -- map('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

        -- Rename the variable under your cursor.
        --  Most Language Servers support renaming across files, etc.
        -- map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')

        -- Execute a code action, usually your cursor needs to be on top of an error
        -- or a suggestion from your LSP for this to activate.
        -- map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction', { 'n', 'x' })

        -- WARN: This is not Goto Definition, this is Goto Declaration.
        --  For example, in C this would take you to the header.
        -- map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

        map('<leader>ff', vim.lsp.buf.format, '[F]ormat [F]ile')

        -- Neovim 0.12 built-in LSP keybindings (provided by default):
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

require('mason').setup({})
require('mason-lspconfig').setup({
    -- Replace the language servers listed here
    -- with the ones you want to install
    ensure_installed = { "lua_ls", "ts_ls", "eslint", "clangd", "ruff", "basedpyright", "rust_analyzer" },
    handlers = {
        function(server_name)
            vim.lsp.config(server_name, {})
        end,

        clangd = function()
            vim.lsp.config('clangd', {
                cmd = {
                    "clangd",
                    "--fallback-style=webkit"
                }
            })
       end,
    },
})

vim.lsp.config("sourcekit", {
    capabilities = {
        workspace = {
            didChangeWatchedFiles = {
                dynamicRegistration = true,
            },
        },
    },
})

-- vim.lsp.config("jedi_language_server", {})
