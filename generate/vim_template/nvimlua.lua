-- lua config
vim.g.vim_bootstrap_editor = '{{.Editor}}'

-- Install packer
local install_path = vim.fn.stdpath 'data' .. '/site/pack/packer/start/packer.nvim'
local is_bootstrap = false
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
    is_bootstrap = true
    vim.fn.execute('!git clone https://github.com/wbthomason/packer.nvim ' .. install_path)
    vim.cmd.packadd 'packer.nvim'
end

require('packer').startup(function(use)
    -- Package manager
    use 'wbthomason/packer.nvim'

    if is_bootstrap then
        require('packer').sync()
    end
end)
