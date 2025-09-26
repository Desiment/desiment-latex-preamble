local M = {}

-- Constants
local LATEX_BOOL_TRUE = [[\noexpand\BooleanTrue]]
local LATEX_BOOL_FALSE = [[\noexpand\BooleanFalse]]

-- Local helper functions
local function split_field(field_path)
    local results = {}
    for part in field_path:gmatch("([^%.]+)") do
        table.insert(results, part)
    end
    return results
end

local function deep_get(t, keys)
    local value = t
    for _, key in ipairs(keys) do
        if not value or not value[key] then
            return nil
        end
        value = value[key]
    end
    return value
end

local function choice(condition, a, b)
  if condition then
	return a
  else
	return b
  end
end
-- Report type and kind representations
local TYPE_REPR = {
    production = {ru = [[Отчёт по производственной практике]], en = [[Internship report]]},
    coursework = {ru = [[Отчёт по курсовой работе]], en = [[Coursework]]},
    practice = {ru = [[Отчёт по учебной практике]], en = [[Practice report]]},
    prediploma = {ru = [[Отчёт по преддипломной практике]], en = [[Pre-Diploma practice report]]},
    thesis = {ru = [[Выпускная квалификационная работа]], en = nil}
}

local KIND_REPR = {
    solution = {ru = [[в форме \enquote{Решение}]], en = [[in a \foreignquote{english}{Solution} form]]},
    experiment = {ru = [[в форме \enquote{Эксперимент}]], en = [[in an \foreignquote{english}{Experiment} form]]},
    production = {ru = [[в форме \enquote{Производственное задание}]], en = [[in a \foreignquote{english}{Production} form]]},
    comparison = {ru = [[в форме \enquote{Сравнение}]], en = [[in a \foreignquote{english}{Comparison} form]]},
    theoretical = {ru = [[в форме \enquote{Теоретическое исследование}]], en = [[in an \foreignquote{english}{Theoretical research} form]]},
    bachelor = {ru = [[бакалавриат]], en = [[bachelor]]},
    master = {ru = [[магистратура]], en = [[masters]]}
}

-- Public API functions
function M.typeset(field_path)
    local keys = split_field(field_path)
    local value = deep_get(M.records, keys)
    return value or "" -- Return empty string instead of nil for LaTeX safety
end

function M.is_field_given(field_path)
    local keys = split_field(field_path)
    local value = deep_get(M.records, keys)
    return choice(value, LATEX_BOOL_TRUE, LATEX_BOOL_FALSE)
end

function M.is_lang_ru(lang_code)
    return choice((lang_code == 'ru'), LATEX_BOOL_TRUE, LATEX_BOOL_FALSE)
end

function M.load()
    -- Load configuration file
    local ok, records = pcall(dofile, "records.lua")
    if not ok then
        error("Failed to load records.lua: " .. tostring(records))
    end
    
    M.records = records
    
    -- Extract and process report metadata
    local report_type = M.records.report.type
    local report_kind = M.records.report.kind
    local is_thesis = (report_type == 'thesis')
    
    -- Set boolean flags for LaTeX
    M.is_thesis = choice(is_thesis, LATEX_BOOL_TRUE, LATEX_BOOL_FALSE)
    M.is_report = choice(not is_thesis, LATEX_BOOL_TRUE, LATEX_BOOL_FALSE)
    
    -- Process report type and kind representations
    M.records.report.type = {
        value = report_type,
        repr = TYPE_REPR[report_type] or {}
    }
    
    M.records.report.kind = {
        value = report_kind,
        repr = {}
    }
    
    if is_thesis then
        local is_masters = (report_kind == 'master')
        M.records.report.type.repr.en = choice(is_masters, [[Master's thesis]], [[Bachelor's thesis]])
        M.records.report.kind.repr = KIND_REPR[choice(is_masters, 'master', 'bachelor')] or {}
    else
        M.records.report.kind.repr = KIND_REPR[report_kind] or {}
    end
    
    return M
end

return M
