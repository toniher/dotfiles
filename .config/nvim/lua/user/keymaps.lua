-- Shorten function name
local keymap = vim.keymap.set
-- Silent keymap option
-- We keep everywhere noremap
local function desc_opts(description, extra)
	local opts = { noremap = true, silent = true, desc = description }
	if extra then
		for k, v in pairs(extra) do
			opts[k] = v
		end
	end
	return opts
end

--Remap space as leader key
keymap("", "<Space>", "<Nop>", desc_opts("Unmap space, set as leader"))
vim.g.mapleader = " "

-- Modes
--   normal_mode = "n",
--   insert_mode = "i",
--   visual_mode = "v",
--   visual_block_mode = "x",
--   term_mode = "t",
--   command_mode = "c",

-- Normal --
-- Better window navigation
keymap("n", "<C-h>", "<C-w>h", desc_opts("Move to left window"))
keymap("n", "<C-j>", "<C-w>j", desc_opts("Move to below window"))
keymap("n", "<C-k>", "<C-w>k", desc_opts("Move to above window"))
keymap("n", "<C-l>", "<C-w>l", desc_opts("Move to right window"))
keymap("n", "<leader>y", "<cmd>only<CR>", desc_opts("Turn the window fullscreen"))

-- Resize with arrows
keymap("n", "<C-Up>", "<cmd>resize -2<CR>", desc_opts("Resize window up"))
keymap("n", "<C-Down>", "<cmd>resize +2<CR>", desc_opts("Resize window down"))
keymap("n", "<C-Left>", "<cmd>vertical resize -2<CR>", desc_opts("Resize window left"))
keymap("n", "<C-Right>", "<cmd>vertical resize +2<CR>", desc_opts("Resize window right"))

-- New buffer
keymap("n", "<leader>na", "<cmd>tabnew<CR>", desc_opts("New tab"))
keymap("n", "<leader>nh", "<cmd>enew<CR>", desc_opts("New empty buffer"))
keymap("n", "<leader>nb", "<cmd>new<CR>", desc_opts("New split buffer"))

-- Split
keymap("n", "<leader>sh", "<cmd>split<CR>", desc_opts("Horizontal split"))
keymap("n", "<leader>sv", "<cmd>vsplit<CR>", desc_opts("Vertical split"))

-- Navigate buffers
keymap("n", "<S-l>", "<cmd>bnext<CR>", desc_opts("Next buffer"))
keymap("n", "<S-h>", "<cmd>bprevious<CR>", desc_opts("Previous buffer"))
-- Close buffers
keymap("n", "<S-q>", "<cmd>lua require('snacks').bufdelete()<CR>", desc_opts("Delete buffer"))

-- buffer Move
keymap("n", "<leader>mh", "<cmd>BufferLineMovePrev<CR>", desc_opts("Move buffer left"))
keymap("n", "<leader>ml", "<cmd>BufferLineMoveNext<CR>", desc_opts("Move buffer right"))

-- Tabs
keymap("n", "<leader>bl", "<cmd>+tabnext<CR>", desc_opts("Next tab"))
keymap("n", "<leader>bh", "<cmd>-tabnext<CR>", desc_opts("Previous tab"))
-- Close tab
keymap("n", "<leader>bq", "<cmd>tabclose!<CR>", desc_opts("Close tab"))

-- Clear highlights
keymap("n", "<leader>h", "<cmd>nohlsearch<CR>", desc_opts("Clear search highlight"))

-- Better paste
keymap("v", "p", '"_dP', desc_opts("Paste without yanking"))

-- Insert --
-- Press jk fast to enter
keymap("i", "jk", "<ESC>", desc_opts("Exit insert mode with jk"))

-- Visual --
-- Stay in indent mode
keymap("v", "<", "<gv", desc_opts("Indent left and stay in visual mode"))
keymap("v", ">", ">gv", desc_opts("Indent right and stay in visual mode"))

