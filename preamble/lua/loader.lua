local Loader = {}

function file_exists(name)
   local f=io.open(name, "r")
   if f~=nil then io.close(f) return true else return false end
end

function Loader.configuration()
	if file_exists('configuration.lua') then
	  local loaded, configuration = pcall(require, 'configuration.lua')
	  if not loaded then
		  error("Failed to load configuration.lua")
	  end
	  Loader.configuration = configuration
	else
	  Loader.configuration = require('preamble/lua/configuration')
	end
	return Loader.configuration
end

function Loader.parse_kv_opts(opts)
	if opts == nil then
	  return ''
	end
    local options = {}
	for key, value in pairs(opts) do
		if type(value) == "boolean" then
			if value then
				table.insert(options, key)
			end
		elseif type(value) == "table" then
			table.insert(options, key .. "={" .. table.concat(value, ", ") .. "}")
		else
			table.insert(options, key .. "=" .. tostring(value))
		end
	end
	return table.concat(options, ", ")
end

function Loader.DeclareTheorems(configuration)
  for k, env in pairs(configuration.typesetting.theorems.enviroments) do 
	tex.sprint('\\NewDocumentTheorem{'..env.envname..'}{' ..env.name.. '}[' .. Loader.parse_kv_opts(env.options) .. ']')
  end
end

return Loader
