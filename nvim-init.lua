-- Reference:
--   * https://neovim.io/doc/user/lua.html
--   * https://neovim.io/doc/user/api.html

-- Use lazy.nvim for plugins.
local lazypath = vim.fs.normalize("~/.dotfiles/nvim/lazy.nvim")
vim.opt.rtp:prepend(lazypath)
local deps = {
    {
        "https://github.com/catppuccin/nvim",
        commit = "3aaf3ab60221bca8edb1354e41bd514a22c89de2",
        priority = 1000,
    },
    {
        "https://github.com/nvim-lualine/lualine.nvim",
        commit = "b8c23159c0161f4b89196f74ee3a6d02cdc3a955",
    },
    {
        "https://github.com/preservim/nerdtree",
        commit = "9b465acb2745beb988eff3c1e4aa75f349738230",
        priority = 50,
    },
    {
        "https://github.com/tpope/vim-fugitive",
        commit = "61b51c09b7c9ce04e821f6cf76ea4f6f903e3cf4",
    },
    {
        "https://github.com/mhinz/vim-signify",
        commit = "54346382be614ef5934cbbe204fd58ba3247a84d",
    },
    {
        "https://github.com/junegunn/fzf",
        commit = "978b6254c71a8b71d0ad0e58bee74c70a53c1345",
    },
    {
        "https://github.com/junegunn/fzf.vim",
        commit = "3725f364ccd25b85a91970720ba9bc2931861910",
    },
    {
        "https://github.com/neovim/nvim-lspconfig",
        commit = "45ff1914044de7dbd4cd85053dc09f47312a2f4d",
    },
    {
        "https://github.com/rodjek/vim-puppet",
        commit = "10bf0b27c5be81ee26c3a0d32e39b270f95329ce",
    },
    {
        "https://github.com/pangloss/vim-javascript",
        commit = "b26c9edb3563e02f5c0b20580f7cf9743e95b157",
    },
    {
        "https://github.com/Glench/Vim-Jinja2-Syntax",
        commit = "2c17843b074b06a835f88587e1023ceff7e2c7d1",
    },
    {
        "https://github.com/nfnty/vim-nftables",
        commit = "26f8a506c6f3e41f1e4a8d6aa94c9a79a666bbff",
    },
    {
        "https://github.com/pmizio/typescript-tools.nvim",
        commit = "3c501d7c7f79457932a8750a2a1476a004c5c1a9",
        dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
    },
    {
        "https://github.com/varnishcache-friends/vim-varnish",
        commit = "01458458f20831d43045423344bcb70a40d04b0f",
    },
    {
        "https://github.com/hashivim/vim-terraform",
        commit = "520498fab16a3a11f2ae1b8cb65e0a1684bc317a",
    },
    {
        "https://github.com/famiu/bufdelete.nvim.git",
        commit = "f6bcea78afb3060b198125256f897040538bcb8",
    },
    {
        "https://github.com/preservim/vim-markdown",
        commit = "8f6cb3a6ca4e3b6bcda0730145a0b700f3481b51",
    },
}
if os.getenv("COPILOT") == "1" then
    deps[#deps + 1] = {
        "https://github.com/github/copilot.vim.git",
        commit = "5015939f131627a6a332c9e3ecad9a7cb4c2e549",
    }
end
require("lazy").setup(deps)

vim.keymap.set("n", "<Space>", "<Nop>", { silent = true, remap = false })
vim.g.mapleader = " "

require("catppuccin").setup({
    transparent_background = true,
    styles = {
        comments = {"bold"},
        conditionals = {},
    },
})

vim.cmd.colorscheme("catppuccin-frappe")

local lualine_theme = require("lualine.themes.catppuccin")
lualine_theme.normal.c.bg = "#323545"
for k, v in pairs(lualine_theme.inactive) do
    v["bg"] = lualine_theme.normal.c.bg
end

