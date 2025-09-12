local servers = {
	"bashls",
	"cssls",
	"html",
	"jsonls",
	"ts_ls",
	"yamlls",
	"docker_compose_language_service",
	"dockerls",
	"lua_ls",
	"ltex",
	"nextflow_ls",
	"perlnavigator",
	"pyright",
	"ruff",
	"rust_analyzer",
	"terraformls",
	"taplo",
	"typos_lsp",
}

local ensure_installed = {
	"bash-debug-adapter",
	"clang-format",
	"css-lsp",
	"debugpy",
	"docker-compose-language-service",
	"dockerfile-language-server",
	"editorconfig-checker",
	"eslint_d",
	"google-java-format",
	"html-lsp",
	"json-lsp",
	"lua-language-server",
	"ltex-ls",
	"nextflow-language-server",
	"perlnavigator",
	"phpcs",
	"php-cs-fixer",
	"prettierd",
	"rstcheck",
	"ruff",
	"rust-analyzer",
	"selene",
	"shellcheck",
	"shfmt",
	"stylua",
	"taplo",
	"terraform-ls",
	"tflint",
	"typescript-language-server",
	"typos-lsp",
	"vale",
	"vim-language-server",
	"xmlformatter",
	"yaml-language-server",
}

local enable_php = true
local host_has_php = os.getenv("HOST_HAS_PHP")
if host_has_php == "0" then
	enable_php = false
end

if enable_php then
	table.insert(servers, "phpactor")
	table.insert(ensure_installed, "phpactor")
end

local mason_settings = {
	ui = {
		border = "none",
		icons = {
			package_installed = "✓",
			package_pending = "➜",
			package_uninstalled = "✗",
		},
		check_outdated_packages_on_open = false,
	},
	log_level = vim.log.levels.INFO,
	max_concurrent_installers = 3,
}

require("mason").setup(mason_settings)
require("mason-lspconfig").setup({
	ensure_installed = servers,
	automatic_enable = false,
	-- 	automatic_installation = true,
})

require("java").setup({
	-- load java test plugins
	jdtls = {
		version = "v1.43.0",
	},
	-- java_test = {
	-- 	enable = true,
	-- 	version = "0.43.1",
	-- },
	--
	-- spring_boot_tools = {
	-- 	enable = true,
	-- 	version = "1.59.0",
	-- },
})

local opts = {}

for _, server in pairs(servers) do
	opts = {
		on_attach = require("user.lsp.handlers").on_attach,
		capabilities = require("user.lsp.handlers").capabilities,
	}

	server = vim.split(server, "@")[1]

	local require_ok, conf_opts = pcall(require, "user.lsp.settings." .. server)
	if require_ok then
		opts = vim.tbl_deep_extend("force", conf_opts, opts)
	end
	vim.lsp.config(server, opts)
end
-- Required for nvim-java below
-- TODO: Needs to be handled
vim.lsp.config("jdtls", { autostart = false })
-- require("lspconfig").jdtls.setup({})

require("mason-tool-installer").setup({

	-- a list of all tools you want to ensure are installed upon
	-- start; they should be the names Mason uses for each tool
	ensure_installed = ensure_installed,

	-- if set to true this will check each tool for updates. If updates
	-- are available the tool will be updated. This setting does not
	-- affect :MasonToolsUpdate or :MasonToolsInstall.
	-- Default: false
	auto_update = false,

	-- automatically install / update on startup. If set to false nothing
	-- will happen on startup. You can use :MasonToolsInstall or
	-- :MasonToolsUpdate to install tools and check for updates.
	-- Default: true
	run_on_start = true,

	-- set a delay (in ms) before the installation starts. This is only
	-- effective if run_on_start is set to true.
	-- e.g.: 5000 = 5 second delay, 10000 = 10 second delay, etc...
	-- Default: 0
	start_delay = 3000, -- 3 second delay

	-- Only attempt to install if 'debounce_hours' number of hours has
	-- elapsed since the last time Neovim was started. This stores a
	-- timestamp in a file named stdpath('data')/mason-tool-installer-debounce.
	-- This is only relevant when you are using 'run_on_start'. It has no
	-- effect when running manually via ':MasonToolsInstall' etc....
	-- Default: nil
	debounce_hours = 5, -- at least 5 hours between attempts to install/update
})
