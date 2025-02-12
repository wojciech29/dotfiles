return {
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
			view_options = { show_hidden = true },
		},
		lazy = false,
	},

	-- Colorscheme
	{
		"rebelot/kanagawa.nvim",
		opts = {
			colors = {
				theme = {
					all = {
						ui = { bg_gutter = "none" },
					},
				},
			},
		},
		config = function()
			vim.cmd.colorscheme("kanagawa")
		end,
	},

	-- Which-key
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		opts = {
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
		},
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
			context = { enable = true },
		},
	},

	-- Telescope
	{
		"nvim-telescope/telescope.nvim",
		event = "VimEnter",
		branch = "master",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope-frecency.nvim",
			"nvim-telescope/telescope-live-grep-args.nvim",
		},
		config = function()
			local actions = require("telescope.actions")

			require("telescope").setup({
				defaults = {
					vimgrep_arguments = {
						"rg",
						"-L",
						"--hidden",
						"--color=never",
						"--no-heading",
						"--with-filename",
						"--line-number",
						"--column",
						"--smart-case",
					},
					get_status_text = function()
						return ""
					end,
					sorting_strategy = "ascending",
					prompt_title = false,
					results_title = false,
					preview_title = false,
					layout_config = {
						horizontal = {
							prompt_position = "top",
							preview_width = 0.5,
							results_width = 0.5,
							-- https://github.com/nvim-telescope/telescope.nvim/issues/2508#issuecomment-1650278179
							width = { padding = 0 },
							height = { padding = 0 },
							preview_cutoff = 120,
						},
					},
					file_ignore_patterns = {
						"node_modules",
						"__pycache__",
						".env/",
						"^backend/build/",
						"^backend/sphinxsearch/",
						"migrations-ddl",
						".idea",
						".git/",
						".ruff_cache",
						".mypy_cache",
						".gradle",
						"%.java",
						"%.jpg",
						"%.jpeg",
						"%.png",
						"%.jar",
						"%.gz",
						"%.bz2",
						"%.zip",
						"%.exe",
						"%.pdf",
						"ktlint",
					},
					mappings = {
						i = {
							["<esc>"] = actions.close,
							["<C-w>"] = actions.cycle_history_prev,
							["<C-S-w>"] = actions.cycle_history_next,
						},
					},
				},
				extensions = {
					frecency = {
						db_version = "v2",
						disable_devicons = true,
						show_filter_column = false,
						show_unindexed = true,
						max_timestamps = 50,
						sorting_strategy = "ascending",
						layout_strategy = "center",
						borderchars = {
							prompt = { "─", "│", " ", "│", "┌", "┐", "│", "│" },
							results = { "─", "│", "─", "│", "├", "┤", "┘", "└" },
						},
						previewer = false,
						layout_config = {
							horizontal = { prompt_position = "top" },
							width = 0.55,
							height = 0.45,
						},
					},
				},
			})

			pcall(require("telescope").load_extension, "live_grep_args")
			pcall(require("telescope").load_extension, "frecency")
		end,
	},
}
