local github_mcp_token = vim.fn.getenv("GITHUB_MCP_TOKEN")
if not github_mcp_token == "" then
	github_mcp_token = "" -- or leave as nil, or handle as needed
end

local prompts_dirs = { vim.fn.stdpath("config") .. "/prompts/", vim.env.HOME .. "/soft/Fabric/data/patterns" }
local strategies_dirs = { vim.env.HOME .. "/soft/Fabric/data/strategies" }
local shared_opts = {
	modes = { "v", "n" },
	auto_submit = false,
	stop_context_insertion = true,
	user_prompt = false,
	ignore_system_prompt = true,
}
function make_prompt_library(name, system_prompt, user_prompt, is_code)
	-- TODO: Check this is_code
	is_code = is_code == nil and true or is_code
	return {
		strategy = "chat",
		description = name,
		opts = vim.tbl_extend("force", { short_name = name }, shared_opts),

		prompts = {
			{
				role = "system",
				content = system_prompt,
				opts = { contains_code = is_code },
			},
			{
				role = "user",
				content = user_prompt,
				opts = { contains_code = is_code },
			},
		},
	}
end
function get_prompt(file_path)
	local file = io.open(file_path, "r")
	if not file then
		return "", "Could not open file"
	end
	local prompt_text = file:read("*a") or ""
	file:close()
	return prompt_text
end

function user_content(prefix)
	return function(context)
		local text = require("codecompanion.helpers.actions").get_code(context.start_line, context.end_line)
		return prefix .. "\n\n```" .. context.filetype .. "\n" .. text .. "\n```\n\n"
	end
end

function retrieve_prompts(dirs)
	local prompt_libraries = {}
	for _, prompts_dir in ipairs(dirs) do
		-- Ensure trailing slash
		if not prompts_dir:match("/$") then
			prompts_dir = prompts_dir .. "/"
		end
		local entries = vim.fn.readdir(prompts_dir)
		for _, entry in ipairs(entries) do
			local full_path = prompts_dir .. entry
			if vim.fn.isdirectory(full_path) == 1 then
				local system_prompt = get_prompt(full_path .. "/system.md")
				local user_prompt = user_content(get_prompt(full_path .. "/user.md"))
				prompt_libraries[entry] = make_prompt_library(entry, system_prompt, user_prompt, nil)
			end
		end
	end
	return prompt_libraries
end

-- TODO: wrapper for strategies as well