-- Pickers (fzf-lua)
keymap("n", "<leader>fb", "<cmd>FzfLua buffers<CR>", desc_opts("Find buffers"))
keymap("n", "<leader>fd", "<cmd>FzfLua lsp_definitions<CR>", desc_opts("Find LSP definitions"))
keymap("n", "<leader>fg", "<cmd>FzfLua live_grep<CR>", desc_opts("Grep in project"))
keymap("n", "<leader>ff", "<cmd>lua require('fzf-lua').files({ hidden = true })<CR>", desc_opts("Find files"))
keymap("n", "<leader>fj", "<cmd>FzfLua jumps<CR>", desc_opts("Find jumps"))
keymap("n", "<leader>fm", "<cmd>FzfLua marks<CR>", desc_opts("Find marks"))
keymap("n", "<leader>fp", "<cmd>lua require('snacks').picker.projects()<CR>", desc_opts("Find projects"))
keymap("n", "<leader>fr", "<cmd>FzfLua oldfiles<CR>", desc_opts("Find recent files"))
keymap("n", "<leader>fs", "<cmd>AutoSession search<CR>", desc_opts("Find session"))
keymap("n", "<leader>ft", "<cmd>TodoFzfLua<CR>", desc_opts("Find TODO comments"))
keymap("n", "<leader>fz", "<cmd>FzfLua zoxide<CR>", desc_opts("Find directories with zoxide"))

-- Session specific
keymap("n", "<leader>wd", "<cmd>AutoSession delete<CR>", desc_opts("Autosession delete"))
keymap("n", "<leader>wr", "<cmd>Autosession search<CR>", desc_opts("Autosession search"))
keymap("n", "<leader>ws", "<cmd>AutoSession save<CR>", desc_opts("Autosession save"))
keymap("n", "<leader>wa", "<cmd>AutoSession toggle<CR>", desc_opts("Autosession - Toggle autosave"))

-- Reload buffer
keymap("n", "<leader>r", "<cmd>bufdo e<CR>", desc_opts("Reload all buffers"))

-- DAP
keymap("n", "<leader>db", "<cmd>lua require'dap'.toggle_breakpoint()<cr>", desc_opts("DAP: Toggle breakpoint"))
keymap("n", "<leader>dc", "<cmd>lua require'dap'.continue()<cr>", desc_opts("DAP: Continue"))
keymap("n", "<leader>di", "<cmd>lua require'dap'.step_into()<cr>", desc_opts("DAP: Step into"))
keymap("n", "<leader>do", "<cmd>lua require'dap'.step_over()<cr>", desc_opts("DAP: Step over"))
keymap("n", "<leader>dO", "<cmd>lua require'dap'.step_out()<cr>", desc_opts("DAP: Step out"))
keymap("n", "<leader>dr", "<cmd>lua require'dap'.repl.toggle()<cr>", desc_opts("DAP: Toggle REPL"))
keymap("n", "<leader>dl", "<cmd>lua require'dap'.run_last()<cr>", desc_opts("DAP: Run last"))
keymap("n", "<leader>du", "<cmd>lua require'dapui'.toggle()<cr>", desc_opts("DAP: Toggle UI"))
keymap("n", "<leader>dt", "<cmd>lua require'dap'.terminate()<cr>", desc_opts("DAP: Terminate"))

-- Git
keymap("n", "<leader>gb", "<cmd>G blame<CR>", desc_opts("Git blame"))
keymap("n", "<leader>gB", "<cmd>lua require('snacks').gitbrowse()<CR>", desc_opts("Git browse"))
keymap("n", "<leader>gd", "<cmd>G diff<CR>", desc_opts("Git diff"))
keymap("n", "<leader>ghi", "<cmd>lua require('snacks').picker.gh_issue()<CR>", desc_opts("GitHub Issues (open)"))
keymap(
	"n",
	"<leader>ghI",
	"<cmd>lua require('snacks').picker.gh_issue({ state = 'all' })<CR>",
	desc_opts("GitHub Issues (all)")
)
keymap("n", "<leader>ghp", "<cmd>lua require('snacks').picker.gh_pr()<CR>", desc_opts("GitHub Pull Requests (open)"))
keymap(
	"n",
	"<leader>ghP",
	"<cmd>lua require('snacks').picker.gh_pr({ state = 'all' })<CR>",
	desc_opts("GitHub Pull Requests (all)")
)

keymap("n", "<leader>gi", "<cmd>G<CR>", desc_opts("Git status"))
keymap("n", "<leader>gf", "<cmd>lua require('snacks').lazygit.log_file()<CR>", desc_opts("Lazygit log file"))
keymap("n", "<leader>gg", "<cmd>lua require('snacks').lazygit()<CR>", desc_opts("Lazygit"))
keymap("n", "<leader>gl", "<cmd>lua require('snacks').lazygit.log()<CR>", desc_opts("Lazygit log"))
keymap("n", "<leader>gm", "<cmd>lua require('snacks').git.blame_line()<CR>", desc_opts("Git blame line"))
keymap("n", "<leader>gp", "<cmd>Gitsigns preview_hunk<CR>", desc_opts("Gitsigns preview hunk"))

