\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{configuration/teaching}[2025/09/07 LaTeX class for teaching files]
\DeclareOption{seminar}{%
  \newcommand{\SeminarName}{}
  \newcommand{\SeminarDate}{}
  \AtBeginDocument{%
    % Метаданные:
    \title{\SeminarName}%
    \date{\SeminarDate}%
    % Настраиваем колонтитулы
    \pagestyle{fancy}%
    \lhead{\PracticeSpeciality, \PracticeUni, курс \PracticeCourse}%
    \chead{\PracticeSubject. Практика}%
    \rhead{\SeminarDate}%
    % Название практики
    \section*{\strtitle}%
  }
}
\DeclareOption{homework}{%
  \newcommand{\HomeworkNumber}{}
  \newcommand{\HomeworkDeadline}{}
  \AtBeginDocument{%
    % Метаданные:
    \title{Д.З. \HomeworkNumber}%
    \date{\HomeworkDeadline}%
    % Настраиваем колонтитулы
    \pagestyle{fancy}%
    \lhead{\PracticeSpeciality, \PracticeUni, курс \PracticeCourse}%
    \chead{\PracticeSubject. Д.З. №\HomeworkNumber}%
    \rhead{Дедлайн: \HomeworkDeadline}%
  }
}
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{article}}
\ProcessOptions\relax
\LoadClass[a4paper]{article}

\RequirePackage{geometry} % Настройка страницы
\geometry{%
  a4paper,
  margin=1cm,
  includefoot,
  includehead
}

\input{preamble.tex}
\RequirePackage{macroses/references}
\RequirePackage{macroses/mathematics}
\RequirePackage{macroses/typesetting}
\RequirePackage{macroses/floats}

% Доступ к полям комманд \author{...} и \date{...}
\title{Unknown} % Инициализируем \@title и \@date
\date{Unknown}  % чтобы \edef работал корректно
\makeatletter
\def\strtitle{\@title}
\def\strdate{\@date}
\makeatother

\directlua{records = require('build/records')}
\newcommand{\PracticeSubject}{\directlua{tex.sprint(records.subject)}}
\newcommand{\PracticeSpeciality}{\directlua{tex.sprint(records.speciality)}}
\newcommand{\PracticeCourse}{\directlua{tex.sprint(records.course)}}
\newcommand{\PracticeUni}{\directlua{tex.sprint(records.uni)}}


\RequirePackage{ifthen}



\newcounter{boxlblcounter}
\newcommand{\task}[1]{\fbox{\begin{minipage}{4em}\centering\it #1\end{minipage}}}
\newcommand{\makeboxlabel}[1]{\fbox{\begin{minipage}{2em}\centering\it #1\end{minipage}}\hfill}% \hfill fills the label box
\newenvironment{tasklist}
  {\begin{list}
    {\arabic{boxlblcounter}}
    {\usecounter{boxlblcounter}
     \setlength{\labelwidth}{3em}
     \setlength{\labelsep}{0em}
     \setlength{\itemsep}{2pt}
     \setlength{\leftmargin}{1.5cm}
     \setlength{\rightmargin}{2cm}
     \setlength{\itemindent}{0em}
     \let\makelabel=\makeboxlabel
    }
  }{\end{list}}


\newboolean{ShowHint}
\newboolean{ShowSolution}

% Подсказка
\newcommand{\hint}[1]{\ifthenelse{\boolean{ShowHint}}{\noindent\rotatebox[origin=c]{180}{\noindent
\begin{minipage}[t]{\linewidth} \noindent \it Указание: #1 \end{minipage}}}{}}

% solution: окружение для набора решений
% solution*: форсировано показывает решение, независимо от флага
\makeatletter
\newenvironment{solution*}[1][\text{Решение}]{
  \par
  \pushQED{\qed}%
  \normalfont
  \topsep0pt \partopsep3pt
  \trivlist
  \item[\hskip\labelsep
    \itshape
    #1\@addpunct{.}]\ignorespaces
}{
  \ifthenelse{\boolean{ShowSolution}}{
    \popQED\endtrivlist\@endpefalse
    \addvspace{6pt plus 6pt} % some space after
  }{\end{hidden}}
}
\makeatother

%https://tex.stackexchange.com/questions/533218/hiding-an-environment-that-contains-minted-code
%https://tex.stackexchange.com/questions/38150/in-lualatex-how-do-i-pass-the-content-of-an-environment-to-lua-verbatim
\RequirePackage{luacode}
\begin{luacode*}
do
    function eat_buffer(buf)
        i,j = string.find(buf,"\\end{solution}")
        if i==nil then return "" else return nil end
    end
    function start_proccesing_solution(eat)
        if eat then luatexbase.add_to_callback('process_input_buffer', eat_buffer, 'eat_buffer') end
    end
    function stop_proccesing_solution(eat)
        if eat then luatexbase.remove_from_callback('process_input_buffer', 'eat_buffer') end
    end
end
\end{luacode*}
%https://tex.stackexchange.com/questions/537219/conditionals-inside-newcommand-with-empty-argument
%https://tex.stackexchange.com/questions/63223/xparse-empty-arguments
\ExplSyntaxOn
\DeclareExpandableDocumentCommand{\IfNoValueOrEmptyTF}{mmm}{\IfNoValueTF{#1}{#2}{\tl_if_empty:nTF {#1} {#2} {#3}}}
\NewDocumentCommand{\DefaultName}{mm}{\IfNoValueOrEmptyTF{#1}{#2}{#1}}
\ExplSyntaxOff
% WARNING!
% Buggy: one have always have
% \begin{solution}{NAME}
%   ....
% \end{solution}
% EVEN if NAME is empty
% if one starts some text on the same line as \begin{solution} or \end{solution} it could'not be hidden
\newenvironment{solution}[1]%
{
  \ifthenelse{\boolean{ShowSolution}}
    {\begin{solution*}[\DefaultName{#1}{\textit{Решение}}]\directlua{flag_eat=false}}
    {\directlua{flag_eat=true}}
  \directlua{start_proccesing_solution(flag_eat)}
}
{
  \ifthenelse{\boolean{ShowSolution}}{\end{solution*}}{}
  \directlua{stop_proccesing_solution(flag_eat)}
}


