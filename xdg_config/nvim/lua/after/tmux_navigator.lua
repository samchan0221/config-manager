local default_opts = {noremap = true, silent = true}

vim.api.nvim_set_keymap('n', '<C-h>', '<cmd>TmuxNavigateLeft<cr>', default_opts)
vim.api
    .nvim_set_keymap('n', '<C-l>', '<cmd>TmuxNavigateRight<cr>', default_opts)
vim.api.nvim_set_keymap('n', '<C-j>', '<cmd>TmuxNavigateDown<cr>', default_opts)
vim.api.nvim_set_keymap('n', '<C-k>', '<cmd>TmuxNavigateUp<cr>', default_opts)

