local default_opts = {noremap = true, silent = true}

-- system copy
vim.api.nvim_set_keymap('v', '<C-c>', '"+y', default_opts)
