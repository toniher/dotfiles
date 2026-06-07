return {
	{ "askfiy/http.nvim" }, -- a wrapper implementation of the Python aiohttp library that uses CURL to send requests.
	{
		"toniher/smart-translate.nvim",
		branch = "improvements",
		cmd = { "Translate" },
		dependencies = {
			"askfiy/http.nvim",
		},
		config = function(_, opts)
			require("smart-translate").setup(opts)
			-- complete.lua calls util.engines() at module load time (before setup),
			-- so custom engines are missed. Reset the cache here to include them.
			local util = require("smart-translate.util")
			util._engins = nil
			local complete = require("smart-translate.core.complete")
			complete.options.engine = util.engines()
		end,
		opts = function()
			-- Both Softcatalà and Apertium expose the Apertium-APY response shape:
			--   { responseData = { translatedText = "..." }, responseStatus = 200 }
			-- so the request/parse logic is shared and only URL + langpair differ.
			local function apy_translate(url, langpair, original, callback)
				local delim = "\n\n\n"

				local result = {}
				local non_empty = {}
				for i, line in ipairs(original) do
					result[i] = line
					if line:match("%S") then
						table.insert(non_empty, i)
					end
				end

				if #non_empty == 0 then
					callback(result)
					return
				end

				local parts = {}
				for _, i in ipairs(non_empty) do
					table.insert(parts, original[i])
				end
				local combined = table.concat(parts, delim)

				vim.system(
					{
						"curl",
						"-sS",
						"-X",
						"POST",
						url,
						"-H",
						"Content-Type: application/x-www-form-urlencoded",
						"--data-urlencode",
						"langpair=" .. langpair,
						"--data-urlencode",
						"q=" .. combined,
						"--data-urlencode",
						"savetext=false",
					},
					{ text = true },
					vim.schedule_wrap(function(completed)
						local ok, data = pcall(vim.json.decode, completed.stdout or "")
						if ok and data and data.responseData and data.responseData.translatedText then
							local translated = vim.split(data.responseData.translatedText, delim, { plain = true })
							for k, idx in ipairs(non_empty) do
								result[idx] = translated[k] or original[idx]
							end
						end
						callback(result)
					end)
				)
			end

			-- Softcatalà uses 2-letter source codes but "cat" for Catalan target.
			local function softcatala_lang(source, target)
				if source == "auto" or source == "" then
					source = "en"
				end
				if target == "ca" or target == "ca-ES" then
					target = "cat"
				end
				return source .. "|" .. target
			end

			-- Apertium APY expects ISO 639-3 codes ("eng", "cat", "spa"...).
			local apertium_iso3 = {
				en = "eng",
				ca = "cat",
				es = "spa",
				fr = "fra",
				pt = "por",
				it = "ita",
				de = "deu",
				oc = "oci",
				eu = "eus",
				gl = "glg",
				ro = "ron",
				nl = "nld",
			}
			local function apertium_lang(source, target)
				if source == "auto" or source == "" then
					source = "eng"
				end
				source = apertium_iso3[source] or source
				target = apertium_iso3[target] or target
				return source .. "|" .. target
			end

			return {
				debug = true,
				default = {
					cmds = {
						source = "auto",
						target = "cat",
						handle = "float",
						engine = "softcatala",
					},
					cache = true,
				},
				translator = {
					engine = {
						{
							name = "softcatala",
							---@param source string
							---@param target string
							---@param original string[]
							---@param callback fun(translation: string[])
							translate = function(source, target, original, callback)
								apy_translate(
									"https://api.softcatala.org/v2/nmt/translate/",
									softcatala_lang(source, target),
									original,
									callback
								)
							end,
						},
					},
				},
			}
		end,
	},
}
