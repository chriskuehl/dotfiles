-- Reference:
--   * https://neovim.io/doc/user/lua.html
--   * https://neovim.io/doc/user/api.html

-- Use lazy.nvim for plugins.
local lazypath = vim.fs.normalize("~/.dotfiles/nvim/lazy.nvim")
vim.opt.rtp:prepend(lazypath)
require("lazy").setup(
    {
        {
            "https://github.com/nvim-lualine/lualine.nvim",
            commit = "2248ef254d0a1488a72041cfb45ca9caada6d994",
        },
        {
            "https://github.com/preservim/nerdtree",
            commit = "9ec27d45a863aeb82fea56cebcb8a75a4e369fc9",
            priority = 50,
        },
        {
            "https://github.com/jistr/vim-nerdtree-tabs",
            commit = "07d19f0299762669c6f93fbadb8249da6ba9de62",
            priority = 60,
        },
        {
            "https://github.com/tpope/vim-fugitive",
            commit = "46eaf8918b347906789df296143117774e827616",
        },
        {
            "https://github.com/mhinz/vim-signify",
            commit = "7d538b77a5a8806e344b057f8846f6d0c035efa9",
        },
        {
            "https://github.com/junegunn/fzf",
            commit = "d21d5c9510170d74a7f959309da720b6df72ca01",
        },
        {
            "https://github.com/junegunn/fzf.vim",
            commit = "1e054c1d075d87903647db9320116d360eb8b024",
        },
    }
)

require("lualine").setup({
    options = {
        icons_enabled = false,
        component_separators = { left = '<', right = '>'},
        section_separators = { left = '<', right = '>'},
    }
})

-- Disable mouse.
vim.opt.mouse = ""

-- Don't warn about files already open.
vim.opt.shortmess:append("A")

vim.opt.termguicolors = true
vim.opt.number = true
vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.softtabstop = 4

-- Faster updatetime for async vim-signify.
vim.opt.updatetime = 100

-- Use visual bell instead of beeping when doing something wrong.
vim.opt.visualbell = true

-- Use case insensitive search, except when using capital letters.
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Tab movement.
vim.keymap.set('n', '<C-H>', 'gT')
vim.keymap.set('n', '<C-L>', 'gt')

-- Ctrl-C to disable highlighting.
vim.keymap.set('n', '<C-C>', ':nohl<CR><silent><C-C>')

-- Ctrl-J to split line.
vim.keymap.set('n', '<C-J>', 'i<CR><ESC>')

-- Disable Ctrl-A incrementing numbers.
vim.keymap.set('n', '<C-A>', '<Nop>')

-- Movement: default going by visual line in case of line wraps.
vim.keymap.set('n', 'j', 'gj')
vim.keymap.set('n', 'k', 'gk')

-- NERDTree
vim.keymap.set({'n', 'i'}, '<C-n>', '<ESC>:NERDTreeTabsToggle<CR>')

-- fzf
vim.keymap.set({'n', 'i'}, '<C-p>', '<ESC>:Files<CR>')

-- Highlight trailing whitespace
local ID_MATCH_EXTRA_WHITESPACE = 1000
vim.api.nvim_set_hl(0, 'ExtraWhitespace', { bg = 'orange1' })

vim.api.nvim_create_autocmd(
    {'BufWinEnter', 'InsertLeave'},
    {
        callback = function()
            pcall(vim.fn.matchdelete, ID_MATCH_EXTRA_WHITESPACE)
            vim.fn.matchadd('ExtraWhitespace', '\\s\\+$', 10, ID_MATCH_EXTRA_WHITESPACE)
        end,
    }
)
vim.api.nvim_create_autocmd(
    {'InsertEnter'},
    {
        callback = function()
            pcall(vim.fn.matchdelete, ID_MATCH_EXTRA_WHITESPACE)
            vim.fn.matchadd('ExtraWhitespace', '\\s\\+\\%#\\@<!$', 10, ID_MATCH_EXTRA_WHITESPACE)
        end,
    }
)
vim.api.nvim_create_autocmd(
    {'BufWinLeave'},
    {
        callback = function()
            pcall(vim.fn.matchdelete, ID_MATCH_EXTRA_WHITESPACE)
        end
    }
)

-- Highlight hard tabs
local ID_MATCH_HARD_TABS = 1001
vim.api.nvim_set_hl(0, 'HardTabs', { bg = 'coral1' })

vim.api.nvim_create_autocmd(
    {'BufWinEnter'},
    {
        callback = function()
            pcall(vim.fn.matchdelete, ID_MATCH_HARD_TABS)
            vim.fn.matchadd('HardTabs', '\\t', 10, ID_MATCH_HARD_TABS)
        end,
    }
)
vim.api.nvim_create_autocmd(
    {'BufWinLeave'},
    {
        callback = function()
            pcall(vim.fn.matchdelete, ID_MATCH_HARD_TABS)
        end
    }
)

-- Macros
vim.fn.setreg(
    'p',
    [[oimport pdb; pdb.set_trace()pass]]
)
vim.fn.setreg(
    'm',
    [[idef main() -> int | None:passif __name__ == '__main__':raise SystemExit(main())]]
)
