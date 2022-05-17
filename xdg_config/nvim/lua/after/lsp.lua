local nvim_lsp = require('lspconfig')
local configs = require('lspconfig/configs')
local util = require('lspconfig/util')
local path = util.path

local common_on_attach = function()
    local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(0, ...) end
    local function buf_set_option(...) vim.api.nvim_buf_set_option(0, ...) end

    -- Enable completion triggered by <c-x><c-o>
    buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

    -- Mappings.
    local opts = {noremap = true, silent = true}

    -- See `:help vim.lsp.*` for documentation on any of the below functions
    buf_set_keymap('n', 'gD', '', {callback = vim.lsp.buf.declaration})
    -- buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
    buf_set_keymap('n', 'gd', '', {callback = vim.lsp.buf.definition})
    -- buf_set_keymap('n', 'gd', '<cmd>Trouble lsp_definitions<CR>', opts)
    buf_set_keymap('n', 'K', '', {callback = vim.lsp.buf.hover})
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
                   '<cmd>lua vim.diagnostic.open_float(0, { scope = "line", border = "single" })<CR>',
                   opts)
    buf_set_keymap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
    buf_set_keymap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
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

        -- diagnostics
        -- filter_out_diagnostics_by_severity = {"hint"},
        -- filter_out_diagnostics_by_code = {80001},

        -- formatting
        enable_formatting = true,
        formatter = "prettier",
        formatter_opts = {},

        -- update imports on file move
        update_imports_on_move = false
    }

    common_on_attach()

    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>lo', ':TSLspOrganize<CR>',
                                {noremap = true, silent = true})
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>ia', ':TSLspImportAll<CR>',
                                {noremap = true, silent = true})
end

local function get_python_path(workspace)
    -- Use activated virtualenv.
    if vim.env.VIRTUAL_ENV then
        return path.join(vim.env.VIRTUAL_ENV, 'bin', 'python')
    end

    -- Find and use virtualenv in workspace directory.
    for _, pattern in ipairs({'*', '.*'}) do
        local match = vim.fn.glob(path.join(workspace, pattern, 'pyvenv.cfg'))
        if match ~= '' then
            return path.join(path.dirname(match), 'bin', 'python')
        end
    end

    -- Fallback to system Python.
    return exepath('python3') or exepath('python') or 'python'
end

nvim_lsp.pyright.setup {
    on_attach = on_attach_python,
    flags = {debounce_text_changes = 150},
    before_init = function(_, config)
        config.settings.python.pythonPath = get_python_path(config.root_dir)
    end
}

nvim_lsp.gopls.setup {
    on_attach = on_attach_gopls,
    flags = {debounce_text_changes = 150}
}

local null_ls = require("null-ls")
local api = vim.api

null_ls.setup({
    sources = {
        -- For my typescript development 
        require("null-ls").builtins.formatting.prettier,
        require("null-ls").builtins.diagnostics.eslint_d,
        require("null-ls").builtins.code_actions.eslint_d
    }
})

nvim_lsp.tsserver.setup {
    on_attach = on_attach_tsserver,
    flags = {debounce_text_changes = 150},
    capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol
                                                                   .make_client_capabilities())
}

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

nvim_lsp.csharp_ls.setup({
    on_attach = on_attach,
})

require'lspconfig'.yamlls.setup {
    settings = {
        yaml = {
            schemas = {
                ["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*",
                ["../path/relative/to/file.yml"] = "/.github/workflows/*",
                ["/path/from/root/of/project"] = "/.github/workflows/*",
                ["https://raw.githubusercontent.com/instrumenta/kubernetes-json-schema/master/v1.18.0-standalone-strict/all.json"] = "/*.k8s.yaml"
            }
        }
    }
}

