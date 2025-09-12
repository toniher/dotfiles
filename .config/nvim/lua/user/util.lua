local M = {}

function M.get_hostname()
	local f = io.popen("/bin/hostname")
	local hostname = f:read("*a") or ""
	f:close()
	hostname = string.gsub(hostname, "\n$", "")
	return hostname
end

M.machine = M.get_hostname()
function M.startswith(text, prefix)
	return text:find(prefix, 1, true) == 1
end

return M
