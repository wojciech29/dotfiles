-- Lua
vim.api.nvim_create_autocmd("FileType", {
	pattern = "lua",
	callback = function(ev)
		vim.lsp.start({
			name = "lua-language-server",
			cmd = { "lua-language-server" },
			root_dir = vim.fs.root(ev.buf, { ".luarc.json", ".luarc.jsonc" }),
			settings = {
				Lua = {
					runtime = {
						version = "LuaJIT",
					},
					workspace = {
						checkThirdParty = false,
						library = {
							vim.env.VIMRUNTIME,
						},
					},
				},
			},
		})

		vim.api.nvim_create_autocmd("BufWritePost", {
			callback = function()
				vim.cmd(":silent !stylua %")
			end,
		})
	end,
})

-- Python
vim.api.nvim_create_autocmd("FileType", {
	pattern = "python",
	callback = function(ev)
		local root_dir = vim.fs.root(ev.buf, { "pyproject.toml" })

		vim.lsp.start({
			name = "ruff",
			cmd = { "ruff", "server" },
			root_dir = root_dir,
		})

		vim.lsp.start({
			name = "pyright",
			cmd = { "pyright-langserver", "--stdio" },
			root_dir = root_dir,
		})

		-- Automatically fix and format on save
		vim.api.nvim_create_autocmd("BufWritePost", {
			pattern = "*.py",
			callback = function()
				vim.cmd(":silent !ruff check % --fix")
				vim.cmd(":silent !ruff format %")
			end,
		})
	end,
})
