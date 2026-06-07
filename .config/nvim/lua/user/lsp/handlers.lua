local M = {}

local status_blink_ok, blink_lsp = pcall(require, "blink.cmp")

M.capabilities = vim.lsp.protocol.make_client_capabilities()
M.capabilities.textDocument.completion.completionItem.snippetSupport = true

if status_blink_ok then
	M.get_capabilities = function()
		local capabilities = vim.lsp.protocol.make_client_capabilities()
		-- capabilities["offsetEncoding"] = "utf-8"
		return blink_lsp.get_lsp_capabilities(capabilities)
	end

	M.get_cpp_capabilities = function()
		local capabilities = vim.lsp.protocol.make_client_capabilities()
		return blink_lsp.get_lsp_capabilities(capabilities)
	end
end

M.setup = function()

	local config = {
		virtual_text = false, -- disable virtual text
		signs = {
			text = {
				[vim.diagnostic.severity.ERROR] = "",
				[vim.diagnostic.severity.WARN]  = "",
				[vim.diagnostic.severity.HINT]  = "󰛵",
				[vim.diagnostic.severity.INFO]  = "",
			},
		},
		update_in_insert = false,
		underline = true,
		severity_sort = true,
		float = {
			focusable = true,
			style = "minimal",
			border = "rounded",
			source = "always",
			header = "",
			prefix = "",
		},
	}

	vim.diagnostic.config(config)
end

M.on_attach = function(client, bufnr)
	if client.name == "tsserver" then
		client.server_capabilities.documentFormattingProvider = false
	end

	if client.name == "lua_ls" then
		client.server_capabilities.documentFormattingProvider = false
	end

	local status_ok, illuminate = pcall(require, "illuminate")
	if not status_ok then
		return
	end
	illuminate.on_attach(client)
end

return M
