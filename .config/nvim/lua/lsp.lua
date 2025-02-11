local function get_root_dir(buf, markers)
	markers = markers or {}
	if not vim.tbl_contains(markers, ".git") then
		table.insert(markers, ".git")
	end
	return vim.fs.root(buf, markers) or vim.uv.cwd()
end

---------
-- LUA --
---------
vim.api.nvim_create_augroup("LuaLSP", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
	group = "LuaLSP",
	pattern = "lua",
	callback = function(ev)
		vim.lsp.start({
			name = "lua-language-server",
			cmd = { "lua-language-server" },
			root_dir = get_root_dir(ev.buf, { ".stylua.toml", "stylua.toml" }),
			settings = {
				Lua = {
					runtime = { version = "LuaJIT" },
					workspace = {
						checkThirdParty = false,
						library = {
							vim.env.VIMRUNTIME,
							"${3rd}/luv/library",
						},
					},
				},
			},
		})
	end,
})

vim.api.nvim_create_autocmd("BufWritePost", {
	group = "LuaLSP",
	callback = function()
		vim.cmd(":silent !stylua %")
	end,
})

------------
-- PYTHON --
------------
vim.api.nvim_create_augroup("PythonLSP", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
	group = "PythonLSP",
	pattern = "python",
	callback = function(ev)
		local root_dir = get_root_dir(ev.buf, { "pyproject.toml" })

		vim.lsp.start({
			name = "ruff",
			cmd = { "ruff", "server" },
			root_dir = root_dir,
		})

		vim.lsp.start({
			name = "pyright",
			cmd = { "pyright-langserver", "--stdio" },
			root_dir = root_dir,
			single_file_support = true,
			settings = {
				pyright = {
					-- Using Ruff's import organizer
					disableOrganizeImports = true,
				},
				python = {
					analysis = {
						ignore = { "*" },
					},
				},
			},
		})
	end,
})

vim.api.nvim_create_autocmd("BufWritePost", {
	group = "PythonLSP",
	pattern = "*.py",
	callback = function()
		vim.cmd(":silent !ruff check % --fix")
		vim.cmd(":silent !ruff format %")
	end,
})

---------
-- NIX --
---------
vim.api.nvim_create_augroup("NixLSP", { clear = true })
vim.api.nvim_create_autocmd("BufWritePost", {
	group = "NixLSP",
	pattern = "*.nix",
	callback = function()
		vim.cmd(":silent !nixfmt %")
	end,
})

---------
-- SQL --
---------
vim.api.nvim_create_augroup("SqlLSP", { clear = true })
vim.api.nvim_create_autocmd("BufWritePost", {
	group = "SqlLSP",
	pattern = "*.sql",
	callback = function()
		vim.cmd(":silent !sqruff fix --force %")
	end,
})