return {
	{
		"Davidyz/VectorCode",
		version = "*", -- optional, depending on whether you're on nightly or release
		dependencies = { "nvim-lua/plenary.nvim" },
		cmd = "VectorCode", -- if you're lazy-loading VectorCode
		config = function()
			require("vectorcode").setup({})
		end,
	},
	{
		"olimorris/codecompanion.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
			"ravitemer/codecompanion-history.nvim",
		},
		config = function()
			require("codecompanion").setup({
				adapters = {
					http = {
						codellama = function()
							return require("codecompanion.adapters").extend("ollama", {
								name = "codellama", -- Give this adapter a different name to differentiate it from the default ollama adapter
								schema = {
									model = {
										default = "codellama:latest",
									},
									-- num_ctx = {
									-- 	default = 16384,
									-- },
									-- num_predict = {
									-- 	default = -1,
									-- },
								},
							})
						end,
					},
				},
				extensions = {
					history = {
						enabled = true,
						opts = {
							-- Keymap to open history from chat buffer (default: gh)
							keymap = "gh",
							-- Keymap to save the current chat manually (when auto_save is disabled)
							save_chat_keymap = "sc",
							-- Save all chats by default (disable to save only manually using 'sc')
							auto_save = true,
							-- Number of days after which chats are automatically deleted (0 to disable)
							expiration_days = 0,
							-- Picker interface (auto resolved to a valid picker)
							picker = "snacks", --- ("telescope", "snacks", "fzf-lua", or "default")
							-- Customize picker keymaps (optional)
							picker_keymaps = {
								rename = { n = "<C-R>" },
								delete = { n = "<C-D>" },
								duplicate = { n = "<C-Y>" },
							},
							---Automatically generate titles for new chats
							auto_generate_title = true,
							title_generation_opts = {
								---Adapter for generating titles (defaults to current chat adapter)
								adapter = nil, -- "copilot"
								---Model for generating titles (defaults to current chat model)
								model = nil, -- "gpt-4o"
								---Number of user prompts after which to refresh the title (0 to disable)
								refresh_every_n_prompts = 0, -- e.g., 3 to refresh after every 3rd user prompt
								---Maximum number of times to refresh the title (default: 3)
								max_refreshes = 3,
							},
							---On exiting and entering neovim, loads the last chat on opening chat
							continue_last_chat = false,
							---When chat is cleared with `gx` delete the chat from history
							delete_on_clearing_chat = false,
							---Directory path to save the chats
							dir_to_save = vim.fn.stdpath("data") .. "/codecompanion-history",
							---Enable detailed logging for history extension
							enable_logging = false,
							---Optional filter function to control which chats are shown when browsing
							chat_filter = nil, -- function(chat_data) return boolean end
						},
					},
					mcphub = {
						callback = "mcphub.extensions.codecompanion",
						opts = {
							show_result_in_chat = true, -- Show the mcp tool result in the chat buffer
							make_vars = true, -- make chat #variables from MCP server resources
							make_slash_commands = true, -- make /slash_commands from MCP server prompts
						},
					},
					vectorcode = {
						opts = { add_tool = true, add_slash_command = true, tool_opts = {} },
					},
				},
				strategies = {
					inline = {
						keymaps = {
							accept_change = {
								modes = { n = "ga" },
								description = "Accept the suggested change",
							},
							reject_change = {
								modes = { n = "gr" },
								description = "Reject the suggested change",
							},
						},
					},
				},
				prompt_library = retrieve_prompts(prompts_dirs),
			})
		end,
	},
	{ "AndreM222/copilot-lualine" },
	{
		"zbirenbaum/copilot.lua",
		cmd = "Copilot",
		event = { "InsertEnter" },
		build = ":Copilot auth",
		-- dependencies = { "zbirenbaum/copilot-cmp" },
		opts = {
			suggestion = { enabled = false },
			panel = { enabled = false },
			-- filetypes = {
			-- 	["*"] = true, -- disable for all other filetypes and ignore default `filetypes`
			-- },
		},
	},
	{
		"zbirenbaum/copilot-cmp",
		config = function()
			require("copilot_cmp").setup()
		end,
	},
	{
		"Exafunction/windsurf.nvim",
		event = { "InsertEnter" },
		opts = {
			enable_chat = true,
		},
		config = function()
			require("codeium").setup({})
		end,
	},
	{
		"ravitemer/mcphub.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		cmd = "MCPHub", -- lazy load by default
		build = "npm install -g mcp-hub@latest", -- Installs globally
		config = function()
			require("mcphub").setup({
				-- Server configuration
				port = 37373, -- Port for MCP Hub Express API
				config = vim.fn.expand("~/.config/mcphub/servers.json"), -- Config file path
				global_env = function(context)
					return {
						CWD = context.cwd,
						"DBUS_SESSION_BUS_ADDRESS", -- For session variables
						GITHUB_MCP_TOKEN = github_mcp_token, -- GitHub MCP token
					}
				end,
				native_servers = {}, -- add your native servers here
				-- Extension configurations
				auto_approve = false,
				extensions = {
					avante = {},
					codecompanion = {
						show_result_in_chat = true, -- Show tool results in chat
						make_vars = true, -- Create chat variables from resources
						make_slash_commands = true, -- make /slash_commands from MCP server prompts
					},
				},

				-- UI configuration
				ui = {
					window = {
						width = 0.8, -- Window width (0-1 ratio)
						height = 0.8, -- Window height (0-1 ratio)
						border = "rounded", -- Window border style
						relative = "editor", -- Window positioning
						zindex = 50, -- Window stack order
					},
				},

				-- Event callbacks
				on_ready = function(hub) end, -- Called when hub is ready
				on_error = function(err) end, -- Called on errors

				-- Logging configuration
				log = {
					level = vim.log.levels.WARN, -- Minimum log level
					to_file = true, -- Enable file logging
					file_path = nil, -- Custom log file path
					prefix = "MCPHub", -- Log message prefix
				},
			})
		end,
	},
}
