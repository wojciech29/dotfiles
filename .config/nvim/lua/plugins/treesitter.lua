return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	main = "nvim-treesitter.configs", -- Sets main module to use for opts
	opts = {
		ensure_installed = {
			"bash",
			"c",
			"css",
			"go",
			"htmldjango",
			"javascript",
			"json",
			"kotlin",
			"lua",
			"markdown",
			"python",
			"rust",
			"sql",
			"toml",
			"typescript",
			"xml",
			"yaml",
		},
		auto_install = true,
		highlight = { enable = true },
		indent = { disable = { "python" } },
	},
}
