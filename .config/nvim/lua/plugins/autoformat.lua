return {
	"stevearc/conform.nvim",
	event = { "BufWritePre" },
	cmd = { "ConformInfo" },
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
}
