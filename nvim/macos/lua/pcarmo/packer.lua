-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
    -- Packer can manage itself
    use 'wbthomason/packer.nvim'
    use {
        'nvim-telescope/telescope.nvim', tag = '0.1.1',
        -- or                            , branch = '0.1.x',
        requires = { { 'nvim-lua/plenary.nvim' } }
    }
    use({
        'rose-pine/neovim',
        as = 'rose-pine',
        config = function()
            vim.cmd("colorscheme rose-pine")
        end
    })
    use("nvim-treesitter/nvim-treesitter", { run = ":TSUpdate" })
    use('nvim-treesitter/playground')
    use('thePrimeagen/harpoon')
    use('mbbill/undotree')
    use('tpope/vim-fugitive')
    use {
        'VonHeikemen/lsp-zero.nvim',
        branch = 'v2.x',
        requires = {
            -- LSP Support
            { 'neovim/nvim-lspconfig' }, -- Required
            {
                -- Optional
                'williamboman/mason.nvim',
                run = function()
                    pcall(vim.cmd, 'MasonUpdate')
                end,
            },
            { 'williamboman/mason-lspconfig.nvim' }, -- Optional

            -- Autocompletion
            { 'hrsh7th/nvim-cmp' },     -- Required
            { 'hrsh7th/cmp-nvim-lsp' }, -- Required
            { 'L3MON4D3/LuaSnip' },     -- Required
        }
    }
    use('kassio/neoterm')
    use('nvim-tree/nvim-tree.lua')
    use("nvim-tree/nvim-web-devicons")
    use("lukas-reineke/lsp-format.nvim")
    use("jiangmiao/auto-pairs")
    use("s1n7ax/nvim-terminal")
    use('mfussenegger/nvim-dap')
    use('rcarriga/nvim-dap-ui')
    use("ldelossa/nvim-dap-projects")
    use('leoluz/nvim-dap-go')
    use('norcalli/nvim-colorizer.lua')
end)
