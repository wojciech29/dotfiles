vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.opt.termguicolors = true
vim.opt.number = true
vim.opt.relativenumber = true
-- vim.opt.laststatus = 0
vim.opt.showmode = false
vim.opt.mouse = "a" -- "a" is all modes, "n" is normal mode only
vim.opt.clipboard = "unnamedplus" -- Sync clipboard between OS and Neovim.
vim.opt.breakindent = true
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undofile = true
vim.opt.ignorecase = true
vim.opt.signcolumn = "yes"
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.smartcase = true
vim.opt.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }
vim.opt.inccommand = "split"
vim.opt.cursorline = false
vim.opt.scrolloff = 8
vim.opt.incsearch = true
vim.opt.hlsearch = true
vim.opt.splitright = true
vim.opt.splitbelow = true

vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")
vim.keymap.set("n", "<leader>rw", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = "[R]eplace [W]ord" })

-- Move lines up and down in visual mode
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- Navigation keymaps
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")
vim.keymap.set("n", "<C-k>", "<cmd>b#<CR>")

vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank({
			timeout = 200,
		})
	end,
})

-- vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI", "FocusGained" }, {
-- 	command = "if mode() != 'c' | checktime | endif",
-- 	pattern = { "*" },
-- })
--
-- local tmuxIntegrationGroup = vim.api.nvim_create_augroup("TmuxIntegration", { clear = true })
-- local function update_tmux_title()
-- 	if vim.env.TMUX then
-- 		local filename = vim.fn.expand("%:t")
-- 		if filename ~= "" then
-- 			if vim.bo.modified then
-- 				filename = filename .. "*"
-- 			end
-- 			vim.fn.system("tmux rename-window " .. vim.fn.shellescape(filename))
-- 		end
-- 	end
-- end
--
-- vim.api.nvim_create_autocmd({
-- 	"BufEnter",
-- 	"BufNewFile",
-- 	"TextChanged",
-- 	"TextChangedI",
-- 	"BufWritePost",
-- }, {
-- 	group = tmuxIntegrationGroup,
-- 	callback = update_tmux_title,
-- })
--
-- vim.api.nvim_create_autocmd({ "VimLeave" }, {
-- 	group = tmuxIntegrationGroup,
-- 	callback = function()
-- 		if vim.env.TMUX then
-- 			vim.fn.system("tmux set-window-option automatic-rename on")
-- 		end
-- 	end,
-- })

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"--branch=stable",
		lazyrepo,
		lazypath,
	})
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	{ -- Useful plugin to show you pending keybinds.
		"folke/which-key.nvim",
		event = "VimEnter", -- Sets the loading event to 'VimEnter' (loads which-key before all the UI elements are loaded)
		config = function() -- This is the function that runs, AFTER loading
			require("which-key").setup()
		end,
	},
	{
		"rmagatti/auto-session",
		config = function()
			require("auto-session").setup({
				log_level = "error",
			})
		end,
	},
	"tpope/vim-sleuth", -- Detect tabstop and shiftwidth automatically
	{
		"ggandor/leap.nvim", -- Jump to any file, function, or line in your project
		config = function()
			require("leap").create_default_mappings()
			require("leap.user").set_repeat_keys("<enter>", "<backspace>")
		end,
	},
	"github/copilot.vim",
	{
		"stevearc/conform.nvim",
		opts = {
			notify_on_error = false,
			format_on_save = {
				timeout_ms = 500,
				lsp_fallback = false,
			},
			formatters_by_ft = {
				lua = { "stylua" },
				python = { "ruff_fix", "ruff_format" },
				rust = { "rustfmt" },
			},
		},
	},
	{
		"folke/noice.nvim",
		event = "VeryLazy",
		opts = {},
		dependencies = {
			"MunifTanjim/nui.nvim",
			"rcarriga/nvim-notify",
		},
	},
	{ import = "plugins" },
})

local wk = require("which-key")
wk.add({
	{ "<leader>c", group = "[C]ode" },
	{ "<leader>d", group = "[D]iagnostic" },
	{ "<leader>f", group = "[F]ind" },
	{ "<leader>r", group = "[R]ename" },
})
