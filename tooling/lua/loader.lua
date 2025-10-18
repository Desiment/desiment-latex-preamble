local Loader = {}

function Loader.load(path)
    local loaded, configuration = pcall(require, path)
    if not loaded then
        error("Failed to load configuration.lua from " .. tostring(path))
    end
    Loader.configuration = configuration
	return configuration
end

return Loader
