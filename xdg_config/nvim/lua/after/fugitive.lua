
-- Plugin: vim-fugituve
vim.api.nvim_set_keymap('n', ';m', ':Git mergetool<CR>',
                        {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', ';d', ':Git difftool<CR>',
                        {noremap = true, silent = true})

