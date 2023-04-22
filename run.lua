#!/usr/bin/env lua
require 'ext'
local fs = table()
for f in file'.':dir() do
	if f:sub(-3) == '.ts' then
		fs:insert(f)
	end
end
local base = {}
function val(s)
	local y,m,d,H,M,S,i = s:match'^(%d%d%d%d)%-(%d%d)%-(%d%d) (%d%d)%-(%d%d)%-(%d%d)(%d+)%.ts$'
	if base.y then assert(y == base.y) else base.y = y end
	if base.m then assert(m == base.m) else base.m = m end
	if base.d then assert(d == base.d) else base.d = d end
	if base.H then assert(H == base.H) else base.H = H end
	if base.M then assert(M == base.M) else base.M = M end
	if base.S then assert(S == base.S) else base.S = S end
	return assert(tonumber(i))
end
fs:sort(function(a,b) return val(a) < val(b) end)
file'input.txt':write(fs:mapi(function(s) return "file '"..s.."'" end):concat'\n'..'\n')
local outfn
for i=1,math.huge do
	outfn = 'out'..i..'.mp4'
	if not file(outfn):exists() then break end
end
local cmd = 'ffmpeg -f concat -safe 0 -i input.txt '..outfn
print('>'..cmd)
print(os.execute(cmd))
