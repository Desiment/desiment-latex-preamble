\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{matmex-diploma-custom}[2020/12/09 MatMex LaTeX diploma class]
\def\my@fontsize{12pt}\def\my@baseclass{article}\def\my@title12pt{}\def\my@body14pt{}

% Если используется опция 14pt то нужно несколько хаков
\DeclareOption{14pt}{
    \def\ignore#1{}
    % во-первых, класс наследуется от extarticle
    \def\my@fontsize{14pt}
    \def\my@baseclass{extarticle}

    % во-вторых, титульный лист должен набираться так, как будто
    % используется шрифт 12pt - иначе он выглядит совсем конским
    % Для этого мы явно загружаем size12.clo, но так как он на такое не рассчитан,
    % и использует \newcommand для определения всяких \small и \Large
    % то у нас \newcommand временно превращается в \renewcommand
    \let\orignewcommand\newcommand
    \let\origNeedsTeXFormat\NeedsTeXFormat
    \def\my@title12pt{
        \let\newcommand\renewcommand
        \makeatletter
        \input{size12.clo}%
        \makeatother
        \let\newcommand\orignewcommand
    }
    % в-третьих, после того как титульный лист сгенерирован, нужно снова вернуться
    % к базовому шрифту 14pt. Применяется такой же хак: загрузи size14.clo
    % временно переопределив \newcommand => \renewcommand
    \def\my@body14pt{
        % отдельное внимание подавлению команды \NeedsTeXFormat, которая требует
        % чтобы код size14.clo выполнялся в преамбуле (а тут он уже внутри документа)
        \let\NeedsTeXFormat\ignore
        \let\newcommand\renewcommand
        \makeatletter
        \input{size14.clo}%
        \makeatother
        \let\newcommand\orignewcommand
        \let\NeedsTeXFormat\origNeedsTeXFormat
    }
}
\ProcessOptions\relax
\LoadClass[a4paper,\my@fontsize]{\my@baseclass}

% Поля настраиваются командами \newgeometry во время и после генерации титульных
% страниц и
\usepackage[a4paper]{geometry}

\usepackage{fancyhdr}
\usepackage{ifthen}

%% Мы используем компилятор XeLaTex или LuaLaTeX, который дружит с Unicode и
%% True Type/Open Type шрифтами. Попытка собрать чем-то другим приведет к
%% страшным и непонятным ошибкам, поэтому упадём с понятным сообщением.
\usepackage{iftex}
\ifXeTeX
\else
    \ifLuaTeX
    \else
        %% https://github.com/latex3/iftex/blob/a36f09ed85c47dfd8ab59ae2cc0a8c9fb99c73e1/iftex.sty#L44
        \newlinechar 64\relax
        \errorcontextlines -1\relax
        \immediate\write20{@
            ***********************************************************@
            * XeLaTex or LuaLaTex is required to compile this document.@
            * Sorry!@
            ***********************************************************}%
        \batchmode\read -1 to \@tempa
    \fi
\fi

%% Для русификации достаточно подключить пакет fontspec и
%% выбрать Unicode шрифт в котором есть кириллические глифы. Ниже
%% основным шрифтом выбирается Unicode версия шрифта Computer Modern с заcечками
\usepackage{fontspec}
\setmainfont{CMU Serif}
\setsansfont{CMU Sans Serif}
\setmonofont{CMU Typewriter Text}
%\setmonofont{Fira Code}[Contextuals=Alternate,Scale=0.9]
%\setmonofont{Inconsolata}
% \newfontfamily\cyrillicfont{CMU Serif}

%% В XeLaTex или LuaLaTeX альтернативой известного пакета babel является пакет polyglossia.
%% Теперь у нас будут переносы слов
\usepackage{polyglossia}
\setdefaultlanguage{russian}
\setotherlanguage{english}

% \addto\captionsrussian{%
%   \renewcommand{\figurename}{Рис.}%
%   \renewcommand{\tablename}{Табл.}%
% }

% Основные необходимые пакеты и команды.

%%% Пакеты
%% Графика
\usepackage[table]{xcolor} % Работа с цветами
\usepackage{graphicx} % Вставка графики в текст (изображения, в т.ч. pdf)
\graphicspath{ {figures/} } % Задает папку по-умолчанию для графики

\usepackage{wrapfig2} % Позволяет вставлять графику, обтекаемую текстом
\usepackage{caption} % Настройка подписей "не текста"
\usepackage{subcaption} % Подписи для разделенного "не текста"

%% Математика
\usepackage{amsmath, amsfonts, amssymb, amsthm, mathtools} % "Адекватная" работа с математикой в LaTeX
\usepackage{thmtools} % Мощный пакет для работы с математическими окружениями типа "теорема"
\usepackage{thm-restate} % Дополнение к предыдущему пакету, позволяющее повторять теоремы

%% Таблицы
\usepackage{tabularx} % Добавляет столбец типа "X", который автоматически занимает максимально возможное место
\usepackage{makecell} % Позволяет кастомизировать ячейки таблицы

%% Код
\usepackage{listings} % Позволяет вставлять код в документ
% Перевод заголовков в листингах
\renewcommand\lstlistingname{Листинг}
\renewcommand\lstlistlistingname{Листинги}
% Отступ перед подписью листинга
\DeclareCaptionFormat{listing}{
    \hspace{15pt}#1#2#3
}
\captionsetup[lstlisting]{
    format=listing,
    margin=0pt,
    font={bf}
}
\lstset{
    mathescape=true,
    identifierstyle=\ttfamily,
    keywordstyle=\bfseries,
    commentstyle=\scriptsize\rmfamily,
    basewidth={0.5em,0.5em},
    fontadjust=true,
}

% Требует Python с пакетом pygmentize, зато позволяет верстать очень годные листинги с синтаксической подсветкой
\usepackage[kpsewhich,newfloat]{minted}

% Запретим minted подсвечивать по его мнению лексические ошибки
\AtBeginEnvironment{minted}{\dontdofcolorbox}
\def\dontdofcolorbox{\renewcommand\fcolorbox[4][]{##4}}

\SetupFloatingEnvironment{listing}{name=Листинг}
\SetupFloatingEnvironment{listing}{listname=Листинги}
\captionsetup[listing]{
    format=listing,
    margin=0pt,
    font={bf}
}

%% Текст
\usepackage[inline]{enumitem} % Настройка списков, а так же "строчные" списки
% \setitemize{noitemsep,topsep=0pt,parsep=0pt,partopsep=0pt}
% \setenumerate{noitemsep,topsep=0pt,parsep=0pt,partopsep=0pt}

\usepackage[useregional]{datetime2} % Форматирование дат
\usepackage[normalem]{ulem} % Дополнительные варианты форматирования текста, например подчеркивание или зачеркивание
\usepackage{microtype} % Полезные типографические ништячки, по-хорошему требует LuaLaTeX
\usepackage[autostyle]{csquotes} % Правильные кавычки в зависимости от языка

%% Разное
\usepackage{afterpage} % Выполнение команд после разрыва страниц
\usepackage{pdflscape} % Правильное отображение альбомной страницы в pdf файле

