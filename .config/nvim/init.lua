vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.opt.termguicolors = true
vim.opt.swapfile = false
vim.opt.undofile = true
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300

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

require("lazy").setup("plugins")
require("autocommands")
require("lsp")
require("keymaps")
