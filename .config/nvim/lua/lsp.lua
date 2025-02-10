---------
-- LUA --
---------
vim.api.nvim_create_autocmd("FileType", {
	pattern = "lua",
	callback = function(ev)
		local root_dir = vim.fs.root(ev.buf, { ".stylua.toml", "stylua.toml", ".git" }) or vim.uv.cwd()
		vim.lsp.start({
			name = "lua-language-server",
			cmd = { "lua-language-server" },
			root_dir = root_dir,
			settings = {
				Lua = {
					runtime = {
						version = "LuaJIT",
					},
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
	callback = function()
		vim.cmd(":silent !stylua %")
	end,
})

------------
-- PYTHON --
------------
vim.api.nvim_create_autocmd("FileType", {
	pattern = "python",
	callback = function(ev)
		local root_dir = vim.fs.root(ev.buf, { "pyproject.toml", ".git" }) or vim.uv.cwd()

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
	pattern = "*.py",
	callback = function()
		vim.cmd(":silent !ruff check % --fix")
		vim.cmd(":silent !ruff format %")
	end,
})
