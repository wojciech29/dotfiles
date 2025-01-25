return { -- Useful plugin to show you pending keybinds.
	"folke/which-key.nvim",
	event = "VimEnter", -- Sets the loading event to 'VimEnter'
	config = function() -- This is the function that runs, AFTER loading
		local wk = require("which-key")
		wk.setup({
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
		wk.add({
			{ "<leader>f", "<Cmd>Telescope frecency workspace=CWD<CR>", desc = "Open file picker", mode = "n" },
			{
				"<leader>F",
				"<Cmd>Oil --preview<CR>",
				desc = "Open file explorer",
				mode = "n",
			},
			{ "<leader>g", "<Cmd>Telescope live_grep_args<CR>", desc = "Open grep search", mode = "n" },
			{
				"<leader>G",
				function()
					vim.cmd("Telescope live_grep_args default_text=" .. '"' .. vim.fn.expand("<cword>") .. '"')
				end,
				desc = "Open grep search for word under cursor",
				mode = "n",
			},
			{ "<leader>?", "<Cmd>Telescope help_tags<CR>", desc = "Open help", mode = "n" },
			{ "<leader>d", "<Cmd>Telescope diagnostics<CR>", desc = "Open diagnostics", mode = "n" },
			{
				"<leader>/",
				"<Cmd>Telescope current_buffer_fuzzy_find<CR>",
				desc = "Fuzzily search in current buffer",
				mode = "n",
			},
			{ "gr", "<Cmd>Telescope lsp_references<CR>", desc = "Goto references", mode = "n" },
			-- To jump back, press <C-T>.
			{ "gd", "<Cmd>Telescope lsp_definitions<CR>", desc = "Goto definition", mode = "n" },
			{ "ga", "<Cmd>b#<CR>", desc = "Goto previous file", mode = "n" },
			{
				"gs",
				function()
					require("treesitter-context").go_to_context(vim.v.count1)
				end,
				desc = "Goto start of context block",
				mode = "n",
			},
		})
	end,
}
