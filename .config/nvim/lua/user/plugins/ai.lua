local function get_env(var)
	local val = vim.fn.getenv(var)
	return (val == vim.NIL or val == "") and nil or val
end

local tokens = {
	github_mcp = get_env("GITHUB_MCP_TOKEN"),
	gemini = get_env("GEMINI_API_KEY"),
	ollama = get_env("OLLAMA_API_KEY"),
	openrouter = get_env("OPENROUTER_API_KEY"),
	joplin = get_env("JOPLIN_TOKEN"),
	claude = get_env("CLAUDE_CODE_OAUTH_TOKEN"),
}

local prompts_dirs = { vim.fn.stdpath("config") .. "/prompts/", vim.fn.expand("~/soft/Fabric/data/patterns") }
local strategies_dirs = { vim.fn.expand("~/soft/Fabric/data/strategies") }
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
		"olimorris/codecompanion.nvim",
		version = "v19.20.0",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
			{ "toniher/codecompanion-history.nvim" },
			"cairijun/codecompanion-agentskills.nvim",
		},
		config = function()
			require("codecompanion").setup({
				-- mcp = mcp_servers,
				adapters = {
					http = {
						opts = { show_presets = false },
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
						ollama = function()
							return require("codecompanion.adapters").extend("ollama", {
								name = "ollama",
								schema = {
									model = {
										default = "gemma3:4b-cloud",
									},
								},
							})
						end,
						openrouter = function()
							return require("codecompanion.adapters").extend("openrouter", {
								opts = { session_id = "title_generation" },
							})
						end,
					},
					acp = {
						opts = { show_presets = false },
						claude_code = function()
							return require("codecompanion.adapters").extend("claude_code", {
								env = {
									CLAUDE_CODE_OAUTH_TOKEN = claude_token,
								},
							})
						end,
						copilot_acp = function()
							return require("codecompanion.adapters").extend("copilot_acp", {})
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
										"deepagents-code",
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
								adapter = "ollama", -- "copilot"
								---Model for generating titles (defaults to current chat model)
								model = "gemma3:4b-cloud",
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
									adapter = "ollama", -- defaults to current chat adapter
									model = "gemma3:4b-cloud", -- defaults to current chat model
									context_size = 90000, -- max tokens that the model supports
									include_references = true, -- include slash command content
									include_tool_outputs = true, -- include tool execution results
									system_prompt = nil, -- custom system prompt (string or function)
									format_summary = nil, -- custom function to format generated summary e.g to remove <think/> tags from summary
								},
							},
						},
					},
					mcp_companion = {
						callback = "mcp_companion.cc",
						opts = {},
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
						-- adapter = { name = "copilot", model = "gpt-5-mini" },
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

	-- mcp-companion: the combiner + Neovim plugin
	{
		"georgeharker/mcp-companion",
		lazy = false,
		dependencies = {
			"olimorris/codecompanion.nvim",
			"georgeharker/sharedserver",
		},
		build = "cd combiner && uv sync --frozen",
		config = function()
			require("mcp_companion").setup({
				combiner = {
					port = 9741,
					config = vim.fn.expand("~/.config/mcp/servers.json"),
				},
				log = { level = "info", notify = "error" },
			})
		end,
	},
}
