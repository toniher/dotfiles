local github_mcp_token = vim.fn.getenv("GITHUB_MCP_TOKEN")
if not github_mcp_token == "" then
	github_mcp_token = "" -- or leave as nil, or handle as needed
end
local gemini_api_key = vim.fn.getenv("GEMINI_API_KEY")
if not gemini_api_key == "" then
	gemini_api_key = "" -- or leave as nil, or handle as needed
end
local ollama_api_key = vim.fn.getenv("OLLAMA_API_KEY")
if not ollama_api_key == "" then
	ollama_api_key = "" -- or leave as nil, or handle as needed
end
local joplin_token = vim.fn.getenv("JOPLIN_TOKEN")
if not joplin_token == "" then
	joplin_token = "" -- or leave as nil, or handle as needed
end
local claude_token = vim.fn.getenv("CLAUDE_CODE_OAUTH_TOKEN")
if not claude_token == "" then
	claude_token = "" -- or leave as nil, or handle as needed
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
		interaction = "chat",
		description = system_prompt,
		opts = vim.tbl_extend("force", { alias = name }, shared_opts),

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
		local text = require("codecompanion.helpers.code").get_code(context.start_line, context.end_line)
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

local prompt_libraries = retrieve_prompts(prompts_dirs)

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
		version = "v19.14.0",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
			{ "ravitemer/codecompanion-history.nvim", commit = "bc1b4fe06eaaf0aa2399be742e843c22f7f1652a" },
			"cairijun/codecompanion-agentskills.nvim",
		},
		config = function()
			require("codecompanion").setup({
				-- mcp = mcp_servers,
				adapters = {
					http = {
						gemma4 = function()
							return require("codecompanion.adapters").extend("ollama", {
								name = "gemma4", -- Give this adapter a different name to differentiate it from the default ollama adapter
								schema = {
									model = {
										default = "gemma4:31b-cloud",
									},
								},
							})
						end,
					},
					acp = {
						claude_code = function()
							return require("codecompanion.adapters").extend("claude_code", {
								env = {
									CLAUDE_CODE_OAUTH_TOKEN = claude_token,
								},
							})
						end,
						deep_agents = function()
							local helpers = require("codecompanion.adapters.acp.helpers")
							return {
								name = "deep_agents",
								formatted_name = "DeepAgents",
								type = "acp",
								roles = {
									llm = "assistant",
									user = "user",
								},
								commands = {
									default = {
										"deepagents",
										"--acp",
									},
								},
								defaults = {
									mcpServers = {},
									timeout = 20000, -- 20 seconds
								},
								parameters = {
									protocolVersion = 1,
									clientCapabilities = {
										fs = { readTextFile = true, writeTextFile = true },
									},
									clientInfo = {
										name = "CodeCompanion.nvim",
										version = "1.0.0",
									},
								},
								handlers = {
									setup = function(self)
										return true
									end,
									auth = function(self)
										return true
									end,
									form_messages = function(self, messages, capabilities)
										return helpers.form_messages(self, messages, capabilities)
									end,
									on_exit = function(self, code) end,
								},
							}
						end,
						gemini_cli = function()
							return require("codecompanion.adapters").extend("gemini_cli", {
								defaults = {
									auth_method = "oauth-personal", -- "oauth-personal"|"gemini-api-key"|"vertex-ai"
									timeout = 20000, -- 20 seconds
								},
								env = {
									GEMINI_API_KEY = gemini_api_key,
								},
							})
						end,
					},
				},
				display = {
					action_palette = {
						provider = "fzf_lua",
						opts = {
							show_default_actions = true,
							show_default_prompt_library = true,
						},
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
							---Optional filter function to control which chats are shown when browsing
							chat_filter = nil, -- function(chat_data) return boolean end
							-- Customize picker keymaps (optional)
							picker_keymaps = {
								rename = { n = "r", i = "<M-r>" },
								delete = { n = "d", i = "<M-d>" },
								duplicate = { n = "<C-y>", i = "<C-y>" },
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
								format_title = function(original_title)
									-- this can be a custom function that applies some custom
									-- formatting to the title.
									return original_title
								end,
							},
							---On exiting and entering neovim, loads the last chat on opening chat
							continue_last_chat = false,
							---When chat is cleared with `gx` delete the chat from history
							delete_on_clearing_chat = false,
							---Directory path to save the chats
							dir_to_save = vim.fn.stdpath("data") .. "/codecompanion-history",
							---Enable detailed logging for history extension
							enable_logging = false,

							-- Summary system
							summary = {
								-- Keymap to generate summary for current chat (default: "gcs")
								create_summary_keymap = "gcs",
								-- Keymap to browse summaries (default: "gbs")
								browse_summaries_keymap = "gbs",

								generation_opts = {
									adapter = nil, -- defaults to current chat adapter
									model = nil, -- defaults to current chat model
									context_size = 90000, -- max tokens that the model supports
									include_references = true, -- include slash command content
									include_tool_outputs = true, -- include tool execution results
									system_prompt = nil, -- custom system prompt (string or function)
									format_summary = nil, -- custom function to format generated summary e.g to remove <think/> tags from summary
								},
							},

							-- Memory system (requires VectorCode CLI)
							memory = {
								-- Automatically index summaries when they are generated
								auto_create_memories_on_summary_generation = true,
								-- Path to the VectorCode executable
								vectorcode_exe = "vectorcode",
								-- Tool configuration
								tool_opts = {
									-- Default number of memories to retrieve
									default_num = 10,
								},
								-- Enable notifications for indexing progress
								notify = true,
								-- Index all existing memories on startup
								-- (requires VectorCode 0.6.12+ for efficient incremental indexing)
								index_on_startup = false,
							},
						},
					},
					mcp_companion = {
						callback = "mcp_companion.cc",
						opts = {},
					},
					-- mcphub = {
					-- 	callback = "mcphub.extensions.codecompanion",
					-- 	opts = {
					-- 		show_result_in_chat = true, -- Show the mcp tool result in the chat buffer
					-- 		make_vars = true, -- make chat #variables from MCP server resources
					-- 		make_slash_commands = true, -- make /slash_commands from MCP server prompts
					-- 	},
					-- },
					vectorcode = {
						opts = { add_tool = true, add_slash_command = true, tool_opts = {} },
					},
					agentskills = {
						opts = {
							paths = {
								{ "~/.config/agents/skills", recursive = true }, -- Recursive search
								{ ".claude/skills", recursive = true }, -- Recursive search
								{ ".agents/skills", recursive = true }, -- Recursive search
							},
						},
					},
				},
				interactions = {
					background = {
						chat = {
							callbacks = {
								["on_ready"] = {
									actions = {
										"interactions.background.builtin.chat_make_title",
									},
									-- Enable "on_ready" callback which contains the title generation action
									enabled = true,
								},
							},
							opts = {
								-- Enable background interactions generally
								enabled = true,
							},
						},
					},
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
					chat = {
						tools = {
							groups = {
								["agent_youtube"] = {
									description = "Youtube summarizer agent",
									system_prompt = function(group, ctx)
										return string.format(prompt_libraries["youtube_summary"].prompts[1].content)
									end,
									tools = {
										"fetch_webpage",
										"youtube-transcript_get_video_info",
										"youtube-transcript_get_transcript",
										"youtube-transcript_get_timed_transcript",
									},
									opts = {
										collapse_tools = true,
										ignore_system_prompt = true, -- Remove the chat's default system prompt
										ignore_tool_system_prompt = true, -- Remove the default tool system prompt
									},
								},
							},
						},
					},
					cli = {
						agent = "claude_code",
						agents = {
							claude_code = {
								cmd = "claude",
								args = {},
								description = "Claude Code CLI",
								provider = "terminal",
							},
						},
					},
				},
				prompt_library = prompt_libraries,
			})
		end,
	},
	{ "AndreM222/copilot-lualine" },
	{
		"zbirenbaum/copilot.lua",
		dependencies = {
			"copilotlsp-nvim/copilot-lsp",
		},
		cmd = "Copilot",
		event = { "InsertEnter" },
		build = ":Copilot auth",
		opts = {
			suggestion = { enabled = false },
			panel = { enabled = false },
			-- filetypes = {
			-- 	["*"] = true, -- disable for all other filetypes and ignore default `filetypes`
			-- },
		},
		config = function()
			require("copilot").setup({
				nes = {
					enabled = true,
					keymap = {
						accept_and_goto = "<leader>a",
						accept = false,
						dismiss = "<Esc>",
					},
				},
			})
		end,
	},

	-- sharedserver: builds the Rust binary that manages bridge process lifecycle
	{
		"georgeharker/sharedserver",
		build = "cargo install --path rust",
		lazy = false,
	},

	-- mcp-companion: the bridge + Neovim plugin
	{
		"georgeharker/mcp-companion",
		lazy = false,
		dependencies = {
			"nvim-lua/plenary.nvim",
			"georgeharker/sharedserver",
		},
		build = "cd bridge && uv sync --frozen",
		config = function()
			require("mcp_companion").setup({
				bridge = {
					port = 9741,
					config = vim.fn.expand("~/.config/mcp/servers.json"),
				},
				log = { level = "info", notify = "error", file = true },
			})
		end,
	},
}
