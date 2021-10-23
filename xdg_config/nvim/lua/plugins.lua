local execute = vim.api.nvim_command
local fn = vim.fn

local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'

if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({
        'git', 'clone', 'https://github.com/wbthomason/packer.nvim',
        install_path
    })
    execute 'packadd packer.nvim'
end

return require('packer').startup(function()
    use 'wbthomason/packer.nvim'

    use 'neovim/nvim-lspconfig'

    use 'christoomey/vim-tmux-navigator'

    use 'akinsho/toggleterm.nvim'

    use 'Yggdroot/indentLine'

    use "jose-elias-alvarez/null-ls.nvim"

    use 'jose-elias-alvarez/nvim-lsp-ts-utils'

    use 'windwp/nvim-ts-autotag'

    use 'JoosepAlviste/nvim-ts-context-commentstring'

    use 'norcalli/nvim-colorizer.lua'

    use {
        'hoob3rt/lualine.nvim',
        requires = {'kyazdani42/nvim-web-devicons', opt = true}
    }

    -- Completion
    use 'hrsh7th/nvim-cmp'
    use 'hrsh7th/cmp-buffer'
    use 'hrsh7th/cmp-nvim-lsp'
    use 'hrsh7th/cmp-nvim-lua'
    use 'hrsh7th/cmp-vsnip'
    use 'hrsh7th/vim-vsnip'

    use 'tpope/vim-commentary'
    use 'tpope/vim-fugitive'
    use 'tpope/vim-surround'

    use 'mhartington/formatter.nvim'

    use {'dracula/vim', as = 'dracula'}

    use 'fatih/vim-go'

    use {
        'nvim-treesitter/nvim-treesitter',
        branch = '0.5-compat',
        run = 'TSUpdate'
    }
    use 'nvim-treesitter/playground'

    use {'nvim-telescope/telescope.nvim', requires = 'nvim-lua/plenary.nvim'}

    use {'kyazdani42/nvim-tree.lua', requires = 'kyazdani42/nvim-web-devicons'}
end)

