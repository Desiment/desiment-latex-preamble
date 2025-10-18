-- print_records.lua
-- 
local inputs = arg[1]
-- Check if an argument was provided
if inputs then
	local records = require(inputs .. '/records')
	local fmt = function(s, n) return s .. string.rep(" ", n- #s:gsub('[\128-\191]', '')) end
    print(fmt(records.uni, 5) .. " " .. fmt(records.speciality,6) .. " " .. records.course .. " курс (" .. records.year .. ")")
end
