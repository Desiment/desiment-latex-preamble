\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{termpaper}[2020/12/09 MatMex LaTeX diploma class]

\def\termpaper@fontsize{12pt}
\def\termpaper@baseclass{article}

\NewDocumentCommand\SetupTitlePage{}{}
\NewDocumentCommand\SetupBodyPage{}{}


\RequirePackage{xparse}
\RequirePackage{tooling/fontswitch}
% Если используется опция 14pt то нужно несколько хаков
\DeclareOption{14pt}{
    % во-первых, класс наследуется от extarticle
    \def\termpaper@fontsize{14pt}
    \def\termpaper@baseclass{extarticle}
    % во-вторых, титульный лист должен набираться так, как будто
    % используется шрифт 12pt - иначе он выглядит совсем конским
	\RenewDocumentCommand\SetupTitlePage{}{\SetPageFontSize{12}}
	\RenewDocumentCommand\SetupBodyPage{}{\SetPageFontSize{14}}
}
\ProcessOptions\relax
\LoadClass[a4paper,\termpaper@fontsize]{\termpaper@baseclass}

\RequirePackage[a4paper]{geometry}
\RequirePackage{fancyhdr}
\RequirePackage{setspace}
\setdisplayskipstretch{1.0}


\directlua{termpaper = require('classes/termpaper/recordsloader').load()}
\input{tooling/preamble.tex}
\input{classes/termpaper/title/title.tex}

