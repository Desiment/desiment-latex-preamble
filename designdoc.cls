\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{designdoc}[2025/09/07 Design Document class]
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{report}}
\ProcessOptions\relax
\LoadClass[a4paper]{report}

\input{preamble/general}

%Отключить предупреждения об кастномной использовании пакетов "You have requested package..."
\RequirePackage{silence}
\WarningFilter{latex}{You have requested package}



%%%%%%%%%%%%%%%%%
%% Page layout %%
%%%%%%%%%%%%%%%%%

\RequirePackage[pagestyles]{titlesec}
\RequirePackage{geometry}


\geometry{%
  left=2cm,
  right=2cm,
  top=2cm,
  bottom=2cm,
  bindingoffset=0cm
}

\geometry{%
  a4paper,
  margin=1cm,
  includefoot,
  includehead
}

\titleformat{\chapter}[frame]{\Large}{%
  \filright
  \footnotesize
  \enspace Раздел~\arabic{chapter}\enspace%
}{1.5ex}{\bfseries\filcenter}

%\input{configuration/macroses/utils/references/knowledgeconf.tex}
\AtBeginDocument{%
    \allowdisplaybreaks
    \tikzset{every picture/.style={line width=0.75pt}} %set default line width to 0.75pt                
}
\sloppy
