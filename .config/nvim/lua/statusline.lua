vim.opt.statusline = "%!v:lua.GetStatusLine()"
vim.opt.showmode = false
vim.opt.showcmd = false
vim.opt.ruler = false

function GetStatusLine()
	local mode_map = {
		n = "NOR",
		i = "INS",
		v = "VIS",
		V = "V-L",
		[""] = "V-B",
		R = "REP",
		c = "CMD",
	}
	local mode = string.format(" %s", mode_map[vim.fn.mode()] or vim.fn.mode())
	local clients = {}
	for _, client in ipairs(vim.lsp.get_clients({ bufnr = vim.api.nvim_get_current_buf() })) do
		table.insert(clients, client.name)
	end
	local lsp_status = #clients > 0 and table.concat(clients, ", ") or ""

	local parts = {
		mode,
		" ",
		"%F", -- Full File Path
		"%r", -- Readonly Flag
		"%m", -- Modified Flag
		"%=", -- Separator
		lsp_status,
		"",
	}

	return table.concat(parts, " ")
end
