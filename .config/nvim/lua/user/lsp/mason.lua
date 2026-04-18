local languagetool_apikey = vim.fn.getenv("LANGUAGETOOL_APIKEY")
if not languagetool_apikey == "" then
	languagetool_apikey = "" -- or leave as nil, or handle as needed
end
local languagetool_username = vim.fn.getenv("LANGUAGETOOL_USERNAME")
if not languagetool_username == "" then
	languagetool_username = "" -- or leave as nil, or handle as needed
end
local languagetool_server = vim.fn.getenv("LANGUAGETOOL_SERVER")
if not languagetool_server == "" then
	languagetool_server = "" -- or leave as nil, or handle as needed
end

local servers = {
	"bashls",
	"cssls",
	"docker_compose_language_service",
	"dockerls",
	"html",
	"jdtls",
	"jsonls",
	"lua_ls",
	"nextflow_ls",
	"perlnavigator",
	"ruff",
	"rust_analyzer",
	"taplo",
	"terraformls",
	"ts_ls",
	"ty",
	"typos_lsp",
	"yamlls",
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
	"harper-ls",
	"html-lsp",
	"json-lsp",
	"lua-language-server",
	"ltex-ls-plus",
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
	"ty",
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

-- Toggle an LSP server on demand for the current buffer
local function toggle_lsp(server)
	local bufnr = vim.api.nvim_get_current_buf()
	local clients = vim.lsp.get_clients({ name = server, bufnr = bufnr })
	if #clients > 0 then
		for _, client in ipairs(clients) do
			client.stop(true)
		end
		if vim.lsp.disable then
			vim.lsp.disable(server)
		end
		return
	end
	local opts = {
		on_attach = require("user.lsp.handlers").on_attach,
		capabilities = require("user.lsp.handlers").capabilities,
	}
	local ok, conf_opts = pcall(require, "user.lsp.settings." .. server)
	if ok then
		opts = vim.tbl_deep_extend("force", conf_opts, opts)
	end
	vim.lsp.config(server, opts)
	vim.lsp.enable(server)
	vim.lsp.start(vim.tbl_extend("force", opts, { name = server }), { bufnr = bufnr })
end

vim.api.nvim_create_user_command("HarperLS", function()
	toggle_lsp("harper_ls")
end, {})
vim.api.nvim_create_user_command("LtexLS", function()
	toggle_lsp("ltex_plus")
end, {})

-- Command to enable LtexLS with a specific language (e.g., :LtexLSLang ca-ES)
local function enable_ltex_with_language(lang)
	local bufnr = vim.api.nvim_get_current_buf()
	local opts = {
		on_attach = require("user.lsp.handlers").on_attach,
		capabilities = require("user.lsp.handlers").capabilities,
		settings = {
			ltex = {
				language = lang,
				languageToolHttpServerUri = languagetool_server,
				languageToolOrg = {
					username = languagetool_username,
					apiKey = languagetool_apikey,
				},
			},
		},
	}
	-- Stop any running ltex clients for this buffer
	for _, client in ipairs(vim.lsp.get_clients({ name = "ltex_plus", bufnr = bufnr })) do
		client.stop(true)
	end
	vim.lsp.config("ltex_plus", opts)
	vim.lsp.enable("ltex_plus")
	vim.lsp.start(vim.tbl_extend("force", opts, { name = "ltex_plus" }), { bufnr = bufnr })
end

vim.api.nvim_create_user_command("LtexLSLang", function(params)
	enable_ltex_with_language(params.args)
end, {
	nargs = 1,
	complete = function()
		return { "en-US", "en-GB", "es", "ca-ES", "fr", "de", "ro-RO" }
	end,
})

require("java").setup({
	-- load java test plugins
	-- lombok = {
	-- 	enable = false,
	-- 	version = "1.18.40",
	-- },
	-- jdtls = {
	-- 	version = "v1.43.0",
	-- },
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

-- Function to enable all LSP servers listed in servers
local function enable_all_lsp_servers()
	for _, server in ipairs(servers) do
		local name = vim.split(server, "@")[1]
		pcall(vim.lsp.enable, name)
	end
end

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

return {
	enable_all_lsp_servers = enable_all_lsp_servers,
}