-- Toggleterm
keymap("n", "<leader>tf", "<cmd>TermNew direction=float<CR>", desc_opts("Open floating terminal"))
keymap("n", "<leader>tg", "<cmd>ToggleTerm<CR>", desc_opts("Toggle terminal"))
keymap("n", "<leader>th", "<cmd>TermNew direction=horizontal size=20<CR>", desc_opts("Open horizontal terminal"))
keymap("n", "<leader>ts", "<cmd>TermSelect<CR>", desc_opts("Select terminal"))
keymap("n", "<leader>tt", "<cmd>TermNew direction=tab<CR>", desc_opts("Open terminal in new tab"))
keymap("n", "<leader>tv", "<cmd>TermNew direction=vertical size=75<CR>", desc_opts("Open vertical terminal"))

-- Toc of todos and fixmes
keymap("n", "<leader>to", "<cmd>TodoLocList<CR>", desc_opts("Show TODOs/FIXMEs in location list"))
keymap("n", "<leader>tl", "<cmd>TodoFzfLua<CR>", desc_opts("Fzf search TODOs/FIXMEs"))

-- Symbol Outine
keymap("n", "<leader>so", "<cmd>Outline<CR>", desc_opts("Show symbol outline"))

-- Markdown Preview
keymap("n", "<leader>mv", "<cmd>RenderMarkdown buf_toggle<CR>", desc_opts("Toggle markdown preview"))

-- CodeCompanion Chat
keymap("n", "<leader>ca", "<cmd>CodeCompanionActions<CR>", desc_opts("CodeCompanion actions"))
keymap("v", "<leader>ca", "<cmd>CodeCompanionActions<CR>", desc_opts("CodeCompanion actions (visual)"))
keymap("n", "<leader>cc", "<cmd>CodeCompanionChat<CR>", desc_opts("Open CodeCompanion chat"))
keymap("v", "<leader>cc", "<cmd>CodeCompanionChat<CR>", desc_opts("Open CodeCompanion chat (visual)"))
keymap("n", "<leader>ch", "<cmd>CodeCompanionHistory<CR>", desc_opts("Show CodeCompanion history"))
keymap("n", "<leader>cg", "<cmd>CodeCompanionChat adapter=gemma4<CR>", desc_opts("Open Gemma chat"))
keymap("v", "<leader>cg", "<cmd>CodeCompanionChat adapter=gemma4<CR>", desc_opts("Open Gemma chat (visual)"))
keymap("n", "<leader>cl", "<cmd>CodeCompanionChat adapter=claude_code<CR>", desc_opts("Open Claude Code"))
keymap("v", "<leader>cl", "<cmd>CodeCompanionChat adapter=claude_code<CR>", desc_opts("Open Claude Code (visual)"))
keymap("n", "<leader>ct", "<cmd>CodeCompanionChat Toggle<CR>", desc_opts("Toggle CodeCompanion chat"))

-- CodeDiff
keymap("n", "<leader>cd", "<cmd>CodeDiff<CR>", desc_opts("Open CodeDiff"))

-- Code annotation
keymap("n", "<leader>k", "<cmd>lua require('codedocs').insert_docs()<CR>", desc_opts("Add code annotation"))

-- MCPHub
keymap("n", "<leader>mc", "<cmd>MCPStatus<CR>", desc_opts("Open MCP Status"))

-- TroubleToggle
keymap("n", "<leader>xd", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc_opts("Trouble: Buffer diagnostics"))
keymap("n", "<leader>xl", "<cmd>Trouble loclist toggle<cr>", desc_opts("Trouble: Location list"))
keymap("n", "<leader>xq", "<cmd>Trouble qflist toggle<cr>", desc_opts("Trouble: Quickfix list"))
keymap("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", desc_opts("Trouble: Workspace diagnostics"))

-- Normal-mode commands
keymap("n", "<A-K>", "<cmd>MoveLine(1)<CR>", desc_opts("Move line up"))
keymap("n", "<A-J>", "<cmd>MoveLine(-1)<CR>", desc_opts("Move line down"))
keymap("n", "<A-H>", "<cmd>MoveWord(-1)<CR>", desc_opts("Move word left"))
keymap("n", "<A-L>", "<cmd>MoveWord(1)<CR>", desc_opts("Move word right"))

