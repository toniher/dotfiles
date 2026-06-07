local mason = require("user.lsp.mason")
require("user.lsp.handlers").setup()

return {
	enable_all_lsp_servers = mason.enable_all_lsp_servers,
}
