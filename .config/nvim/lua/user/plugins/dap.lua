return {
	{
		"mfussenegger/nvim-dap",
		event = { "BufReadPre", "BufNewFile" },
		-- tag = "0.10.0",
		dependencies = {
			{ "rcarriga/nvim-dap-ui" },
			{ "nvim-neotest/nvim-nio", tag = "v1.10.1" },
			{ "jay-babu/mason-nvim-dap.nvim", tag = "v2.5.2" },
		},
	},
}