-- Visual-mode commands
keymap("v", "<A-K>", "<cmd>MoveBlock(1)<CR>", desc_opts("Move block up"))
keymap("v", "<A-J>", "<cmd>MoveBlock(-1)<CR>", desc_opts("Move block down"))
keymap("v", "<A-H>", "<cmd>MoveHBlock(-1)<CR>", desc_opts("Move block left"))
keymap("v", "<A-L>", "<cmd>MoveHBlock(1)<CR>", desc_opts("Move block right"))

-- Paths
keymap("n", "<leader>cw", function() print(vim.uv.cwd()) end, desc_opts("Print current working directory"))
keymap("n", "<leader>pw", "<cmd>echo expand('%:p')<cr>", desc_opts("Print current file path"))

--- Suda
keymap("n", "<leader>sw", "<cmd>SudaWrite<cr>", desc_opts("Suda write as root"))

-- Spellcheck
keymap("n", "<leader>sp0", "<cmd>setlocal nospell<cr>", desc_opts("Disable spellcheck"))
keymap("n", "<leader>sp1", "<cmd>setlocal spell<cr>", desc_opts("Enable spellcheck"))
keymap("n", "<leader>spa", "<cmd>setlocal spelllang=ca<cr>", desc_opts("Set spellcheck language to Catalan"))
keymap("n", "<leader>spn", "<cmd>setlocal spelllang=en<cr>", desc_opts("Set spellcheck language to English"))
keymap("n", "<leader>sps", "<cmd>setlocal spelllang=es<cr>", desc_opts("Set spellcheck language to Spanish"))

-- Notification and zen
keymap("n", "<leader>no", "<cmd>lua require('snacks').notifier.show_history()<CR>", desc_opts("Notification history"))
keymap("n", "<leader>z", "<cmd>lua require('snacks').zen()<CR>", desc_opts("Toggle Zen mode"))
keymap("n", "<leader>Z", "<cmd>lua require('snacks').zen.zoom()<CR>", desc_opts("Toggle Zen zoom"))

-- LSP
keymap("n", "<leader>l0", "<cmd>lsp disable<cr>", desc_opts("LSP: Stop"))
keymap("n", "<leader>l1", function()
	require("user.lsp").enable_all_lsp_servers()
end, desc_opts("LSP: Enable all servers"))
keymap("n", "<leader>li", "<cmd>checkhealth lsp<cr>", desc_opts("LSP: Info"))
keymap("n", "<leader>lh", "<cmd>HarperLS<cr>", desc_opts("Toggle Harper LS"))
keymap("n", "<leader>lla", "<cmd>LtexLSLang ca-ES<cr>", desc_opts("Toggle LanguageTool to Catalan"))
keymap("n", "<leader>lln", "<cmd>LtexLSLang en-GB<cr>", desc_opts("Toggle LanguageTool to English"))
keymap("n", "<leader>lls", "<cmd>LtexLSLang es<cr>", desc_opts("Toggle LanguageTool to Spanish"))
keymap("n", "<leader>llu", "<cmd>LtexLSLang en-US<cr>", desc_opts("Toggle LanguageTool to English (US)"))

keymap("n", "gD", vim.lsp.buf.declaration, desc_opts("LSP: Go to declaration"))
keymap("n", "gd", vim.lsp.buf.definition, desc_opts("LSP: Go to definition"))
keymap("n", "K", vim.lsp.buf.hover, desc_opts("LSP: Hover"))
keymap("n", "gI", vim.lsp.buf.implementation, desc_opts("LSP: Go to implementation"))
keymap("n", "gr", vim.lsp.buf.references, desc_opts("LSP: Find references"))
keymap("n", "gl", vim.diagnostic.open_float, desc_opts("LSP: Show diagnostics float"))
keymap("n", "<leader>la", vim.lsp.buf.code_action, desc_opts("LSP: Code action"))
keymap("n", "<leader>lj", function() vim.diagnostic.jump({ count = 1, float = true }) end, desc_opts("LSP: Next diagnostic"))
keymap("n", "<leader>lk", function() vim.diagnostic.jump({ count = -1, float = true }) end, desc_opts("LSP: Previous diagnostic"))
keymap("n", "<leader>lr", vim.lsp.buf.rename, desc_opts("LSP: Rename symbol"))
keymap("n", "<leader>ls", vim.lsp.buf.signature_help, desc_opts("LSP: Signature help"))
keymap("n", "<leader>fl", "<cmd>FzfLua lsp_document_diagnostics<CR>", desc_opts("FzfLua: LSP diagnostics"))

keymap("n", "<leader>ln", '<cmd>lua require("lint").try_lint()<CR>', desc_opts("Lint"))
