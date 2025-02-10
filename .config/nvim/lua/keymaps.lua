local M = {}

function M.setup()
	local map = vim.keymap.set -- Shorten function for cleaner mappings

	-- Clear highlights on search when pressing <Esc> in normal mode
	map("n", "<Esc>", "<cmd>nohlsearch<CR>")

	-- Telescope & Oil
	map("n", "<leader>f", "<Cmd>Telescope frecency workspace=CWD<CR>", { desc = "Open file picker" })
	map("n", "<leader>F", "<Cmd>Oil --preview<CR>", { desc = "Open file explorer" })
	map("n", "<leader>g", "<Cmd>Telescope live_grep_args<CR>", { desc = "Open grep search" })
	map("n", "<leader>G", function()
		vim.cmd("Telescope live_grep_args default_text=" .. '"' .. vim.fn.expand("<cword>") .. '"')
	end, { desc = "Open grep search for word under cursor" })
	map("n", "<leader>?", "<Cmd>Telescope help_tags<CR>", { desc = "Open help" })
	map("n", "<leader>d", "<Cmd>Telescope diagnostics<CR>", { desc = "Open diagnostics" })
	map("n", "<leader>r", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gc<Left><Left><Left>]], { desc = "Replace current word" })

	-- Go to
	map("n", "gr", "<Cmd>Telescope lsp_references<CR>", { desc = "Go To references" })
	map("n", "gd", "<Cmd>Telescope lsp_definitions<CR>", { desc = "Go To definition" }) -- To jump back, press <C-T>
	map("n", "ga", "<Cmd>b#<CR>", { desc = "Go To previous file" })

	-- Navigation - centering the position
	map("n", "<C-d>", "<C-d>zz")
	map("n", "<C-u>", "<C-u>zz")
	map("n", "n", "nzzzv")
	map("n", "N", "Nzzzv")
end

return M
