local Terminal = require('toggleterm.terminal').Terminal
local lazygit = Terminal:new({
    cmd = "lazygit",
    hidden = true,
    direction = "float"
})

function _lazygit_toggle() lazygit:toggle() end

vim.api.nvim_set_keymap("n", "<leader>g", "", {callback = _lazygit_toggle})

