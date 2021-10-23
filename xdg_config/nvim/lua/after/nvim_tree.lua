require'nvim-tree'.setup {
    view = {auto_resize = true, side = 'top', height = 10}
}

vim.api.nvim_set_keymap('n', '<leader>f', ':NvimTreeToggle<CR>',
                        {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<leader>F', ':NvimTreeFindFile<CR>',
                        {noremap = true, silent = true})

