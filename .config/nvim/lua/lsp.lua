local function get_root_dir(buf, markers)
	markers = markers or {}
	if not vim.tbl_contains(markers, ".git") then
		table.insert(markers, ".git")
	end
	return vim.fs.root(buf, markers) or vim.uv.cwd()
end
vim.o.completeopt = "menu,noinsert,popup,fuzzy"
vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(ev)
		local client = assert(vim.lsp.get_client_by_id(ev.data.client_id))
		if client:supports_method("textDocument/completion") then
			vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
		end

		if client:supports_method("textDocument/inlayHint") then
			vim.keymap.set("n", "<leader>th", function()
				vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = ev.buf }))
			end, { buffer = ev.buf, desc = "LSP: " .. "[T]oggle Inlay [H]ints" })
		end
	end,
})
vim.lsp.config("*", {
	root_markers = { ".git" },
	capabilities = {
		textDocument = {
			semanticTokens = {
				multilineTokenSupport = true,
			},
		},
	},
})

---------
-- LUA --
---------
vim.lsp.config.luals = {
	cmd = { "lua-language-server" },
	root_markers = { ".stylua.toml", "stylua.toml" },
	filetypes = { "lua" },
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
}
vim.lsp.enable({ "luals" })
vim.api.nvim_create_augroup("LuaLSP", { clear = true })
vim.api.nvim_create_autocmd("BufWritePost", {
	group = "LuaLSP",
	pattern = "*.lua",
	callback = function()
		vim.cmd(":silent !stylua %")
	end,
})

------------
-- PYTHON --
------------
vim.lsp.config.ruff = {
	cmd = { "ruff", "server" },
	root_markers = { "pyproject.toml" },
	filetypes = { "python" },
}
vim.lsp.enable({ "ruff" })

vim.lsp.config.pyright = {
	cmd = { "pyright-langserver", "--stdio" },
	root_markers = { "pyproject.toml", "pyrightconfig.json" },
	filetypes = { "python" },
	settings = {
		pyright = {
			-- Using Ruff's import organizer
			disableOrganizeImports = true,
		},
		python = {
			analysis = {
				typeCheckingMode = "strict",
			},
		},
	},
}
vim.lsp.enable({ "pyright" })

vim.api.nvim_create_augroup("PythonLSP", { clear = true })
vim.api.nvim_create_autocmd("BufWritePost", {
	group = "PythonLSP",
	pattern = "*.py",
	callback = function()
		vim.cmd(":silent !ruff check % --fix")
		vim.cmd(":silent !ruff format %")
	end,
})

-----------------
-- Django HTML --
-----------------
vim.api.nvim_create_augroup("DjangoLSP", { clear = true })
vim.api.nvim_create_autocmd("BufWritePost", {
	group = "DjangoLSP",
	pattern = "*.html",
	callback = function()
		vim.cmd(":silent !djlint --reformat %")
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

----------
-- RUST --
----------
vim.api.nvim_create_augroup("RustLSP", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
	group = "RustLSP",
	pattern = "rust",
	callback = function(ev)
		vim.lsp.start({
			name = "rust-analyzer",
			cmd = { "rust-analyzer" },
			root_dir = get_root_dir(ev.buf, {}),
		})
	end,
})
