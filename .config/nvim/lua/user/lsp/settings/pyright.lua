return {
	settings = {
		python = {
			analysis = {
				useLibraryCodeForTypes = true,
				diagnosticSeverityOverrides = {
					reportUnusedVariable = "warning",
				},
				typeCheckingMode = "off", -- Set type-checking mode to off
				diagnosticMode = "off", -- Disable diagnostics entirely
			},
			venvPath = vim.env.VIRTUAL_ENV and vim.env.VIRTUAL_ENV or vim.env.PYENV_ROOT,
		},
	},
}
