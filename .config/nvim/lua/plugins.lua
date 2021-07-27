return require('packer').startup(function()
    use 'wbthomason/packer.nvim'
    use 'nvim-lua/plenary.nvim'
    use 'nvim-lua/completion-nvim'
    use 'nvim-lua/popup.nvim'
    use 'ThePrimeagen/harpoon'
    use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate'}
    use 'easymotion/vim-easymotion'
    use 'chriskempson/base16-vim'
    use 'norcalli/nvim-base16.lua'
    use 'famiu/nvim-reload'
    use 'kyazdani42/nvim-web-devicons' 
    use 'kyazdani42/nvim-tree.lua'
    use 'karb94/neoscroll.nvim'
    use 'windwp/nvim-autopairs'
    use {
      'nvim-telescope/telescope.nvim',
      requires = {{'nvim-lua/popup.nvim'}, {'nvim-lua/plenary.nvim'}}
    }
    use 'junegunn/fzf'
    use 'junegunn/fzf.vim'
    use 'jvgrootveld/telescope-zoxide'
    use 'neovim/nvim-lspconfig'
    use 'kabouzeid/nvim-lspinstall'
    use 'nvim-lua/lsp-status.nvim'
    use 'b3nj5m1n/kommentary'
    use 'folke/which-key.nvim'
    use 'Pocco81/TrueZen.nvim'
    use 'navarasu/onedark.nvim'
    use 'justinmk/vim-sneak'
    use 'tpope/vim-surround'
    use {
        'lewis6991/gitsigns.nvim',
        requires = {
            'nvim-lua/plenary.nvim'
        }
    }
    use { 'neoclide/coc.nvim', branch = 'release' }
end)
