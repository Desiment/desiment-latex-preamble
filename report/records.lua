--- Configuration file containing all necessary information
--- for LaTeX to build the report according to SE template

local records = {
    author = {},
    report = {},
    supervisor = {},
    consultant = {},
    reviewer = {},
    year = {
        ru = 2025,
        en = 2025
    }
}

records.report.title = {
  ru = [[Прототипирование общего ядра проекта PySATL]],
  en = [[Prototyping shared kernel for the PySATL project]]
}

-- Report type: one of 'coursework'/'practice'/'production'/'prediploma'/'thesis'
records.report.type = 'practice'
-- Report kind: depends on type (see loader.lua for details)
records.report.kind = 'experiment'
-- Author information
records.author.name = {
    ru = [[Михайлов Михаил Дмитриевич]],
    en = [[Mikhailov Mikhail Dmitrievich]]
}

records.author.group = {
    ru = [[24.M41]],
    en = [[24.M41]]
}

records.author.speciality = {
    ru = [[02.04.03 \enquote{Математическое обеспечение и администрирование информационных систем}]],
    en = [[02.04.03 \foreignquote{english}{Software and Administration of Information Systems}]]
}

records.author.programme = {
    ru = [[ВМ.5665.2023 Математическое обеспечение и администрирование информационных систем]],
    en = [[ВМ.5665.2023 Software and Administration of Information Systems]]
}

records.author.profile = {
    ru = nil,
    en = nil
}

-- Supervisor information
records.supervisor.name = {
    ru = [[Гориховский~В.~И.]],
    en = [[Gorikhovskiy~V.~I.]]
}

records.supervisor.position = {
    ru = [[доцент кафедры системного программирования, к.~ф.-м.~н.]],
    en = [[C.Sc., docent]]
}

records.supervisor.chair = {
    ru = [[Кафедра системеного программирования]],
    en = [[Software engeenering chair]]
}

-- Consultant information
records.consultant.name = {
    ru = [[Консультантов~К.~К.]],
    en = [[C. C. Consultantov]]
}

records.consultant.position = {
    ru = [[должность, ООО \enquote{Место работы}, степень]],
    en = [[position at \foreignquote{english}{Company}, degree]]
}

-- Reviewer information
records.reviewer.name = {
    ru = [[Рецензентов~Р.~Р.]],
    en = [[R. R. Reviewerov]]
}

records.reviewer.position = {
    ru = [[должность, ООО \enquote{Место работы}, степень]],
    en = [[position at \foreignquote{english}{Company}, degree]]
}

return records
