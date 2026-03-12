%% 
%% This is file `electhesis.cls', generated on <1994/12/2> 
%% with the docstrip utility (2.2h).
%% 
%% The original source file was `electhesis.dtx'.
%% Included options: `class'.
%% 
%% 
%% IMPORTANT NOTICE:
%% You are not allowed to distribute this file.
%% For distribution of the original source see
%% the copyright notice in the file electhesis.dtx.
%% 
%% \CharacterTable
%%  {Upper-case    \A\B\C\D\E\F\G\H\I\J\K\L\M\N\O\P\Q\R\S\T\U\V\W\X\Y\Z
%%   Lower-case    \a\b\c\d\e\f\g\h\i\j\k\l\m\n\o\p\q\r\s\t\u\v\w\x\y\z
%%   Digits        \0\1\2\3\4\5\6\7\8\9
%%   Exclamation   \!     Double quote  \"     Hash (number) \#
%%   Dollar        \$     Percent       \%     Ampersand     \&
%%   Acute accent  \'     Left paren    \(     Right paren   \)
%%   Asterisk      \*     Plus          \+     Comma         \,
%%   Minus         \-     Point         \.     Solidus       \/
%%   Colon         \:     Semicolon     \;     Less than     \<
%%   Equals        \=     Greater than  \>     Question mark \?
%%   Commercial at \@     Left bracket  \[     Backslash     \\
%%   Right bracket \]     Circumflex    \^     Underscore    \_
%%   Grave accent  \`     Left brace    \{     Vertical bar  \|
%%   Right brace   \}     Tilde         \~}
\def\fileversion{v0.9h}
\def\filedate{1994/12/02}
\def\docdate{1994/12/02}
\NeedsTeXFormat{LaTeX2e}[1994/06/01]
\ProvidesClass{electhesis}[\filedate\space Elec. Eng. thesis class]
\typeout{Elec. Eng. Thesis Class `electhesis' <\filedate>. BETA VERSION.}
\typeout{}
\typeout{Please note that this is a BETA version of electhesis.}
\typeout{If you encounter any problems or bugs in using it please email a message}
\typeout{to latex@elec.canterbury.ac.nz.}
\typeout{}
\def\@basedonclass{book}
\newif\if@elecdraft
\@elecdraftfalse
\newif\if@elecrac
\@elecracfalse
\DeclareOption{draft}{%
  \@elecdrafttrue
  \PassOptionsToClass{draft}{\@basedonclass}
  \typeout{Making DRAFT Copy}
}
\DeclareOption{final}{%
  \@elecdraftfalse
  \PassOptionsToClass{final}{\@basedonclass}
}
\DeclareOption{dottoc}{%
  \AtEndOfClass{\renewcommand\@dotsep{4.5}}}
\DeclareOption{refafterchap}{%
  \ClassWarning{electhesis}{Option currently not implemented}}
\DeclareOption{noupcase}{%
  \AtEndOfClass{%
    \renewcommand\ChapterNumberCase{}
    \renewcommand\ChapterTitleCase{}
    \renewcommand\SectionCase{}
}}
\DeclareOption{eleccite}{%
  \AtEndOfClass{\RequirePackage{eleccite}}}
