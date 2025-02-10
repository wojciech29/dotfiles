vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.opt.termguicolors = true

-- Sync clipboard between OS and Neovim. Schedule the setting after `UiEnter` because it can increase startup-time.
vim.schedule(function()
	vim.opt.clipboard = "unnamedplus"
end)

-- Line numbers
vim.opt.number = true
vim.opt.relativenumber = true

-- Higlight only line number of active line
vim.opt.cursorline = true
vim.opt.cursorlineopt = "number"

-- Enable sign column -> show diagnostics as dots
vim.opt.signcolumn = "yes"
vim.fn.sign_define("DiagnosticSignError", { text = "" })
vim.fn.sign_define("DiagnosticSignWarn", { text = "" })
vim.fn.sign_define("DiagnosticSignHint", { text = "" })
vim.fn.sign_define("DiagnosticSignInfo", { text = "" })

-- Enable mouse mode, can be useful for resizing splits for example! - "a" is all modes, "n" is normal mode only
vim.opt.mouse = "a"

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Indents
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.smartindent = true
vim.opt.breakindent = true

vim.opt.undofile = true

vim.opt.updatetime = 250
vim.opt.timeoutlen = 300 -- Displays which-key popup sooner

-- Sets how neovim will display certain whitespace characters in the editor.
vim.opt.list = true
vim.opt.listchars = {
	tab = "» ",
	trail = "·",
	nbsp = "␣",
}

-- Preview substitutions live, as you type!
vim.opt.inccommand = "split"

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 8

-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Statusline config
local mode_map = {
	n = "NOR",
	i = "INS",
	v = "VIS",
	V = "V-L",
	[""] = "V-B",
	R = "REP",
	c = "CMD",
}
vim.opt.statusline = "%!v:lua.GetStatusLine()"
function GetStatusLine()
	return string.format(" %s   %%F %%r%%m", mode_map[vim.fn.mode()] or vim.fn.mode())
end
vim.opt.showmode = false
vim.opt.showcmd = false
vim.opt.ruler = false

-- Highlight when yanking
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank({
			timeout = 200,
		})
	end,
})

--------------------------------------------------------------------------------------------

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local out = vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"--branch=stable",
		"https://github.com/folke/lazy.nvim.git",
		lazypath,
	})
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	-- Detect tabstop and shiftwidth automatically
	"tpope/vim-sleuth",

	-- LSP diagnostics displayed in top-right corner
	{
		"dgagn/diagflow.nvim",
		event = "LspAttach",
		opts = {},
	},

	-- File explorer
	{
		"stevearc/oil.nvim",
		opts = {
			view_options = {
				show_hidden = true,
			},
		},
		lazy = false,
	},

	-- Colorscheme
	{
		"rebelot/kanagawa.nvim",
		config = function()
			require("kanagawa").setup({
				colors = {
					theme = {
						all = {
							ui = {
								bg_gutter = "none",
							},
						},
					},
				},
			})
			vim.cmd.colorscheme("kanagawa")
		end,
	},

	-- Which-key
	{
		"folke/which-key.nvim",
		event = "VimEnter", -- Sets the loading event to 'VimEnter'
		config = function() -- This is the function that runs, AFTER loading
			require("which-key").setup({
				preset = "helix",
				sort = { "manual" },
				colors = false,
				icons = {
					mappings = false,
					separator = " ",
					keys = {
						CR = "<CR>",
						Esc = "<Esc>",
						BS = "<BS>",
						Space = "<Space>",
						Tab = "<Tab>",
					},
				},
			})
		end,
	},

	-- Treesitter
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		main = "nvim-treesitter.configs", -- Sets main module to use for opts
		opts = {
			ensure_installed = {},
			auto_install = true,
			highlight = { enable = true },
			indent = { disable = { "python" } },
			context = {
				enable = true,
			},
		},
	},

	{ import = "plugins" },
})

require("lsp")
require("keymaps").setup()