require("lualine").setup({
    options = {
        theme = lualine_theme,
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
    tabline = {
        lualine_a = {
            {
                'buffers',
                show_filename_only = true,   -- Shows shortened relative path when set to false.
                hide_filename_extension = false,   -- Hide filename extension when set to true.
                show_modified_status = true, -- Shows indicator when the buffer is modified.

                mode = 0, -- 0: Shows buffer name
                -- 1: Shows buffer index
                -- 2: Shows buffer name + buffer index
                -- 3: Shows buffer number
                -- 4: Shows buffer name + buffer number

                max_length = vim.o.columns, -- Maximum width of buffers component,
                -- it can also be a function that returns
                -- the value of `max_length` dynamically.
                filetype_names = {
                    TelescopePrompt = 'Telescope',
                    dashboard = 'Dashboard',
                    packer = 'Packer',
                    fzf = 'FZF',
                    alpha = 'Alpha',
                }, -- Shows specific buffer name for that filetype ( { `filetype` = `buffer_name`, ... } )

                -- Automatically updates active buffer color to match color of other components (will be overidden if buffers_color is set)
                use_mode_colors = true,

                buffers_color = {
                    -- Same values as the general color option can be used here.
                    -- active = 'lualine_{section}_normal',     -- Color for active buffer.
                    -- inactive = 'lualine_{section}_inactive', -- Color for inactive buffer.
                },

                symbols = {
                    modified = ' ●',      -- Text to show when the buffer is modified
                    alternate_file = '#', -- Text to show to identify the alternate file
                    directory =  '',     -- Text to show when the buffer is a directory
                },
            }
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
vim.g.editorconfig = false
vim.opt.foldenable = false

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

-- Buffer movement.
vim.keymap.set('n', '<C-H>', ':bp<CR>')
vim.keymap.set('n', '<C-L>', ':bn<CR>')

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
vim.keymap.set({'n', 'i'}, '<C-n>', '<ESC>:NERDTreeToggle<CR>')

-- fzf
vim.keymap.set({'n', 'i'}, '<C-p>', '<ESC>:Files<CR>')
vim.keymap.set({'n', 'i'}, '<C-s>', '<ESC>:Rg<CR>')
vim.keymap.set({'n'}, '<tab>', '<ESC>:Buffers<CR>')

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
    'n',
    [[i#!/usr/bin/env -S uv run --script# /// script# requires-python = ">=3.13"# dependencies = []# ///def main() -> int | None:passif __name__ == '__main__':raise SystemExit(main())]]
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

-- TODO: figure out if there is a way to use the Ruff LSP which isn't really annoying
-- lspconfig.ruff.setup({})

require("typescript-tools").setup({
    settings = {
        jsx_close_tag = {
            enable = false,
        },
    },
})

-- Global mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
vim.keymap.set('n', '<Leader>e', vim.diagnostic.open_float)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<Leader>q', vim.diagnostic.setloclist)

local function toggle_wrap()
    if vim.opt.linebreak:get() == false then
        vim.opt.linebreak = true
        print("Line wrap enabled")
    else
        vim.opt.linebreak = false
        print("Line wrap disabled")
    end
end

vim.keymap.set('n', '<Leader>l', toggle_wrap)

local function toggle_copilot()
    -- vim.g.copilot_enabled is initially nil for some reason, so check `0` for disabled.
    if vim.g.copilot_enabled ~= 0 then
        vim.cmd.Copilot("disable")
        print("Copilot disabled for current buffer")
    else
        vim.cmd.Copilot("enable")
        print("Copilot enabled for current buffer")
    end
end
vim.keymap.set('n', '<Leader>p', toggle_copilot)

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
                if vim.bo.filetype == 'python' then
                     -- Python should never be auto-formatted.
                     -- TODO: maybe some way to turn this on per-buffer or per-project for projects that use Ruff?
                    return
                end

                -- vim.lsp can have { get_clients = nil } when only typescript
                -- is active for some reason.
                if vim.lsp.get_clients then
                    local clients = vim.lsp.get_clients({
                        bufnr = ev.buf,
                        method = "textDocument/formatting",
                    })
                    if #clients > 0 then
                        vim.lsp.buf.format({
                            id = clients[1].id,
                        })
                    end
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
    },
    pattern = {
        ['.*'] = {
            function(path, bufnr)
                local content = vim.api.nvim_buf_get_lines(bufnr, 0, 1, false)[1] or ''
                if vim.regex([[^#!.*\suv\s.*run]]):match_str(content) ~= nil then
                    return "python"
                end
            end,
        }
    },
})

vim.g.diagnostics_active = true
function _G.toggle_diagnostics()
    if vim.diagnostic.is_enabled() then
        vim.diagnostic.disable()
        print("Diagnostics disabled")
    else
        vim.diagnostic.enable()
        print("Diagnostics enabled")
    end
end

vim.api.nvim_set_keymap('n', '<leader>w', ':call v:lua.toggle_diagnostics()<CR>',  {noremap = true, silent = true})