\DeclareOption{10pt}{\@latexerr{Option not supported.}}
\DeclareOption{12pt}{\@latexerr{Option not supported.}}
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{\@basedonclass}}
\ProcessOptions
\PassOptionsToClass{a4paper,11pt}{\@basedonclass}
\LoadClass{\@basedonclass}
\RequirePackage{setspace}
\def\chk@dimen#1#2#3#4{%
  \@tempdima=        #1
  \advance\@tempdima by#3
  \advance\@tempdima -\paperwidth
  \@tempdimb=        #2
  \advance\@tempdimb by#4
  \advance\@tempdimb \headheight
  \advance\@tempdimb \headsep
  \advance\@tempdimb \footskip
  \advance\@tempdimb -\paperheight
  \ifnum\@tempdima>\z@\ClassWarning{electhesis}{Horizontal dimensions
    exceed paper width by \the\@tempdima}\fi\relax
  \ifnum\@tempdimb>\z@\ClassWarning{electhesis}{Vertical dimensions
    exceed paper height by \the\@tempdimb}\fi\relax
}
\newcommand\SetMargins[7]{%
  \oddsidemargin -1in\evensidemargin -1in\topmargin -1in
  \textwidth          \paperwidth
  \advance\textwidth  -#1
  \advance\textwidth  -#3
  \textheight         \paperheight
  \advance\textheight  -#2
  \advance\textheight  -#5
  \advance\textheight  -#6
  \advance\textheight  -#7
  \advance\textheight  -#4
  \advance\oddsidemargin  #1
  \advance\evensidemargin \paperwidth
  \advance\evensidemargin -#1
  \advance\evensidemargin -\textwidth
  \advance\topmargin  #2
  \headheight  #5
  \headsep     #6
  \footskip    #7
  \@settopoint\textwidth
  \chk@dimen{#1}{#2}{\textwidth}{\textheight}}
\SetMargins{4.0cm}{2.5cm}{2.5cm}{1cm}{11pt}{10mm}{1.5cm}
\newcommand\PageFont{\small}
\newcommand\HeadFont{\footnotesize}
\newcommand\HeadCase{\uppercase}
\newcommand\FootFont{\footnotesize}
\newcommand\FootCase{}
\def\ps@headings{%
  \if@elecdraft
    \def\@oddfoot{\reset@font\FootFont\hfil{\draftname} \today}%
    \def\@evenfoot{\reset@font\FootFont{\draftname} \today\hfil}%
  \else
    \let\@oddfoot\@empty
    \let\@evenfoot\@empty
  \fi
  \def\@evenhead{\reset@font\PageFont\thepage \hfil \HeadFont\leftmark}%
  \def\@oddhead{\reset@font\HeadFont\rightmark \hfil \PageFont\thepage}%
  \let\@mkboth\markboth
  \def\chaptermark##1{%
    \markboth {\HeadCase{\ifnum \c@secnumdepth >\m@ne
    \if@mainmatter
      \@chapapp\ \thechapter \hskip 1em \fi
      \fi
    ##1}}{%
    \HeadCase{\if@mainmatter \else ##1 \fi}}}%
  \def\sectionmark##1{%
    \markright {\HeadCase{\ifnum \c@secnumdepth >\z@
    \thesection \hskip 1em\fi
    ##1}}}}
\def\ps@plain{%
  \if@elecdraft
    \def\@oddfoot{\reset@font\FootFont\hfil{\draftname} \today}%
    \def\@evenfoot{\reset@font\FootFont{\draftname} \today\hfil}%
  \else
    \let\@oddfoot\@empty
    \let\@evenfoot\@empty
  \fi
  \def\@evenhead{\reset@font\PageFont \thepage\hfil}%
  \def\@oddhead{\reset@font\PageFont \hfil\thepage}%
  \let\@mkboth\@gobbletwo
}
\def\ps@empty{%
  \if@elecdraft
    \def\@oddfoot{\reset@font\FootFont\hfil{\draftname} \today}%
    \def\@evenfoot{\reset@font\FootFont{\draftname} \today\hfil}%
  \else
    \let\@oddfoot\@empty
    \let\@evenfoot\@empty
  \fi
  \let\@evenhead\@empty
  \let\@oddhead\@empty
  \let\@mkboth\@gobbletwo
}
\def\cleardoublepage{%
  \clearpage
  \if@twoside
    \ifodd \c@page
    \else
      \hbox{}\thispagestyle{empty}\newpage
      \if@twocolumn\hbox{}\newpage
  \fi\fi\fi}
\clubpenalty         300
\widowpenalty        300
\displaywidowpenalty 100
\brokenpenalty       150
\parskip   0.5ex plus 2pt
\parindent 20pt
\if@elecdraft
  %% \AtBeginDocument patched in by Volker, 9 Jan 95
  \AtBeginDocument\doublespacing
\else
  %% \AtBeginDocument patched in by Volker, 9 Jan 95
  \AtBeginDocument\onehalfspacing
\fi
\newcommand\department[1]{\gdef\@department{#1}}
\newcommand\school[1]{\gdef\@school{#1}}
\newcommand\address[1]{\gdef\@address{#1}}
\newcommand\phdthesis{%
  \gdef\@degree{Doctor of Philosophy}%
  \gdef\@thesismessage{A thesis presented for the degree of}}
\newcommand\methesis{%
  \gdef\@degree{Master of Engineering}%
  \gdef\@thesismessage{A thesis presented for the degree of}}
\newcommand\mereport{%
  \gdef\@degree{Master of Engineering}%
  \gdef\@thesismessage{A report presented for the degree of}}
\newcommand\mastersthesis{%
  \ClassError{electhesis}
    {\string\mastersthesis\space command is obsolete. Use \string\methesis}
    {Use the \string\methesis\space command.}
  \methesis}
\newcommand\mastersreport{%
  \ClassError{electhesis}
    {\string\mastersreport\space command is obsolete. Use \string\mereport}
    {Use the \string\mereport\space command.}
  \mereport}
\newcommand\degree[1]{\gdef\@degree{#1}}
\newcommand\thesismessage[1]{\gdef\@thesismessage{#1}}
\department{Software Engineering}
\school{University of Canterbury}
\address{Christchurch, New Zealand}
\date{February 2007}
\methesis
\renewcommand\maketitle{\begin{titlepage}%
  \parskip 0pt plus 1pt
  \parindent 0pt
  \renewcommand\baselinestretch{1.2}
  \let\footnotesize\small
  \let\footnoterule\relax
  \null\vskip 30mm
  \begin{center}
  {\huge \bfseries \noindent
  \parbox{0.9\textwidth}{
    \begin{center}
    \@title
    \end{center}}}
  \vskip 13mm
  {\Large \noindent \@author}
  \vfill
  {\large \noindent
     \@thesismessage \\
     \@degree \\
     in \\
     \@department \\
     at the \\
     \@school, \\
     \@address.  \\[3mm]
     \@date}
  \end{center}
  \vskip 20mm
  \end{titlepage}%
  \setcounter{footnote}{0}%
  \let\thanks\relax\let\maketitle\relax
  \gdef\@thanks{}\gdef\@author{}\gdef\@title{}%
  \gdef\@department{}\gdef\@school{}\gdef\@address{}%
  \gdef\@degree{}\gdef\@thesismessage{}}
\def\ChapterNumberFont{\normalfont\LARGE\bfseries}
\def\ChapterTitleFont{\normalfont\Large\bfseries}
\def\SectionFont{\normalfont\large\bfseries}
\def\SubsectionFont{\normalfont\large\bfseries}
\def\SubsubsectionFont{\normalfont\bfseries}
\newcommand\ChapterNumberCase{\uppercase}
\newcommand\ChapterTitleCase{\uppercase}
\newcommand\SectionCase{\uppercase}
\renewcommand\chapter{\if@openright\cleardoublepage\else\clearpage\fi
                    \thispagestyle{empty}%
                    \global\@topnum\z@
                    \@afterindentfalse
                    \secdef\@chapter\@schapter}
\def\@chapter[#1]#2{%
  \ifnum \c@secnumdepth >\m@ne
     \if@mainmatter
       \refstepcounter{chapter}
       \typeout{\@chapapp\space\thechapter.}
       \addcontentsline{toc}{chapter}{%
         \protect\numberline{\ChapterNumberCase{\@chapapp\ \thechapter}}%
         \ChapterNumberCase{#1}}%
     \else
       \addcontentsline{toc}{chapter}{\ChapterNumberCase{#1}}\fi
   \else
     \addcontentsline{toc}{chapter}{\ChapterNumberCase{#1}}\fi
   \chaptermark{#1}%
   \addtocontents{lof}{\protect\addvspace{10pt}}%
   \addtocontents{lot}{\protect\addvspace{10pt}}%
   \if@twocolumn
      \@topnewpage[\@makechapterhead{#2}]%
   \else
      \@makechapterhead{#2}%
      \@afterheading
   \fi}
\def\@makechapterhead#1{%
  \vspace*{50pt}%
  { \parindent 0pt
    \parskip 0pt plus 1pt
    \renewcommand\baselinestretch{1.0}
    \raggedright \reset@font
    \ifnum \c@secnumdepth >\m@ne
      \if@mainmatter
        \ChapterNumberFont
        \expandafter\ChapterNumberCase\expandafter{\@chapapp\ \thechapter}%
        %\par
        \vskip 0pt \fi \fi
    \rule{\hsize}{1pt}\par
    \vskip 1.5mm
    \ChapterTitleFont \expandafter\ChapterTitleCase\expandafter{#1}\par
    \nobreak
    \vskip 40pt
}}
\def\@makeschapterhead#1{%
  \vspace*{50pt}%
  { \parindent 0pt
    \parskip 0pt plus 1pt
    \renewcommand\baselinestretch{1.0}
    \raggedright \reset@font
    \rule{\hsize}{1pt}\par
    \vskip 1.5mm
    \ChapterTitleFont \expandafter\ChapterTitleCase\expandafter{#1}\par
    \nobreak
    \vskip 40pt
}}
\def\section{\@tempswafalse\@ifstar{\@tempswatrue\@dblarg
     {\pgsect}}{\@dblarg{\pgsect}}}
\def\pgsect[#1]#2{\if@tempswa \pgsection*{\raggedright\SectionCase{#2}}\else
      \pgsection[#1]{\raggedright\SectionCase{#2}}\fi}
\def\pgsection{\@startsection {section}{1}{\z@}{-3.5ex plus -1ex minus
      -.2ex}{2.3ex plus .2ex}{\SectionFont}}
\renewcommand\subsection{\@startsection{subsection}{2}{\z@}%
                                     {-3.25ex\@plus -1ex \@minus -.2ex}%
                                     {1.5ex \@plus .2ex}%
                                     {\SubsectionFont}}
\renewcommand\subsubsection{\@startsection{subsubsection}{3}{\z@}%
                                     {-3.25ex\@plus -1ex \@minus -.2ex}%
                                     {1.5ex \@plus .2ex}%
                                     {\SubsubsectionFont}}
\setcounter{secnumdepth}{3}
\newenvironment{abstract}{%
  \chapter*{\abstractname}}{}
\newenvironment{acknowledgement}{%
  \chapter{\acknowledgementname}}{}
\newenvironment{preface}{%
  \chapter{\prefacename}}{}
\newenvironment{theglossary}[1]{%
  \list{}{%
    \settowidth\labelwidth{#1}%
    \def\makelabel##1{##1\hfil}%
    \let\glossitem=\item}
}{%
  \endlist}
\newcommand{\glossref}[1]{(p.~\pageref{#1})}
\newcommand{\glossrefs}[2]{(pp.~\pageref{#1},~\pageref{#2})}
\renewenvironment{titlepage}
  { \cleardoublepage
    \if@twocolumn
      \@restonecoltrue\onecolumn
    \else
      \@restonecolfalse\newpage
    \fi
    \thispagestyle{empty}%
    \setcounter{page}{1}%
  }%
  { \if@restonecol\twocolumn \else \newpage \fi
  }
\long\def\@makecaption#1#2{
   \vskip\abovecaptionskip
   \sbox\@tempboxa{\footnotesize {\bfseries #1}\hskip 1em #2}
   \ifdim \wd\@tempboxa >\hsize
      \footnotesize {\bfseries #1}\hskip 1em #2\par
   \else
     \hbox to\hsize{\hfil\box\@tempboxa\hfil}%
   \fi
   \vskip\belowcaptionskip}
\let\oldtableofcontents\tableofcontents
\renewcommand\tableofcontents{%
  \begingroup
  \renewcommand\baselinestretch{1.1}
  \reset@font
  \parskip 0pt plus 1pt
  \parindent 0pt\relax
  \oldtableofcontents
  \endgroup
}
\renewcommand\@dotsep{10000}
\renewcommand\l@chapter[2]{%
  \ifnum \c@tocdepth >\m@ne
    \addpenalty{-\@highpenalty}%
    \vskip 1.0em \@plus\p@
    \setlength\@tempdima{7.8em}%
    \begingroup
      \parindent \z@ \rightskip \@pnumwidth plus 1fil
      \parfillskip -\@pnumwidth
      \leavevmode \bfseries
      \advance\leftskip\@tempdima
      \hskip -\leftskip
      #1\nobreak\hfill \nobreak\hbox to\@pnumwidth{\hss #2}\par
      \penalty\@highpenalty
    \endgroup
  \fi}
\renewcommand\l@section      {\@dottedtocline{1}{7.8em}{2.3em}}
\renewcommand\l@subsection   {\@dottedtocline{2}{10.1em}{3.2em}}
\renewcommand\l@subsubsection{\@dottedtocline{3}{13.3em}{4.1em}}
\setcounter{tocdepth}{3}
\def\prefacebib#1{%
  \begingroup
  \def\@lbibitem[##1]##2{%
    \item\ignorespaces}
  \def\@bibitem[##1]##2{%
    \item\ignorespaces}
  \def\thebibliography##1{\relax
    \list{}{\labelwidth 0em\itemindent-\leftmargin}\relax
    \def\newblock{\hskip .11em plus .33em minus -.07em}%
    \sloppy\clubpenalty=4000\widowpenalty=4000%
    \sfcode`\.=1000}%
  \def\endthebibliography{%
     \def\@noitemerr{\@latex@warning{Empty `prefacebib'}}%
     \endlist}
  \input{#1.bbl}
  \endgroup }
\renewcommand\today{\number\day \space
\ifcase \month \or January\or February\or March\or April\or
May\or June\or July\or August\or September\or October\or
November\or December\fi
\space \number\year}
\newcommand\abstractname{Abstract}
\newcommand\acknowledgementname{Acknowledgements}
\newcommand\prefacename{Preface}
\newcommand\draftname{\textbf{Draft}}
\renewcommand{\bibname}{References}
\pagestyle{headings}
\showboxdepth=-1
\endinput
%% 
%% End of file `electhesis.cls'.
