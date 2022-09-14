local default_opts = {noremap = true, silent = true}

-- system copy
vim.api.nvim_set_keymap('v', '<C-c>', '"+y', default_opts)

-- moving line up and down
vim.api.nvim_set_keymap('v', '<C-k>', ':m-2<CR>', {noremap = true, silent = false})
vim.api.nvim_set_keymap('v', '<C-j>', ':m+', default_opts)

-- cf
function _run()
  vim.api.nvim_command('!gcc % -lstdc++ -lm -o main && ./main')
end
vim.api.nvim_set_keymap('n', '<leader><space><space>', "", {callback = _run})
