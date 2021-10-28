local default_opts = {noremap = true, silent = true}
local trouble = require("trouble.providers.telescope")

require'telescope'.setup {
    defaults = {
        layout_strategy = "vertical",
        color_devicons = true,
        initial_mode = 'insert',
        mappings = {
            i = {["<c-q>"] = trouble.open_with_trouble},
            n = {["<c-q>"] = trouble.open_with_trouble}
        }
    },
    git_status = {initial_mode = "normal"}
}

vim.api
    .nvim_set_keymap('n', ';f', '<cmd>Telescope find_files<cr>', default_opts)
vim.api.nvim_set_keymap('n', ';g', '<cmd>Telescope live_grep<cr>', default_opts)
vim.api.nvim_set_keymap('n', ';b',
                        '<cmd>Telescope buffers initial_mode=normal<cr>',
                        default_opts)
vim.api.nvim_set_keymap('n', ';;', '<cmd>Telescope help_tags<cr>', default_opts)
vim.api.nvim_set_keymap('n', ';c', '<cmd>Telescope git_branches<cr>',
                        default_opts)
vim.api.nvim_set_keymap('n', ';j',
                        '<cmd>Telescope quickfix initial_mode=normal<cr>',
                        default_opts)
vim.api.nvim_set_keymap('n', ';s',
                        '<cmd>Telescope git_status initial_mode=normal<cr>',
                        default_opts)

