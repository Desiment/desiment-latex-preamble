-- tooling/lua/references.lua
local ReferencesModuleLoader = {}


function ReferencesModuleLoader.hyperrefsetup(config)
    local hyperconf = config.references.hyperref
    
    -- Apply hypersetup
    local options = {}
    for key, value in pairs(hyperconf.hypersetup) do
        if type(value) == "boolean" then
            if value then
                table.insert(options, key)
            end
        elseif type(value) == "table" then
            if key == "pdfauthor" or key == "pdfkeywords" or key == "pdfsubject" or key == "pdftitle" then
                table.insert(options, key .. "={" .. table.concat(value, ", ") .. "}")
            else
                error("hypersetup: unknown key " .. key)
            end
        else
            table.insert(options, key .. "=" .. tostring(value))
        end
    end
    tex.sprint("\\hypersetup{" .. table.concat(options, ", ") .. "}")
    
    -- Create reference commands
    local shortref_conf = hyperconf.shortref
    for _, ref_config in ipairs(shortref_conf) do
        local csname = ref_config.csname
        local reftext = ref_config.reftext

        if csname and reftext then
            -- Create lowercase version (e.g., \picref)
            tex.sprint(string.format("\\NewDocumentCommand\\%s{m}{%s~\\ref{#1}}", csname, reftext))

            -- Create capitalized version (e.g., \Picref)
            local capitalized_csname = csname:sub(1,1):upper() .. csname:sub(2)
            tex.sprint(string.format("\\NewDocumentCommand\\%s{m}{\\MakeUppercase %s~\\ref{#1}}", capitalized_csname, reftext))
        end
    end
end

function ReferencesModuleLoader.setupimakeidx(config)
    local indexes_conf = config.references.indexes
    
    if indexes_conf.enable then
        tex.sprint("\\makeindex")
        
        for _, idx in ipairs(indexes_conf.list) do
            if idx.name then
                -- Named index
                local options = {}
                if idx.columns then table.insert(options, "columns=" .. tostring(idx.columns)) end
                if idx.columnsep then table.insert(options, "columnsep=" .. idx.columnsep) end
                if idx.columnseprule then table.insert(options, "columnseprule") end
                if idx.intoc ~= nil then table.insert(options, "intoc=" .. tostring(idx.intoc)) end
                
                local options_str = table.concat(options, ",")
                if options_str ~= "" then
                    tex.sprint(string.format("\\makeindex[name=%s, title=%s, %s]", idx.name, idx.title, options_str))
                else
                    tex.sprint(string.format("\\makeindex[name=%s, title=%s]", idx.name, idx.title))
                end
                
                -- Print command for named index
                tex.sprint(string.format("\\NewDocumentCommand\\printindex%s{}{\\printindex[%s]}", idx.name, idx.name))
            else
                -- Default index
                tex.sprint(string.format("\\renewcommand\\indexname{%s}", idx.title))
            end
        end
    end
end

function ReferencesModuleLoader.setupbiblatex(config)
    local biblatex_conf = config.references.bibtex
    
    -- Source mapping for multiple bibliographies
    if #biblatex_conf.bibliographies > 1 then
		local macro = ''
        macro = macro .. "\\DeclareSourcemap{"
        macro = macro .. "\\maps[datatype=bibtex, overwrite]{"
        
        for i, bib in ipairs(biblatex_conf.bibliographies) do
            local files = type(bib.files) == "table" and bib.files or {bib.files}
            for _, file in ipairs(files) do
                local keyword = "bib" .. bib.name
				local full_path = biblatex_conf.path .. "/" .. file
                macro = macro .. "\\map{" .. string.format("\\perdatasource{%s}", full_path)
				macro = macro .. "\\step[fieldset=keywords, fieldvalue={, }, appendstrict]"
				macro = macro .. string.format("\\step[fieldset=keywords, fieldvalue=%s, append]}", keyword) 
            end
        end
		macro = macro .. "}}"
		print(macro)
        tex.sprint(macro)
    end
    
    -- Add bibliography resources
    for i, bib in ipairs(biblatex_conf.bibliographies) do
        local files = type(bib.files) == "table" and bib.files or {bib.files}
        for _, file in ipairs(files) do
            local full_path = biblatex_conf.path .. "/" .. file
            tex.sprint(string.format("\\addbibresource{%s}", full_path))
        end
    end
    
    -- Commands to print bibliographies
    if #biblatex_conf.bibliographies > 1 then
        for i, bib in ipairs(biblatex_conf.bibliographies) do
            local keyword = "bib" .. bib.name
			local bibopts = string.format("title={%s}, keyword=%s", bib.title, keyword) 
            tex.sprint(string.format("\\NewDocumentCommand\\printbibliography%s{o}", bib.name) .. 
			  "{\\IfNoValueTF{#1}{\\printbibliography["..bibopts ..
							  "]}{\\printbibliography["..bibopts..", #1]}}")
        end
    end
end

function ReferencesModuleLoader.get_biblatex_options(config)
    local biblatex_conf = config.references.bibtex
    return string.format("backend=biber,style=%s", biblatex_conf.style)
end


return ReferencesModuleLoader
