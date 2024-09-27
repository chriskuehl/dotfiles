-- Reference:
--   * https://neovim.io/doc/user/lua.html
--   * https://neovim.io/doc/user/api.html

-- Use lazy.nvim for plugins.
local lazypath = vim.fs.normalize("~/.dotfiles/nvim/lazy.nvim")
vim.opt.rtp:prepend(lazypath)
local deps = {
    {
        "https://github.com/catppuccin/nvim",
        commit = "c9e205fe035d622b3c2d66ee42edf368c0c31fd5",
        priority = 1000,
    },
    {
        "https://github.com/nvim-lualine/lualine.nvim",
        commit = "b431d228b7bbcdaea818bdc3e25b8cdbe861f056",
    },
    {
        "https://github.com/preservim/nerdtree",
        commit = "9b465acb2745beb988eff3c1e4aa75f349738230",
        priority = 50,
    },
    {
        "https://github.com/jistr/vim-nerdtree-tabs",
        commit = "07d19f0299762669c6f93fbadb8249da6ba9de62",
        priority = 60,
    },
    {
        "https://github.com/tpope/vim-fugitive",
        commit = "d4877e54cef67f5af4f950935b1ade19ed6b7370",
    },
    {
        "https://github.com/mhinz/vim-signify",
        commit = "8670143f9e12ed1cd3c9b2c54f345cdd9a4baac3",
    },
    {
        "https://github.com/junegunn/fzf",
        commit = "d21d5c9510170d74a7f959309da720b6df72ca01",
    },
    {
        "https://github.com/junegunn/fzf.vim",
        commit = "c5ce7908ee86af7d4090d2007086444afb6ec1c9",
    },
    {
        "https://github.com/neovim/nvim-lspconfig",
        commit = "056f569f71e4b726323b799b9cfacc53653bceb3",
    },
    {
        "https://github.com/rodjek/vim-puppet",
        commit = "10bf0b27c5be81ee26c3a0d32e39b270f95329ce",
    },
    {
        "https://github.com/pangloss/vim-javascript",
        commit = "c470ce1399a544fe587eab950f571c83cccfbbdc",
    },
    {
        "https://github.com/Glench/Vim-Jinja2-Syntax",
        commit = "2c17843b074b06a835f88587e1023ceff7e2c7d1",
    },
    {
        "https://github.com/nfnty/vim-nftables",
        commit = "26f8a506c6f3e41f1e4a8d6aa94c9a79a666bbff",
    },
}
if os.getenv("COPILOT") == "1" then
    deps[#deps + 1] = {
        "https://github.com/github/copilot.vim.git",
        commit = "782461159655b259cff10ecff05efa761e3d4764",
    }
end
require("lazy").setup(deps)

require("catppuccin").setup({
    transparent_background = true,
    styles = {
        comments = {"bold"},
        conditionals = {},
    },
})

vim.cmd.colorscheme("catppuccin-frappe")


require("lualine").setup({
    options = {
        theme = "catppuccin",
        icons_enabled = false,
        component_separators = { left = '<', right = '>'},
        section_separators = { left = '<', right = '>'},
    },
    sections = {
        lualine_c = {
            {
                'filename',
                -- Show full path relative to CWD.
                path = 1,
            },
        },
    },
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


-- Instead of failing a command because of unsaved changes, instead raise a
-- dialogue asking if you wish to save changed files.
vim.opt.confirm = true

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
vim.keymap.set({'n', 'i'}, '<C-s>', '<ESC>:Rg<CR>')
vim.keymap.set({'n', 'i'}, '<C-b>', '<ESC>:Buffers<CR>')

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
vim.fn.setreg(
	'e',
	[[oif err != nil {return ]]
)

-- LSP support; taken from https://github.com/neovim/nvim-lspconfig
-- Setup language servers.
local lspconfig = require('lspconfig')
-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#gopls
-- https://github.com/neovim/nvim-lspconfig/blob/master/lua/lspconfig/server_configurations/gopls.lua
-- https://github.com/golang/tools/blob/master/gopls/doc/vim.md#neovim-config
lspconfig.gopls.setup({
    settings = {
        gopls = {
            staticcheck = true,
        },
    },
})

-- Global mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist)

-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
local lsp_augroup = vim.api.nvim_create_augroup('UserLspConfig', {})
vim.api.nvim_create_autocmd('LspAttach', {
    group = lsp_augroup,
    callback = function(ev)
        -- Enable format-on-save.
        vim.api.nvim_clear_autocmds({ group = group, buffer = ev.buf })
        vim.api.nvim_create_autocmd("BufWritePre", {
            group = lsp_augroup,
            buffer = ev.buf,
            callback = function()
                local clients = vim.lsp.get_clients({
                    bufnr = ev.buf,
                    method = "textDocument/formatting",
                })
                if #clients > 0 then
                    vim.lsp.buf.format({
                        id = clients[1].id,
                    })
                end
            end,
        })

        -- Enable completion triggered by <c-x><c-o>
        vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

        -- Buffer local mappings.
        -- See `:help vim.lsp.*` for documentation on any of the below functions
        local opts = { buffer = ev.buf }
        vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
        vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
        vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
        vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
        vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
        vim.keymap.set('n', '<space>wl', function()
            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end, opts)
        vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
        vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
        vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, opts)
        vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
        vim.keymap.set('n', '<space>f', function()
            vim.lsp.buf.format { async = true }
        end, opts)
    end,
})

local function use_tabs()
    vim.opt_local.expandtab = false
    vim.api.nvim_set_hl(0, 'HardTabs', {})
end

vim.api.nvim_create_autocmd(
    "FileType",
    {
        pattern = "go",
        callback = function()
            vim.opt_local.textwidth = 99
            use_tabs()
        end,
    }
)

vim.filetype.add({
  extension = {
     -- Starlark, but close enough.
    star = 'python',
    tilt = 'python',
  }
})
