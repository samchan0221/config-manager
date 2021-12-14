local nvim_lsp = require('lspconfig')

local common_on_attach = function()
    local function buf_set_keymap(...)
        vim.api.nvim_buf_set_keymap(bufnr, ...)
    end
    local function buf_set_option(...)
        vim.api.nvim_buf_set_option(bufnr, ...)
    end

    -- Enable completion triggered by <c-x><c-o>
    buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

    -- Mappings.
    local opts = {noremap = true, silent = true}

    -- See `:help vim.lsp.*` for documentation on any of the below functions
    buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
    -- buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
    buf_set_keymap('n', 'gd', '<cmd>Trouble lsp_definitions<CR>', opts)
    buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
    buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
    buf_set_keymap('n', '<space>wa',
                   '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
    buf_set_keymap('n', '<space>wr',
                   '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
    buf_set_keymap('n', '<space>wl',
                   '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>',
                   opts)
    buf_set_keymap('n', '<space>D',
                   '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
    buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
    buf_set_keymap('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>',
                   opts)
    -- buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
    buf_set_keymap('n', 'gr', '<cmd>Trouble lsp_references<CR>', opts)
    buf_set_keymap('n', '<space>e',
                   '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>',
                   opts)
    buf_set_keymap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>',
                   opts)
    buf_set_keymap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>',
                   opts)
    buf_set_keymap('n', '<space>q',
                   '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
end

local on_attach_python = function(client, bufnr) common_on_attach() end
local on_attach_gopls = function(client, bufnr) common_on_attach() end
local on_attach_tsserver = function(client, bufnr)
    -- disable tsserver formatting if you plan on formatting via null-ls
    client.resolved_capabilities.document_formatting = false
    client.resolved_capabilities.document_range_formatting = false

    vim.lsp.handlers["textDocument/publishDiagnostics"] =
        vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
            -- delay update diagnostics
            update_in_insert = false
        })

    local ts_utils = require("nvim-lsp-ts-utils")

    ts_utils.setup {
        -- import all
        import_all_timeout = 5000, -- ms
        import_all_priorities = {
            buffers = 4, -- loaded buffer names
            buffer_content = 3, -- loaded buffer content
            local_files = 2, -- git files or files with relative path markers
            same_file = 1 -- add to existing import statement
        },
        import_all_scan_buffers = 100,
        import_all_select_source = false,

        -- formatting
        enable_formatting = true,
        formatter = "prettier",
        formatter_opts = {},

        -- update imports on file move
        update_imports_on_move = false
    }

    common_on_attach()

    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>ia', ':TSLspImportAll',
                                {noremap = true, silent = true})
end

nvim_lsp.pyright.setup {
    on_attach = on_attach_python,
    flags = {debounce_text_changes = 150}
}

nvim_lsp.gopls.setup {
    on_attach = on_attach_gopls,
    flags = {debounce_text_changes = 150}
}

local null_ls = require("null-ls")
local api = vim.api

null_ls.config({debug = true, source = {}})
nvim_lsp["null-ls"].setup({autostart = true})

nvim_lsp.tsserver.setup {
    on_attach = on_attach_tsserver,
    flags = {debounce_text_changes = 150},
    capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol
                                                                   .make_client_capabilities())
}

nvim_lsp.eslint.setup {}

nvim_lsp.efm.setup {
    init_options = {documentFormatting = true},
    settings = {
        rootMarkers = {".git/"},
        languages = {
            lua = {{formatCommand = "lua-format -i", formatStdin = true}},
            python = {
                {formatCommand = "isort -", formatStdin = true},
                {formatCommand = "black --quiet -", formatStdin = true}
            }
        }
    }
}

nvim_lsp.hls.setup {}

nvim_lsp.rust_analyzer.setup({
    on_attach = on_attach,
    settings = {
        ["rust-analyzer"] = {
            assist = {importGranularity = "module", importPrefix = "by_self"},
            cargo = {loadOutDirsFromCheck = true},
            procMacro = {enable = true}
        }
    }
})

